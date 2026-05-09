# Gemini CLI setup

```bash
git clone https://github.com/heyimcarlos/agent-skills ~/repos/agent-skills
cd ~/repos/agent-skills
bin/install gemini --user
```

Result:
```
~/.gemini/skills            → ~/repos/agent-skills/core/skills
~/.gemini/commands/core/    → *.toml translations of core/commands/
```

Skills auto-discover from `SKILL.md` frontmatter. `core` slash commands invoke as `/core/commit`, `/core/describe_pr`, etc. (Gemini uses `/` as the namespace separator.)

> The `qrspi` plugin no longer ships slash commands — its workflow lives in `qrspi/skills/` and `qrspi/agents/`. The Gemini installer currently wires only `core/skills` into `~/.gemini/skills`; QRSPI skill/agent integration for Gemini is not yet implemented.

## Regenerating commands

The TOML files are generated from the canonical `.md` sources. After editing any command:

```bash
python3 bin/build-gemini-commands
bin/install gemini --user      # if you used --copy mode
```

If you installed with the default symlink mode, edits to `core/commands/*.md` are picked up after re-running the build script (Gemini reads `.toml` files, not the source `.md`).

## Project install

```bash
bin/install gemini --project /path/to/project
```

Wires the content into `<project>/.gemini/`.
