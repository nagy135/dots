---
name: fleet-work
description: Work across Viktor's Mac and NixOS fleet using T3 Code, SSH, and Git, including the sensory-minds Mac relay workflow.
---

# Fleet work

## Devices and configuration

| Device | Access from the Mac | System configuration |
| --- | --- | --- |
| Macbook | Local workstation | `nix-darwin` |
| nixpi | `infiniter@nixpi.tail6650cb.ts.net` | `nix-server`, `.#nixpi` |
| nixzero | `infiniter@nixzero.tail6650cb.ts.net` | `nix-server`, `.#nixzero` |
| Hetzner | `root@91.99.204.136` | `nix-server`, `.#hetzner` |

T3 Code provides the fleet's agent sessions through its running backends.
Use SSH for remote commands and Git to transfer source changes. A T3 Code
connection does not share files or synchronize repositories; verify which host
and checkout the selected backend is using.

The Mac's configuration repositories are `~/Code/nix-darwin` and
`~/Code/nix-server`. All three NixOS hosts use the same `master` branch of
`nix-server`, normally checked out at `/etc/nixos`. Select the matching flake
host when rebuilding. The Zero uses nixpi as its build worker.

Use `infiniter` for ordinary work on the Pis and root for administration.
The Mac does not run an SSH server; initiate fleet connections from the Mac.

## Git under sensory-minds

A worker checkout under `~/services/sensory-minds` uses the Macbook relay
workflow: pushing to its `origin` hands work back toward the Mac, which handles
the external provider. It does not publish directly to that provider.

The physical exchange is a bare `<repo>.git` beside the worker's checkout.
The worker's `origin` points to that bare repository; the Mac has a separate
remote pointing to it over SSH. The Mac's own `origin` remains the external
provider. This lets workers publish results while the Mac is offline, without
copying provider credentials or requiring worker-to-Mac SSH.

- The Mac pushes the starting commit or branch to the exchange remote.
- The worker fetches its `origin`, works, and pushes results there.
- The Mac fetches the worker remote, reviews and integrates the result, then
  publishes to its own `origin` when requested.

Name worker result branches `<device>/<branch>`, adding the device prefix only
once. Keep existing upstreams when transferring a starting branch. Outside
`sensory-minds`, inspect the configured remotes and use direct provider access
when available; do not assume every repository uses the relay.

Before changing a checkout, check the host, working tree, branch, and fetch/push
URLs. Use a separate worktree when another session owns the checkout. Transfer
committed source changes; keep credentials and runtime data on their devices.

## Skill copies

The source is `~/.agents/skills/fleet-work`; Claude discovers it through
`~/.claude/skills/fleet-work`. Keep the Mac and nixpi copies synchronized when
updating this skill. Project-specific setup belongs in each repository.
