# Track 4: Agents and skills

In this track you write one reviewer agent, run it on a draft, make it better, and then turn one task you repeat into a skill.

Before my immigration bond paper goes out, I want other readers to go through it: an econometrician for the identification and the standard errors, someone who knows how bond hearings work, a non-technical reader, and a nitpicker for formatting. Agents can play those readers, but only if each one has a narrow job and a list of what to look for. In my replication experiment, an auditor told only to "recompute the numbers yourself" passed all 8 of the wrong answers in its 20 runs, because it redid the same calculation with the same assumption. A checklist is what fixed that. I use the same setup on my lecture slides: `/audit-slides` runs four reviewers at once, and none of them can edit the slides. The skill half is the other thing I use every week. `/ingest-paper` is a skill, and it's how my library of about 800 papers got its summaries.

## Before you start

Bring your own draft (paper, chapter, or slides) as a `.md`, `.tex`, or `.txt` file. Agents read plain text best. A PDF works, but Claude reads it more slowly and can miss table contents. If the draft draws on results files (CSVs, logs) or paper summaries, bring those too. Also bring one task you do often, like formatting a regression table, writing table notes, or writing a data appendix.

Before you start, write down the problems you already know are in the draft, about 5 to 10, in `~/Documents/known_problems.md`. Keep this file outside the project folder so the agent can't read it. You can only score a reviewer on problems you already know about, so this list is your answer key. Without it you can't tell whether the agent is finding things or just sounding confident.

## Steps

### 1. Setup (10 min)

1. Make a project folder for your draft, add the kit's `.claude/` folder, and start Claude there:

   ```
   mkdir ~/Documents/track4 && cd ~/Documents/track4
   mkdir draft notes output literature
   cp ~/path/to/your/draft.tex draft/
   cp -R ~/Documents/claude-code-research-workshop/.claude .
   claude
   ```

   Change `~/path/to/your/draft.tex` to where your draft is. Copy any results files into `output/` and any paper summaries into `literature/`. If you already have a project folder from Track 1, you can use that instead and put the draft in `draft/`.

2. Check that Claude sees the kit. Type `/agents`. You should see `referee`, `data-profiler`, `replicator`, `citation-checker`, and `number-checker`. If you don't, you started `claude` from the wrong folder. Exit and `cd` into the folder that has `.claude/` in it.

3. Look at the files. Your folder has `draft/`, `output/`, `literature/`, an empty `notes/`, and `.claude/`. Skim your draft so you know what the agent will be reading.

4. Open `.claude/agents/referee.md` in your editor. Every agent file has six parts: a description (when to use it), a role (who it is, and that it didn't write this), a checklist, limits (what it must not do or claim), tools, and where the output goes. You'll write the same six parts.

### 2. A plain request first (5 min)

Before writing an agent, see what you get without one. Type (with your draft's file name):

```
Check draft/paper.tex for problems. Don't edit anything.
```

Copy the list it gives you into `~/Documents/baseline.md` (or ask: `Save the list you just gave me to ~/Documents/baseline.md`). Save it outside the project folder, because the agent reads files in the project, and if it reads this list first, the comparison is meaningless. Count the problems. You'll compare this to your agent later. A plain request usually finds a few things and misses whole kinds of problems, because nothing tells it what kind of problems to look for.

### 3. Write your agent (15 min)

Pick one job. One. Each kind of reviewer should catch a different subset of the problems in your draft:

| Reviewer | Its one job |
|---|---|
| Econometrician | Identification, standard errors and clustering, whether the tables support each claim in the text |
| Numbers and tables | Every number in the text matches the tables, and every table matches the files in `output/` |
| Citations | Every citation has a summary in `literature/`, and the sentence says what the summary says |
| Domain expert | How your field's institutions and data actually work |
| Formatting nitpicker | Table and figure references, minus signs, decimals, abbreviations, typos |
| Non-technical reader | Could a reporter or a policymaker follow it? Where would they get lost? |

The kit already has `number-checker` and `citation-checker`. If you pick one of those jobs, read the kit's file first and write a stricter version.

Two ways to make the file:

- Type `/agents`, choose to create a new project agent, and describe the job. Claude writes a draft. Then open the file and check the six parts.
- Or write it yourself. Here's a starting point for the econometrician; change the checklist for your job:

```
---
name: econometrician
description: Referees identification, estimation, and inference in a draft. Reports only; never edits. Use on a draft before sending it.
tools: Read, Grep, Glob, Write
---

You're an applied econometrician refereeing this paper for a field journal. You didn't write it and you have no reason to like it.

Read the draft, then the files in output/ it draws on.

Check:
1. Identification. Name the design and each assumption it needs. For each one: what in this setting could break it, and does the paper test it?
2. Inference. At what level does treatment vary? Are standard errors clustered at that level? How many clusters are there?
3. Claims. For every sentence that states a result, find the table and column it comes from. Does the table support the sentence as written?
4. Pre-trends and timing. If there's an event study, read every pre-period coefficient yourself.

Rules:
- Write the review to notes/review_<n>.md, using the next number not already in notes/. Don't edit any other file.
- Every point gives the section, table, and column, or the file and line.
- Rank each point MUST FIX (the result is wrong), CHECK (could change the result), or MENTION (say it in the paper).
- If you couldn't verify something, say so. Don't guess.
- No praise and no summary.
```

Save it as `.claude/agents/<name>.md`. If you wrote the file by hand, exit and restart `claude` (or run `claude --continue` to keep the conversation), then type `/agents` to check it's listed.

The agent gets Write so it can save its report, and nothing else. That's principle 4 (report or change, never both): an agent that can edit the draft will fix things quietly instead of telling you. The rule in the agent file asks it not to; the kit's hook makes sure. Open `.claude/hooks/reports-only.sh` and add your agent's name to the line with `referee|citation-checker|number-checker|data-profiler`. After that, any time your agent tries to write outside `notes/`, the write is blocked and the agent is told to report the problem instead.

### 4. Run it (10 min)

Type:

```
Use the econometrician agent on draft/paper.tex
```

(Use your agent's name and your draft's file name.) You'll see Claude start the agent; it reads files in its own context and sends back a report. If you see Claude reading the paper itself without starting the agent, stop it with Esc and say `Use the econometrician agent for this, don't review it yourself.`

Check the report in `notes/`:

- Does every point name a place in the paper (section, table, column)? Points without a location are hard to check, and they're often wrong.
- Open two of the points and check them yourself against the paper and the `output/` files. Is the problem real?
- Did it stay in its job, or did it start commenting on writing style or the literature?

Things that usually go wrong:

- The agent can't be found. You started `claude` from the wrong folder, or you wrote the file by hand and didn't restart.
- The agent changed the draft. Its name isn't in `.claude/hooks/reports-only.sh` yet. Add it, undo the change, and run it again.
- The report opens with praise or ends with a summary. Add "No praise and no summary" to the rules if it isn't there, or move it higher.
- Claude offers to fix the problems in the draft. Say no for now. Fixing is a separate step, done by you or by a different agent.

### 5. Score it (10 min)

Open `~/Documents/known_problems.md` and the agent's report side by side. Fill in:

| | Count |
|---|---|
| Known problems your agent found (out of your list) | |
| Known problems in its job that it missed | |
| Other things it flagged that are real problems | |
| Things it flagged that are wrong | |
| Things it flagged that you can't tell yet | |
| Known problems the plain request in step 2 found | |

Compare with someone who wrote a different kind of reviewer. You should find that each kind catches a different set, and none catches everything. That's the reason to run several narrow reviewers instead of one general one. If one of them found a real problem you didn't know about, add it to `known_problems.md`.

### 6. Make it better and run it again (15 min)

For each problem in its job that it missed, add a line to the checklist. Write the general rule, not the answer. "Check that the 2015 coefficient in Table 3 is significant" teaches the agent this one paper; "Read every pre-period coefficient and its standard error, and compare them to what the text says about pre-trends" works on the next paper too. If you write the answers into the agent, a better score here means nothing.

For each wrong flag, add a limit, for example "Don't call a difference between two subgroups significant unless the paper reports a test of the difference" or "Only flag a citation as missing after you've searched `literature/` by author name."

Then run it again; the new report goes to `notes/review_2.md`. Score it the same way. If it got worse, look at what you changed. Long checklists can push the agent to skim; keep each item to one line.

If you have time, also run it on a different file, like another section or another paper of yours. An agent that only works on the draft you tuned it on isn't much use.

### 7. Do a task once by hand (10 min)

Pick a task you repeat. If you have a results file, making a regression table from it works well. For example (change the file names and the format to yours):

```
Make a markdown table from output/results.csv in the format of Table 2 in draft/paper.tex: three decimals, real minus signs (−, not -), standard errors in parentheses under each estimate, stars from the p-values (* p<0.10, ** p<0.05, *** p<0.01), and a note that gives the sample, N, the estimator, the fixed effects, and the clustering level. Write it to output/tables/table2.md. Don't edit anything in draft/.
```

Check the table yourself. Do the stars match the p-values in the CSV? Are there any hyphens left where minus signs should be? Does the note say everything you asked for? Correct it in the chat until it's right ("the note is missing the number of clusters"). The corrections are the useful part: they become steps in the skill.

With a different task, do it the same way: describe it fully, check the result, correct it.

### 8. Turn it into a skill (8 min)

Type:

```
Turn what we just did into a skill in .claude/skills/regtable/SKILL.md. Use $ARGUMENTS for the input file. Include every correction I made as a step. Add a step that stops and asks me if a column it needs is missing.
```

Open the file and edit it:

- The `description` line matters most. Claude reads it to decide when the skill applies, so say what the skill does and when to use it in one or two sentences.
- One action per step. Say where files go.
- Remove anything that only fits the file you just used (column names, file names). Those should come from `$ARGUMENTS` or from reading the file.
- Look at `.claude/skills/ingest-paper/SKILL.md` for the format.

### 9. Test it in a new session (7 min)

Exit and start a fresh `claude` in the same folder. The session where you wrote the skill already knows everything you told it, so it isn't a real test. Type (with another of your results files):

```
/regtable output/other_results.csv
```

Use a different file from the one you built it on. Check the output with the same questions as step 7. Whatever it gets wrong, fix in `SKILL.md` (not in the chat), and run it again in another new session.

## If you finish early

- Run your reviewer on the table your skill made: `Use the <name> agent on output/tables/table2.md`. That's the loop from the talk: one thing does the work, a different agent checks it.
- Write a second reviewer for a different job, then write a skill that runs both on a file and merges their reports into one list sorted MUST FIX, CHECK, MENTION. Give the skill only `Read, Grep, Glob, Agent` in `allowed-tools` so it can't edit the draft either. My `/audit-slides` works this way with four reviewers.

## Finished when

- `notes/review_1.md` and `notes/review_2.md` exist, and you've written down how many of the problems in `~/Documents/known_problems.md` each one found.
- Your agent file has only read tools, and its checklist has at least one line you added after the first run.
- `/<your skill> <a different file>` works in a new session with no extra instructions from you.
