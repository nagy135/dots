---
name: html-share
description: "Publish an HTML file on nixpi at html.infiniter.tech and return a public browser link. Use when the user invokes $html-share or asks to share an HTML page through this host."
---

# HTML Share

Copy the requested HTML file to nixpi and return its public URL. Use the
existing static host directly; no Sites project, file relay, Nix rebuild or
application service is needed for an upload.

## Destination

- SSH: `infiniter@nixpi.tail6650cb.ts.net`
- Upload folder: `/var/www/html-sharing`
- File `example.html` is served at `https://html.infiniter.tech/example`.
- Links are public and stay available until their file is removed. There is
  no automatic expiry or public directory listing.

## Upload

An invocation with a file, or a request to share the HTML artifact from the
current task, authorizes publishing that file. Proceed without asking again.
If the intended artifact cannot be identified from context, ask which file.

Use a readable, standalone HTML file. Embed local assets or use public asset
URLs so the page works away from the original machine. Keep the local original.

Choose a short, descriptive URL slug containing only lowercase ASCII letters,
digits and hyphens, starting with a letter. Use a requested name when supplied.
Check whether `/var/www/html-sharing/<slug>.html` already exists. Unless the user
is updating that page, choose another slug, such as one with a date suffix.

Run the transfer on the machine containing the file. Substitute the actual
absolute path and safe slug in these commands:

```sh
html_file='/absolute/path/page.html'
html_slug='example'

scp "$html_file" \
  "infiniter@nixpi.tail6650cb.ts.net:/var/www/html-sharing/.${html_slug}.html.upload"

ssh -o BatchMode=yes infiniter@nixpi.tail6650cb.ts.net \
  "chmod 644 /var/www/html-sharing/.${html_slug}.html.upload && mv /var/www/html-sharing/.${html_slug}.html.upload /var/www/html-sharing/${html_slug}.html"

curl --fail --silent --show-error --head --max-time 30 \
  "https://html.infiniter.tech/${html_slug}"
```

The hidden staging file prevents a partial upload from being served. Rename
only after `scp` succeeds; check both commands' exit statuses. Use a distinct
hidden staging name if multiple uploads to the same slug might run concurrently.

Confirm the public URL returns HTTP 200 with `Content-Type: text/html`, then
return a clickable link to `https://html.infiniter.tech/<slug>`. Do not stop at
showing an `scp` command when the user requested the upload itself.

If transfer or verification fails, report the exact failure and which steps
succeeded. Preserve a successfully uploaded page instead of uploading duplicate
copies to troubleshoot a stale DNS cache. Do not disable TLS or SSH host-key
verification. DNS, certificates and Nix configuration changes require a separate
deployment or troubleshooting request.
