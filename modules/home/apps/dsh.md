# dsh transition plan

Research targets the locked `inputs.llm-agents` package:

- `@deepseek-ai/dsh@0.1.0-rc.7`
- `deepseek-ai/deepseek-harness` tag `dsh-v0.1.0-rc.7`
- `numtide/llm-agents.nix` commit `c4c6673c4c1ceb69d845fa665a714e1273d0acac`

This document is a configuration plan. dsh runtime configuration is YAML, not
Markdown. Markdown is used for `AGENTS.md` instructions and `SKILL.md` skills.

## Capability map

| Requirement | rc.7 status | Configuration |
|---|---|---|
| TUI | External plugin | Install pinned `@deepseek-harness-tui/dsh-tui@0.8.8`. |
| Subagents | Built into `dsh-base` | `subagent`, `subagent_fork`, `list_agents`, and control tools need no extra package. |
| Todo list | Built into `dsh-base` | `todo_write` needs no extra package; recommended TUI renders its state. |
| Ask user | Built into dsh, mounted by TUI | TUI bundle adds `@deepseek-ai/dsh-tool-ask-user` and keyboard-backed question UI. |
| Web search providers | Optional packages | DeepSeek search ships by default. Exa and Perplexity need packages and patch rows. One provider is selected per run. |
| Web fetch providers | Unsafe/incomplete in rc.7 | Only `@deepseek-ai/dsh-web-fetch-http` exists. It lacks private-network/SSRF protection and stays disabled. Use a trusted remote MCP fetch service or wait for a safer provider. |
| OpenAI Codex SSO as main model | Third-party plugin | Install pinned `dsh-codex-oauth` release from GitHub. It registers `codex` as a main LLM provider and owns OAuth login/refresh. |
| Context7 | MCP | Add official Context7 Streamable HTTP server through `@deepseek-ai/dsh-mcp-client`. |
| Other MCP servers | Built-in client | Add one `dsh-mcp-client` row per stdio or Streamable HTTP server. Only MCP tools are bridged; resources and prompts are not. |
| Sleep inhibition | Unsupported by dsh | Wrap TUI command with `systemd-inhibit`. |
| Caveman | Instructions/skill | Port as optional `SKILL.md`; global `$DSH_HOME/AGENTS.md` would make it unconditional. |
| Ponytail | Existing shared skill | dsh scans `~/.agents/skills`; invoke `/skill:ponytail` from TUI. |

## TUI choice

Recommended package: [`@deepseek-harness-tui/dsh-tui`](https://github.com/ccch1mneyyy/dsh-TUI).

Reasons:

- Real dsh bundle with `dsh.bundle.patch` and explicit rc.7 compatibility.
- Composes over official `dsh-base`; does not fork runtime.
- Implements streaming output, approvals, questions, model selection, session
  browser, presets, subagent dashboard, and plugin interoperability.

Validated with locked Nix package and isolated `$DSH_HOME`:

```console
$ dsh plugin --profile tui add @deepseek-harness-tui/dsh-tui@0.8.8
$ dsh --profile tui --dump-config
$ dsh --profile tui
dsh-TUI v0.8.8
```

Install reports peer-dependency warnings because profile peers resolve from the
dsh runtime. Composition and tmux boot pass. Keep version pinned and validate
each dsh upgrade before activation. A profile-local pnpm patch moves TUI state
from `~/.dsh-tui` to `$DSH_HOME/tui` and disables its automatic npm version
check; explicit `/update` remains available.

Home Manager installs pnpm and wraps dsh with
`DSH_HOME=$XDG_CONFIG_HOME/dsh` and
`pnpm_config_store_dir=$XDG_DATA_HOME/dsh/pnpm/store`. `PNPM_HOME` stays unset
because dsh uses profile-local dependencies, not global pnpm binaries.

## Profile packages

Proposed pinned installation:

```bash
dsh plugin --profile tui add \
  @deepseek-harness-tui/dsh-tui@0.8.8 \
  https://github.com/birat-chapagain/dsh-codex-oauth/releases/download/v0.1.5/dsh-codex-oauth.tgz \
  @deepseek-ai/dsh-web-search-exa@0.1.0-rc.7 \
  @deepseek-ai/dsh-web-search-perplexity@0.1.0-rc.7
```

TUI and Codex OAuth packages are bundles. Search packages remain profile
dependencies and must be mounted by
`$DSH_HOME/profiles/tui/cordis.patch.yml`.

Never install bare npm name `dsh-codex-oauth`: npm resolves that name to an
unrelated fork. Use pinned GitHub release URL above. Profile
`pnpm-workspace.yaml` also needs:

```yaml
allowBuilds:
  '@google/genai': true
  protobufjs: true
```

## Draft profile patch

```yaml
# The TUI creates its own agent and resolves this default route.
- id: agent-default-model
  name: '@deepseek-ai/dsh-agent-default-model'
  config:
    provider: codex
    model: gpt-5.6-sol

# Select deepseek-official, exa, or perplexity at process start.
- id: web
  config:
    searchProvider: !!js process.env.DSH_WEB_SEARCH_PROVIDER ?? 'deepseek-official'

- insert:
    - id: web-search-exa
      name: '@deepseek-ai/dsh-web-search-exa'

    - id: web-search-perplexity
      name: '@deepseek-ai/dsh-web-search-perplexity'

    - id: mcp-context7
      name: '@deepseek-ai/dsh-mcp-client'
      config:
        serverName: context7
        transport: streamable-http
        url: https://mcp.context7.com/mcp
        headers:
          Authorization: !!js '`Bearer ${process.env.CONTEXT7_API_KEY}`'
```

Expected credentials:

```text
DEEPSEEK_API_KEY       default model and default web search
EXA_API_KEY            Exa search
PERPLEXITY_API_KEY     Perplexity search
CONTEXT7_API_KEY       authenticated Context7 access
```

Remove Context7 `headers` block for anonymous/basic usage. With drafted block,
`CONTEXT7_API_KEY` must be present before dsh starts.

`$DSH_HOME/.credentials.yaml` does not export values into `process.env`.
Plugins using `process.env` need variables exported before dsh starts. Future
Home Manager wrapper should source a dedicated SOPS environment file.

Do not add `@deepseek-ai/dsh-web-fetch-http` yet. rc.7 documentation calls it
an SSRF primitive because it permits private, loopback, and link-local targets.

## Codex OAuth provider

[`birat-chapagain/dsh-codex-oauth`](https://github.com/birat-chapagain/dsh-codex-oauth)
fills dsh rc.7's missing OAuth-store/login integration and registers provider
route `codex` for main conversations.

Login from TUI:

```text
/codex login
/codex login device
/codex status
/codex logout
```

Headless login is also available through plugin binary. Credentials live in
`$DSH_HOME/codex-oauth.json`, mode `0600`, with automatic refresh serialized by
a file lock. Tokens remain plaintext and same-user model tools can read them;
never use `$DSH_HOME` as agent workspace.

The plugin is third-party, single-author software. Keep v0.1.5 tarball pinned.
Its release integrity is:

```text
sha512-Nf4k12Tw3VXC4rq/4m68P6qeOV8e+azhsfRc0HTQHI3Yvmn28xcrBDC1ECaQf8XWbboYWxXDpMOgdMAb57he7g==
```

Validated against dsh rc.7 and TUI 0.8.8: composed config contains provider
`codex`, fresh TUI session displays `gpt-5.6-sol`, and profile reaches
interactive prompt without OAuth credentials. Real login and model turn remain
live acceptance tests.

## MCP migration

dsh ships `@deepseek-ai/dsh-mcp-client`; no extra client package is needed.
Each server gets one patch row:

```yaml
- insert:
    - id: mcp-example-stdio
      name: '@deepseek-ai/dsh-mcp-client'
      config:
        serverName: example
        transport: stdio
        command: example-mcp
        args: []
        env: {}

    - id: mcp-example-http
      name: '@deepseek-ai/dsh-mcp-client'
      config:
        serverName: example-http
        transport: streamable-http
        url: https://example.invalid/mcp
```

Tools appear as `mcp__<serverName>__<tool>`. Existing
`programs.mcp.servers` declarations cannot be consumed directly; translate
AWS docs, GitHub, Kubernetes, NixOS, Sidero docs, and Terraform rows into this
shape. Dynamic commands such as `!gh auth token` need wrapper-exported tokens.

## Agent instructions and optional styles

dsh loads these Markdown files automatically:

- `$DSH_HOME/AGENTS.md`
- project `AGENTS.md` and `CLAUDE.md`
- nested `AGENTS.md` and `CLAUDE.md`
- local overlays `AGENTS.local.md` and `CLAUDE.local.md`

Keep global instructions small. Do not put optional Caveman/Ponytail behavior in
global `AGENTS.md`.

dsh also scans shared skill roots, including `~/.agents/skills`. Existing
Ponytail skills therefore need no migration. Add Caveman as a user-invocable
skill later, then enable styles explicitly from TUI.

Pi named subagent Markdown frontmatter is not dsh-compatible. Native dsh
spawn/fork subagents work immediately; port named agents later as dsh presets
or skills after TUI baseline works.

## Sleep inhibition

dsh has no caffeinate plugin. Initial NixOS analogue:

```bash
systemd-inhibit \
  --what=idle:sleep \
  --mode=block \
  --who=dsh \
  --why='Interactive dsh session' \
  dsh --profile tui
```

This follows TUI process lifetime. It blocks logind idle/sleep actions, but may
not stop compositor-specific display blanking. `wlinhibit` is not selected as
default because its own upstream README calls implementation fundamentally
broken on protocol-correct compositors.

## Implementation order

1. Keep pnpm installed with dsh-only store under
   `$XDG_DATA_HOME/dsh/pnpm/store`.
2. Add TUI profile patch and `dsh --profile tui` launcher.
3. Install pinned Codex OAuth bundle and complete browser/device login.
4. Add dedicated SOPS environment wiring for non-OAuth providers.
5. Add Context7, then translate remaining MCP servers one at a time.
6. Add Exa/Perplexity provider packages and provider selection.
7. Add process-lifetime sleep inhibitor wrapper.
8. Port optional Caveman and named Pi agents only after baseline is stable.

## Sources

- [DeepSeek Harness rc.7](https://github.com/deepseek-ai/deepseek-harness/tree/dsh-v0.1.0-rc.7)
- [dsh CLI profiles and plugins](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.1.0-rc.7/apps/cli/reference/README.md)
- [MCP client](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.1.0-rc.7/packages/mcp/mcp-client/README.md)
- [Codex OAuth provider](https://github.com/birat-chapagain/dsh-codex-oauth)
- [Web provider seam](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.1.0-rc.7/packages/web/web/README.md)
- [HTTP fetch security limits](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.1.0-rc.7/packages/web/web-fetch-http/README.md)
- [Agent instructions](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.1.0-rc.7/packages/context/agent-instructions/README.md)
- [Recommended TUI](https://github.com/ccch1mneyyy/dsh-TUI)
- [Context7 MCP](https://github.com/upstash/context7)
