# Track 2: Proof of concept

Go from a research idea to one number in about 90 minutes, have that number checked by an agent that never saw your code, and decide whether the idea is worth a full project.

I do a version of this every time I start something. On my immigration bond project I started with four possible designs from the TRAC data and ran a literature search on each before I picked bond judges. Later I tried two more ideas, the Illinois detention ban as a second instrument and a model of judge skill from another paper, and dropped both after a quick look; the skill model's range came out almost 0 to 1. A quick look like that is cheap, and it's how I avoid spending a month on something that won't work. The risk is that a fast number is often a wrong number. In one of my tests on jail data, the code ran with no errors and gave a 2019 total 38% too high, and an auditor with a general "check this" prompt passed every one of the 8 wrong answers. So this track runs the quick version with the checks still in it: a data profiler, a referee on the plan, and a replicator.

## Before you start

Bring:

- A research question, in one or two sentences.
- One data file that could answer it, and its codebook. A file you already know well is best, since you'll be checking Claude's reading of it.
- Claude Code installed and logged in, Python with pandas, and `jq` (the kit's hook that protects `data/raw/` needs it; on a Mac, `brew install jq`).

If you don't have your own idea and data, use the example: "Did State A's minimum wage increase reduce employment at fast-food restaurants?" State A raised its minimum wage from $6.80 to $8.08 an hour, and State B's stayed at $6.80. 410 fast-food restaurants in the two states were surveyed twice, about a month before the increase and about eight months after. It's the data from the replication test in the talk, with the states, dollar amounts, chain names, variable names and row order changed. The example files for this track will be in `tracks/2-proof-of-concept/examples/`: `data/` (the four data files), `idea.md` (the idea, filled in) and `CLAUDE.md` (a project file for this example).

The data are disguised because Claude has read about the original study many times. When I first gave agents the original data, all six returned the published number in three tool calls without opening the questionnaires, so they were remembering the paper, not reading the data. Don't tell Claude where the data come from, and don't look up the original study until the end. At each step, ask whether a choice came from a file in your folder or from memory.

## Steps

### 1. Set up the folder (10 min)

Work in a new folder outside the workshop repo, so Claude can't find anything in `tracks/` by searching up the folder tree.

```
mkdir -p ~/poc/data/raw ~/poc/data/clean ~/poc/code ~/poc/output/logs ~/poc/notes ~/poc/literature
cp -R claude-code-research-workshop/.claude ~/poc/
cp claude-code-research-workshop/CLAUDE.md ~/poc/
```

Change the `claude-code-research-workshop/` part to wherever you cloned the repo.

Put your data file and codebook in `~/poc/data/raw/`. For the example, from the repo folder:

```
cp tracks/2-proof-of-concept/examples/data/* ~/poc/data/raw/
cp tracks/2-proof-of-concept/examples/CLAUDE.md ~/poc/CLAUDE.md
```

That gives you `data.csv` (one row per restaurant), `codebook.txt`, and the two questionnaires, `survey_wave1.txt` and `survey_wave2.txt`. Copy only `data/` and `CLAUDE.md` from the examples folder, not `idea.md`; you'll write your own idea in step 2.

Then make the raw data read-only, in your own terminal (the kit's hook would block Claude from running this):

```
chmod -R a-w ~/poc/data/raw
```

If you're using your own data, open `~/poc/CLAUDE.md` and replace the jail project with yours: the question, the data files, what one row is, and anything you already know about the data that a newcomer would get wrong. Keep the Rules section. Then start Claude from the folder:

```
cd ~/poc
claude
```

This is principle 1 (keep your work separate). `data/raw/` is read-only, `notes/idea.md` will be yours, and everything Claude writes goes in `code/`, `output/`, `notes/` and `replication/`.

### 2. Write the idea yourself (5 min)

Write `notes/idea.md` by hand, not with Claude. Three short parts:

- The question.
- The data: which file, which rows, which years.
- The one number that would tell you whether to continue, and what value would make you stop. Write the stop rule down now, before you see the number.

For the example, you can start from `tracks/2-proof-of-concept/examples/idea.md` and change the stop rule to your own. The number is the change in average full-time-equivalent employment per restaurant from wave 1 to wave 2, in State A minus State B (a difference-in-differences).

### 3. Referee the idea (7 min)

Type:

```
Use the referee agent on notes/idea.md
```

The referee lists the 3 most serious problems (identification, data, and whether it's new) and what evidence would fix each. It saves its report to `notes/referee_<date>.md`. It can write there and nowhere else: a hook in the kit blocks it from changing anything outside `notes/`.

Things to check in the report:

- It should say "not checked" on whether the idea is new, because `literature/` is empty. If it says the idea is new or has been done, and names papers, it's working from memory. For the example, if it names a specific published study, write down which one: it recognized the data from memory, and in step 5 you should watch the plan for choices copied from that study.
- Each problem should come with evidence that would fix it. Pick the one or two that you could deal with today and add a line to `notes/idea.md` about each. Leave the rest for a full project.

This is principle 3 (question everything): an agent with one job and a list of what to look for.

### 4. Run the proof of concept up to the plan (20 min)

The `/proof-of-concept` skill runs six steps: profile the data, write a plan, referee the plan, compute, replicate, report. I want to read the plan before any number is computed (principle 0), so ask it to stop after the referee. For the example, type:

```
/proof-of-concept Did State A's minimum wage increase reduce employment at fast-food restaurants? Data: data/raw/data.csv, with data/raw/codebook.txt and the questionnaires data/raw/survey_wave1.txt and data/raw/survey_wave2.txt. Stop after step 3 and wait for me before computing anything.
```

For your own project, change the question and the file. Here's what Claude does:

1. The `data-profiler` agent reads the codebook and the data and writes `notes/data_report_<file>.md`: what one row is, what each column means, missing values, anything that could make a simple sum wrong, and whether the set of units changes over time. It describes the data and doesn't analyze it.
2. The main session writes `notes/poc_plan.md`: the number, the exact rows and filters, what one unit is, how to avoid counting a unit twice, which units to compare, and the checks the result must pass.
3. The `referee` agent reads the plan. If it lists problems, Claude revises and sends it back, at most twice. If the referee still objects after that, Claude stops and shows you the objections.

Read the data report first. Check that:

- The row count matches the codebook (410 restaurants for the example).
- It read the questionnaires, not only the codebook. For the example, the codebook gives one line per employment column; the questionnaire says exactly what was asked. If the report never mentions `survey_wave1.txt`, ask: `Read survey_wave1.txt and survey_wave2.txt and add to the data report what each employment question asks.`
- It lists the restaurants that closed or refused the wave-2 interview, with counts, and says what their wave-2 employment columns contain.

### 5. Read and edit the plan yourself (15 min)

Open `notes/poc_plan.md` in your own editor. I'd spend more time here than on any other step, because every choice in the plan was made without asking you.

Ask Claude to show where each choice came from (principle 2, cite every claim):

```
For each choice in notes/poc_plan.md, give the file and the line or question number it is based on. Mark any choice that isn't based on a file in this folder as "not from the data". Don't change the plan.
```

Anything marked "not from the data", or that cites a published study or "the standard approach", came from memory. That isn't always wrong, but you should know it and decide it yourself.

For the example, the plan has to answer these questions. Decide each one, and write your reason:

- Full-time equivalent: how much does a part-time worker count for, and what's your basis for that number?
- Who counts as an employee: full-time and part-time workers only, or managers too? Read questions 1 and 2 in `survey_wave1.txt`.
- Restaurants that closed before the wave-2 interview: dropped, or kept with zero employment? Their wave-2 employment is blank in `data.csv`, so either way is a choice.
- Which restaurants go into the average: every restaurant with data in each wave, or only those with data in both?

For your own project, the questions are the ones the data report raised: what one unit is, what to do with repeated or missing rows, and which units to compare.

Write each decision in `notes/decisions.md`, by hand: what you chose, what you rejected, and why (principle 5). Then edit `notes/poc_plan.md` to match, or tell Claude exactly what to change. If you changed anything that matters, run the referee again: `Use the referee agent on notes/poc_plan.md`.

What usually goes wrong here: the plan reads fine and you approve it without checking it against the questionnaire. In my 40 one-shot runs on this same data, 10 of 40 made a different choice about who counts as an employee than the original study did, and every run made at least one choice the codebook doesn't spell out.

### 6. Compute and replicate (12 min)

Type:

```
The plan in notes/poc_plan.md is final. Continue /proof-of-concept from step 4.
```

Claude writes `code/poc.py`, logs the row count after each step to `output/logs/poc_log.txt`, and saves the number to `output/poc_numbers.json`. Then the `replicator` agent gets only the plan, the data and the codebook, writes its own script in `replication/`, saves `replication/numbers.json`, and only then opens the analyst's numbers to compare. If they differ by more than 0.5%, Claude has to find out why, for at most 2 rounds. Last, it reports: the number and whether the replication matched, what's still rough, the referee's open objections, and its recommendation (continue, change the question, or stop).

Check:

- `output/logs/poc_log.txt`: do the row counts match the data report and the checks in the plan? For the example, start at 410 and follow every drop.
- `replication/numbers.json` against `output/poc_numbers.json`. If they matched, that's two scripts written from the same plan giving the same number. It tells you the plan is clear. It doesn't tell you the plan is right; that was your job in step 5.
- If they didn't match, read Claude's explanation. Usually the plan was vague about one step and the two agents read it differently. Fix the plan, not the code, and rerun from step 4.

This is principle 4 (report or change, never both): the profiler, referee and replicator only report; the main session is the only one that changes code.

### 7. Check the number yourself (13 min)

Don't take the number from the report. Open `output/poc_numbers.json`, then compute the same number your own way: in Stata, R, or a few lines of Python you write yourself, from `data/raw/` and your decisions in `notes/decisions.md`. Ten minutes is enough for a difference of four means.

Also check one thing by eye. Pick two or three rows in the raw data and work out by hand what each should add to the number.

If your number doesn't match Claude's, find the step where they differ before you look at anything else.

### 8. Decide (8 min)

Write `notes/decision.md` by hand:

- The number, and whether the replicator and your own check agreed.
- Compared with the stop rule you wrote in step 2: continue, change the question, or stop.
- What's still rough, and the one thing you'd do first in a full project.
- The referee objections you're leaving open, and why.

For the example only: I'll show the original study's number at the end of the session, along with the numbers you get from the common alternative choices. Save `notes/decision.md` before then. If your number differs, find which of your four decisions in step 5 explains the gap, and add to `notes/decision.md` whether you'd still make that choice.

## If you finish early

- Run it again in a fresh folder (copy `data/raw/`, `CLAUDE.md` and `.claude/`, plus your `notes/decisions.md`), and add a line to `CLAUDE.md`: `Read notes/decisions.md before writing any plan.` Run `/proof-of-concept` without stopping and see whether the plan now matches your decisions without you editing it.
- Change the question on the same data. For the example: "Did the price of a meal rise more in State A than in State B?" (a medium soda, small fries and the main item). When you read the plan, check which stores it drops because a price changes a lot between the two surveys, and why.

## Finished when

- `output/poc_numbers.json` and `replication/numbers.json` exist and agree within 0.5%, and you've checked the number yourself in step 7.
- `notes/decisions.md` lists each choice in the plan you decided yourself, with what you rejected and why.
- `notes/decision.md` says continue, change the question, or stop, compared with the stop rule you wrote before you saw the number.
