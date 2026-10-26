# Track 2: Proof of concept

See if you can get from an idea to a first estimate in 90 minutes, and decide whether the idea is worth a full project.

## Before you start

- A research question, in one or two sentences.
- One data file that could answer it.

## Steps

1. Set up your folder as in Track 1 (copy `CLAUDE.md` and `.claude/`, put the data file in `data/raw/`).
2. Write the idea in `notes/idea.md`: the question, the data, and the one number that would tell you whether to continue.
3. Run the referee on it: `Use the referee agent on notes/idea.md`. Revise the idea if needed.
4. Run the full proof of concept: `/proof-of-concept [your question] data/raw/[your file]`
5. Read the report Claude gives at the end, and the plan and referee report in `notes/`. Check the one key number in `output/poc_numbers.json` yourself.

## Finished when

- You have one number, checked by the replicator agent.
- You've written down whether to continue, change the idea, or stop.
