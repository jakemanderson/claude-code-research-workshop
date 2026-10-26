# Track 4: Agents and skills

Write one reviewer agent and one skill for your own work.

## Before you start

- A draft (paper, chapter, or slides) to review.
- One task you do often (for example, formatting a regression table or writing a data appendix).

## Steps

1. Set up your folder as in Track 1.
2. Read `.claude/agents/referee.md` as an example.
3. Write your own reviewer in `.claude/agents/[name].md`, for one job only (for example, econometrics, or formatting). Give it read-only tools: `tools: Read, Grep, Glob`.
4. Run it on your draft: `Use the [name] agent on [draft]`. Did it find real problems? Edit the agent and run it again.
5. Turn your task into a skill: do the task once with Claude, then ask `Turn what we just did into a skill in .claude/skills/[name]/SKILL.md`.
6. Start a new session and run the skill: `/[name]`.

## Finished when

- Your agent finds at least one real problem in your draft.
- Your skill does the task in a new session without extra instructions.
