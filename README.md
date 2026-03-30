<p align="center">
  <img src="assets/nanoclaw-logo.png" alt="NanoClaw" width="400">
</p>

<p align="center">
  An AI assistant that runs agents securely in their own containers. Lightweight, built to be easily understood and completely customized for your needs.
</p>

<p align="center">
  <a href="https://nanoclaw.dev">nanoclaw.dev</a>&nbsp; • &nbsp;
  <a href="https://docs.nanoclaw.dev">docs</a>&nbsp; • &nbsp;
  <a href="README_zh.md">中文</a>&nbsp; • &nbsp;
  <a href="repo-tokens"><img src="repo-tokens/badge.svg" alt="34.9k tokens, 17% of context window" valign="middle"></a>
</p>

Using Claude Code, NanoClaw can dynamically rewrite its code to customize its feature set for your needs.

**Supports [Agent Swarms](https://code.claude.com/docs/en/agent-teams)** — spin up teams of agents that collaborate in your chat.

## Why NanoClaw

[OpenClaw](https://github.com/openclaw/openclaw) is an impressive project, but giving complex software you don't understand full access to your life is a risk. OpenClaw has nearly half a million lines of code, 53 config files, and 70+ dependencies. Its security is at the application level (allowlists, pairing codes) rather than true OS-level isolation. Everything runs in one Node process with shared memory.

NanoClaw provides that same core functionality, but in a codebase small enough to understand: one process and a handful of files. Claude agents run in their own Linux containers with filesystem isolation, not merely behind permission checks.

## Quick Start

```bash
gh repo fork qwibitai/nanoclaw --clone
cd nanoclaw
claude
```

<details>
<summary>Without GitHub CLI</summary>

1. Fork [qwibitai/nanoclaw](https://github.com/qwibitai/nanoclaw) on GitHub (click the Fork button)
2. `git clone https://github.com/<your-username>/nanoclaw.git`
3. `cd nanoclaw`
4. `claude`

</details>

Then run `/setup`. Claude Code handles everything: dependencies, authentication, container setup and service configuration.

> **Note:** Commands prefixed with `/` (like `/setup`, `/add-telegram`) are [Claude Code skills](https://code.claude.com/docs/en/skills). Type them inside the `claude` CLI prompt, not in your regular terminal. If you don't have Claude Code installed, get it at [claude.com/product/claude-code](https://claude.com/product/claude-code).

## Philosophy

**Small enough to understand.** One process, a few source files and no microservices. If you want to understand the full NanoClaw codebase, just ask Claude Code to walk you through it.

**Secure by isolation.** Agents run in Linux containers (Apple Container on macOS, or Docker) and they can only see what's explicitly mounted. Bash access is safe because commands run inside the container, not on your host.

**Built for the individual user.** NanoClaw isn't a monolithic framework; it's software that fits each user's exact needs. Instead of becoming bloatware, NanoClaw is designed to be bespoke. You make your own fork and have Claude Code modify it to match your needs.

**Customization = code changes.** No configuration sprawl. Want different behavior? Modify the code. The codebase is small enough that it's safe to make changes.

**AI-native.**
- No installation wizard; Claude Code guides setup.
- No monitoring dashboard; ask Claude what's happening.
- No debugging tools; describe the problem and Claude fixes it.

**Skills over features.** Instead of adding features to the codebase, contributors submit [Claude Code skills](https://code.claude.com/docs/en/skills) like `/add-telegram` that transform your fork. You end up with clean code that does exactly what you need.

**Best harness, best model.** NanoClaw runs on the Claude Agent SDK, which means you're running Claude Code directly. Claude Code is highly capable and its coding and problem-solving capabilities allow it to modify and expand NanoClaw and tailor it to each user.

## What It Supports

- **Multi-channel messaging** — Talk to your assistant from WhatsApp, Telegram, Discord, Slack, or Gmail. Add channels with skills like `/add-whatsapp` or `/add-telegram`. Run one or many at the same time.
- **Isolated group context** — Each group has its own `CLAUDE.md` memory, isolated filesystem, and runs in its own container sandbox with only that filesystem mounted to it.
- **Main channel** — Your private channel (self-chat) for admin control; every group is completely isolated.
- **Scheduled tasks** — Recurring jobs that run Claude and can message you back.
- **Web access** — Search and fetch content from the web.
- **Browser automation** — Full browser control via `agent-browser` (Chromium, runs inside container).
- **Container isolation** — Agents are sandboxed in Apple Container (macOS) or Docker (macOS/Linux).
- **Agent Swarms** — Teams of specialized agents that collaborate on complex tasks.
- **MCP integrations** — Connect external services directly to the agent (see below).

## MCP Integrations

MCP servers are configured in `container/agent-runner/src/index.ts` and run inside every container session. All tools are available to the agent without any extra setup.

| MCP Server | Tools | Credentials |
|---|---|---|
| `nanoclaw` | `send_message`, `schedule_task`, `list_tasks`, `pause_task`, `resume_task`, `cancel_task`, `update_task`, `register_group` | Built-in (IPC) |
| `gmail` | Read, search, send, label, filter emails | `~/.gmail-mcp/` |
| `google-calendar` | List, create, update events | `~/.config/google-calendar-mcp/` |
| `github` | Repos, PRs, issues, file contents | `GITHUB_TOKEN` in `.env` |
| `google-ads` | Campaign management, reporting | `~/.google-ads-mcp/` |
| `simplinvoice` | Invoice processing, BKPER bookkeeping | `~/mcp-simplinvoice/config.json` |

### SimplInvoice

A private MCP server (`~/mcp-simplinvoice/`) that processes PDF invoices from a NAS mount (`/mnt/mycloud/`) and books them into BKPER. Config lives in `~/mcp-simplinvoice/config.json` (OAuth tokens are refreshed and written back automatically).

Container mounts added in `src/container-runner.ts`:
- `~/mcp-simplinvoice` → `/home/node/mcp-simplinvoice` (read-write, for OAuth refresh and SQLite data)
- `/mnt/mycloud` → `/mnt/mycloud` (read-write, to move processed invoices)

## Usage

Talk to your assistant with the trigger word (`@Andy` by default):

```
@Andy process the new invoices on the NAS
@Andy what's on my calendar this week?
@Andy open a PR on the coaching website repo with the updated bio
@Andy schedule a weekly Friday review of the git log
```

From the main channel (self-chat), you can manage groups and tasks:
```
@Andy list all scheduled tasks across groups
@Andy pause the Monday briefing task
@Andy register the Family Chat group
```

## Customizing

NanoClaw doesn't use configuration files. To make changes, just tell Claude Code what you want:

- "Change the trigger word to @Bob"
- "Remember to always respond in German"
- "Add a custom greeting when I say good morning"
- "Store conversation summaries weekly"

Or run `/customize` for guided changes.

The codebase is small enough that Claude can safely modify it.

## Contributing

**Don't add features. Add skills.**

If you want to add Telegram support, don't create a PR that adds Telegram to the core codebase. Instead, fork NanoClaw, make the code changes on a branch, and open a PR. We'll create a `skill/telegram` branch from your PR that other users can merge into their fork.

Users then run `/add-telegram` on their fork and get clean code that does exactly what they need, not a bloated system trying to support every use case.

### RFS (Request for Skills)

Skills we'd like to see:

**Communication Channels**
- `/add-signal` - Add Signal as a channel


## Architecture

```
Channel (Telegram) → SQLite → Polling loop → Container (Claude Agent SDK + MCP servers) → IPC → Response
```

Single Node.js process. Channels self-register at startup based on which credentials are present. Agents run in isolated Docker containers — only explicitly mounted directories are accessible.

Containers are **long-lived per conversation**: the container stays alive between messages, receiving follow-ups via IPC files in `/workspace/ipc/input/`. When idle for too long, the container exits cleanly.

Each group gets its own copy of the agent-runner TypeScript source (`data/sessions/{group}/agent-runner-src/`), compiled on first run with a hash-based cache (`data/sessions/{group}/agent-runner-dist/`). This means each group can independently customize its tools and behavior.

**Key files:**

| File | Purpose |
|------|---------|
| `src/index.ts` | Orchestrator: state, message loop, agent invocation |
| `src/channels/registry.ts` | Channel registry (self-registration at startup) |
| `src/ipc.ts` | IPC watcher and task processing |
| `src/router.ts` | Message formatting and outbound routing |
| `src/group-queue.ts` | Per-group queue with global concurrency limit |
| `src/container-runner.ts` | Spawns containers, configures mounts and MCP env |
| `src/task-scheduler.ts` | Runs scheduled tasks |
| `src/db.ts` | SQLite operations (messages, groups, sessions, state) |
| `container/agent-runner/src/index.ts` | Agent runner: MCP servers, allowed tools, SDK query loop |
| `container/agent-runner/src/ipc-mcp-stdio.ts` | Built-in nanoclaw MCP server (IPC tools) |
| `container/Dockerfile` | Container image: Node, Chromium, globally installed MCP packages |
| `container/container-entrypoint.sh` | Entrypoint: hash-based TS recompilation + agent launch |
| `groups/{name}/CLAUDE.md` | Per-group memory and system prompt |

**Container mounts (all groups):**

| Host path | Container path | Access |
|-----------|---------------|--------|
| `data/sessions/{group}/agent-runner-src/` | `/app/src` | read-write |
| `data/sessions/{group}/agent-runner-dist/` | `/tmp/dist` | read-write |
| `data/sessions/{group}/.claude/` | `/home/node/.claude` | read-write |
| `data/ipc/{group}/` | `/workspace/ipc` | read-write |
| `groups/{name}/` | `/workspace/group` | read-write |
| `~/.gmail-mcp/` | `/home/node/.gmail-mcp` | read-write |
| `~/.config/google-calendar-mcp/` | `/home/node/.google-calendar` | read-write |
| `~/.google-ads-mcp/` | `/home/node/.google-ads-mcp` | read-only |
| `~/mcp-simplinvoice/` | `/home/node/mcp-simplinvoice` | read-write |
| `/mnt/mycloud/` | `/mnt/mycloud` | read-write |

**Main group only:** additionally mounts the project root read-only at `/workspace/project`.

### Maintenance: updating the agent runner

`container/agent-runner/src/index.ts` is the template. Each group gets its own copy on first run and that copy is not auto-updated. After changing the template, sync to existing groups manually:

```bash
for group in main telegram_main; do
  src="data/sessions/${group}/agent-runner-src/index.ts"
  [ -f "$src" ] && cp container/agent-runner/src/index.ts "$src" && rm -f "data/sessions/${group}/agent-runner-dist/.src-hash"
done
```

Then kill running containers so they recompile on next invocation:

```bash
docker ps --format "{{.Names}}" | grep nanoclaw | xargs docker stop
```

## Requirements

- Linux (or macOS with Docker)
- Node.js 20+
- [Claude Code](https://claude.ai/download)
- [Docker](https://docker.com/products/docker-desktop) (or Apple Container on macOS via `/convert-to-apple-container`)

## FAQ

**Why Docker?**

Docker provides cross-platform support (macOS, Linux and even Windows via WSL2) and a mature ecosystem. On macOS, you can optionally switch to Apple Container via `/convert-to-apple-container` for a lighter-weight native runtime.

**Can I run this on Linux or Windows?**

Yes. Docker is the default runtime and works on macOS, Linux, and Windows (via WSL2). Just run `/setup`.

**Is this secure?**

Agents run in containers, not behind application-level permission checks. They can only access explicitly mounted directories. The codebase is small enough that you can actually read it. See [docs/SECURITY.md](docs/SECURITY.md) for the full security model.

**Why no configuration files?**

We don't want configuration sprawl. Every user should customize NanoClaw so that the code does exactly what they want, rather than configuring a generic system. If you prefer having config files, you can tell Claude to add them.

**Can I use third-party or open-source models?**

Yes. NanoClaw supports any Claude API-compatible model endpoint. Set these in your `.env`:

```bash
ANTHROPIC_BASE_URL=https://your-api-endpoint.com
ANTHROPIC_AUTH_TOKEN=your-token-here
```

**How do I debug issues?**

Run `/debug` inside Claude Code. Or check:
- Service logs: `~/nanoclaw/logs/nanoclaw.log`
- Container logs: `groups/{name}/logs/container-*.log`
- Container debug: `data/sessions/{group}/.claude/debug/`

**What changes will be accepted into the upstream codebase?**

Only security fixes, bug fixes, and clear improvements. Everything else should be contributed as a skill so users can opt in.

## Contributing

**Don't add features. Add skills.**

Fork NanoClaw, make the code changes on a branch, and open a PR. We'll create a `skill/your-feature` branch that other users can merge into their fork with a single skill command.

### RFS (Request for Skills)

- `/add-signal` — Signal as a channel
- `/clear` — Compact the current conversation context programmatically via the Agent SDK

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for breaking changes, or the [full release history](https://docs.nanoclaw.dev/changelog) on the documentation site.

## License

MIT
