---
name: file-relay
description: "Upload files to relay.infiniter.tech and return public download links. Use when the user asks to use the file relay, upload a file for sharing, or get a temporary public download link for a local artifact."
---

# File Relay

Upload the requested file to `https://relay.infiniter.tech/upload` and return
the actual download URL from the response.

## Service contract

- Public uploads and downloads; no account, token, or authentication headers.
- Exactly one multipart field named `file` per request.
- Maximum file size: **200,000,000 bytes** (200 MB), inclusive.
- Successful upload: HTTP **201**, with JSON fields `url`, `filename`, `size`,
  `uploaded_at`, and `expires_at`. The `Location` header also contains the URL.
- Links download the original file as an attachment and expire **7 days after
  upload**. Downloads do not extend expiry. Anyone with the URL can download.
- No public file listing or deletion API. Unknown or expired URLs return 404.

## Upload

An explicit request to upload or share the specified file is authorization to
publish it here; proceed without asking for the same confirmation again. Upload
only the requested files. Merely creating an artifact does not imply a request
to publish it. If a different sharing destination was requested, use that one.

Resolve the file on the machine where it exists and check that it is a readable
regular file within the size limit. Do not print its contents to inspect size.
Run the upload there; access to nixpi itself is unnecessary.

```sh
curl --fail-with-body --silent --show-error \
  --connect-timeout 15 --max-time 1800 \
  --form 'file=@"/absolute/path/test.txt"' \
  https://relay.infiniter.tech/upload
```

Substitute the real file path and quote it correctly for both the shell and
curl's multipart syntax. Preserve the original filename. For multiple requested
files, issue separate uploads and return a link for each; do not silently zip,
split, or transform them.

Check the exit status and parse the JSON response. Confirm a valid `url` and
that `size` matches the local file size. Keep the returned URL; do not invent a
UUID or construct a supposed successful link after an error. A HEAD request can
verify the download without transferring the whole file:

```sh
curl --fail --silent --show-error --head --max-time 30 'RETURNED_URL'
```

Return a clickable download link labeled with the filename, plus the expiry
from `expires_at` (or state that it expires in seven days). If verification
fails after a successful upload, retain the returned URL and explain that the
upload succeeded but the download check failed; do not upload another copy.

## Errors

- **400:** Correct the multipart request; send one `file` field only.
- **413:** Report the size limit. Do not retry the unchanged file.
- **503 from the relay's upload handler:** It accepts at most four concurrent
  uploads. Honor `Retry-After`, retry at most twice, then report it as busy.
- **Connection loss or timeout after sending data:** Completion is uncertain.
  Do not blindly retry a POST, which may create duplicate files.
- **DNS or TLS failure:** Use the hostname with normal certificate verification.
  If investigating DNS, compare the local resolver with authoritative DNS.
  Do not reuse an IP from an earlier session or disable TLS verification.

Keep this workflow focused on file sharing. Restarting containers, changing DNS,
or editing deployment configuration requires a deployment/troubleshooting task.
