#!/usr/bin/env python3
"""Private audio notifications; credentials stay out of command-line arguments."""
import argparse
import json
import os
from pathlib import Path
import sys
import time
import urllib.error
import urllib.request
import urllib.parse
import uuid


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    send = sub.add_parser('send')
    send.add_argument('text')
    send.add_argument('--device')
    send.add_argument('--ttl', type=int, default=300)
    send.add_argument('--wait', type=int, default=0)
    send.add_argument('--key', default=None)
    sub.add_parser('devices')
    sub.add_parser('pair-code')
    status = sub.add_parser('status'); status.add_argument('id')
    args = parser.parse_args()
    config_path = Path(os.environ.get('AUDIO_NOTIFY_CONFIG', '~/.config/audio-notifications/client.json')).expanduser()
    config = json.loads(config_path.read_text())

    def api(path, data=None, key=None):
        headers = {'Authorization': 'Bearer ' + config['token'], 'Content-Type': 'application/json'}
        if key: headers['Idempotency-Key'] = key
        request = urllib.request.Request(config['url'].rstrip('/') + path, headers=headers,
                                         data=None if data is None else json.dumps(data).encode())
        try:
            with urllib.request.urlopen(request, timeout=20) as response: return json.load(response)
        except urllib.error.HTTPError as e:
            raise RuntimeError('Server returned HTTP %s: %s' % (e.code, e.read().decode()[:500])) from None
        except (urllib.error.URLError, TimeoutError):
            raise RuntimeError('Server unreachable or request timed out. Check Tailscale. A send may have completed; reuse its idempotency key.') from None

    if args.command == 'devices': result = api('/v1/devices')
    elif args.command == 'pair-code': result = api('/v1/pairing', {})
    elif args.command == 'status': result = api('/v1/messages/' + urllib.parse.quote(args.id, safe=''))
    else:
        key = args.key or str(uuid.uuid4())
        print(json.dumps({'idempotencyKey': key}), file=sys.stderr, flush=True)
        payload = {'text': args.text, 'ttlSeconds': args.ttl}
        if args.device: payload['deviceId'] = args.device
        result = api('/v1/messages', payload, key)
        deadline = time.monotonic() + max(0, args.wait)
        while args.wait > 0 and any(d['status'] == 'queued' for d in result['deliveries']) and time.monotonic() < deadline:
            time.sleep(min(1, max(0, deadline-time.monotonic())))
            result = api('/v1/messages/' + result['id'])
    print(json.dumps(result, indent=2))
    if args.command == 'send' and args.wait > 0 and not all(d['status'] == 'spoken' for d in result['deliveries']): return 2
    return 0

if __name__ == '__main__':
    try: sys.exit(main())
    except (OSError, ValueError, KeyError, RuntimeError) as exc:
        print(str(exc), file=sys.stderr); sys.exit(1)
