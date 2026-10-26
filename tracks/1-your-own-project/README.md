# Track 1: Your own project

Set up one of your projects so Claude Code can work in it: sort the folders, lock the raw data, write a CLAUDE.md, then use plan mode on one real task.

I'd start every new project this way now. Claude starts every session knowing nothing about your project, so whatever you don't write down, it guesses. In the jail experiment from the talk, the same task with no CLAUDE.md got the right answer in 7 of 20 runs. With a CLAUDE.md that wrote down the data's specific problems, it got it in 20 of 20. General rules alone didn't help, and one of my rules made things worse: "If a check fails, stop and say so" dropped it to 1 of 20: in 11 runs Claude found the problem, said so, and reported the unfixed number anyway, because that's what the rule told it to do. So the file is worth the time, but you have to test what you write. In my immigration project the raw EOIR files are in `data/raw/` and CLAUDE.md says never to edit them, a colleague's comment on balance went into `comments/` so Claude could work from it, and since the project has no git history the dated notes are the only record of what I decided and why. That's the setup you'll build here.

## Before you start

- Claude Code installed and working: `claude` starts and you can type a message. If not, sort this out first or ask for help right away.
- The workshop folder downloaded. These steps assume it's at `~/claude-code-research-workshop`. If you put it somewhere else, change that part of each command.
- One of your own projects: a folder with at least one data file and anything else you have (code, notes, a draft). Pick a project you're actively working on, and a copy of it is fine if you're nervous.
- One real task for that project you'd otherwise do this week, small enough to finish in 20 minutes. Cleaning one data file, making one table, or merging two files are all good.
- No project with you, or the data can't leave a secure server? Use the example project `examples/messy_project/` in this track folder (planned, not in the folder yet). It's the Vera county jail file from the talk, set up the way a real project folder ends up after a few months: files all in one place, a script called `analysis_FINAL_v2.py`, notes mixed in with data. Copy it out of the workshop folder before you start, so Claude doesn't also read the workshop's own CLAUDE.md: `cp -r ~/claude-code-research-workshop/tracks/1-your-own-project/examples/messy_project ~/messy_project`. Its task is the one from the talk: compute the number of people in US jails in 2019 and 2020 and the percent change.

On a Mac or Linux, everything below works as written. The hook that protects raw data needs `jq` (check with `jq --version`; on a Mac, `brew install jq`). On Windows, the `chmod` and hook steps are different; pair up with someone or skip to step 4 and come back.

## Steps

Times are rough and add up to about 90 minutes.

### 1. Look at what you have (5 min)

Open a terminal in your project folder and start Claude there. It can only see the folder you start it in, and the most common problem in the hands-on is starting it from the wrong one.

```
cd ~/research/my_project
claude
```

Then ask:

```
List every file in this folder and its subfolders. For each one, say in a few words what it is: raw data, cleaned data, code, output, my own writing, a paper, or something else. Don't move or change anything.
```

Check the list. Anything it calls "raw data" that you know you edited by hand isn't raw any more; note that, because it changes what you can reproduce. Quit with `/exit` when you're done.

### 2. Sort the folders (10 min)

The layout from the talk:

```
my_project/
  CLAUDE.md         instructions, read every session
  .claude/          agents, skills, settings
  data/raw/         original files, never edited
  data/clean/       written by code only
  code/             01_ingest.py, 02_clean.py, ...
  output/           tables, figures, logs
  paper/            your draft
  literature/       one summary per paper
  institutional/    laws, policies, how the system works
  notes/            plans, decisions, referee reports
  comments/         feedback, one file per person
```

You don't need every folder. Make the ones you'll use:

```
mkdir -p data/raw data/clean code output/logs notes
```

Move the files yourself, in Finder or the terminal, before you copy the kit in step 3. Do the raw data files yourself on purpose: the hook in step 3 blocks Claude from moving or copying anything into `data/raw/`, and you want to be the one who decides what counts as raw. If you're unsure where something goes, ask Claude for a list of suggested moves and do them yourself.

Principle 1 from the talk applies here: keep your work apart from the AI's. Your draft, your idea notes, and your raw sources go in folders Claude reads but doesn't write. Claude writes to `code/`, `data/clean/`, `output/`, and `notes/`.

What goes wrong: Stata and R projects often have hard-coded file locations (`use "C:/Users/me/Dropbox/data.dta"`). Moving files breaks them. That's fine for today; the plan-mode task in step 6 can fix the one script you work on.

### 3. Copy the kit and lock the raw data (10 min)

Check first whether your project already has a `.claude` folder or a `CLAUDE.md`, since copying would overwrite your settings:

```
ls -a
```

If there's no `.claude` folder, copy the kit's:

```
cp -r ~/claude-code-research-workshop/.claude .
```

If you already have one, copy only the agents and the hook (`.claude/agents/` and `.claude/hooks/`) and add the `deny` list and the `hooks` entry from the kit's `.claude/settings.json` into yours by hand.

Don't copy the kit's `CLAUDE.md`. That one is for the jail project; you'll write your own in step 4.

Now lock the raw data at the operating-system level, and keep a copy somewhere else:

```
chmod -R a-w data/raw
cp -r data/raw ~/backup_my_project_raw
```

The kit gives you three protections, and they cover different things. The `deny` rules in `.claude/settings.json` stop Claude's Edit and Write tools from touching `data/raw/`. The hook in `.claude/hooks/protect-raw.sh` runs before every edit and every shell command and blocks the ones that would change `data/raw/` (`sed -i`, `>`, `mv`, `rm`, and similar). The `chmod` catches what both miss, like a Python script that opens a raw file for writing. In our tests, the rule in CLAUDE.md alone didn't stop Claude when I said "go ahead and fix it in that file" (5 of 5 runs changed the raw file); with the hook on Edit, Write and Bash, 0 of 10 did.

If you want your own writing protected the same way (principle 1), add lines to the `deny` list in `.claude/settings.json` for that folder, for example `"Edit(paper/**)"` and `"Write(paper/**)"`.

Test it. Start `claude` again and type:

```
There's a typo in one of the files in data/raw/. Go ahead and fix it in that file.
```

You want to see the edit blocked, with a message about raw data. If Claude edits the file anyway, stop and check that you started `claude` from the project folder and that `jq --version` works.

### 4. Write CLAUDE.md (20 min)

Use the blank template in `examples/CLAUDE_template.md` (planned). It has four parts, each with prompts to answer:

- Project: the question in one or two lines.
- Folders: where things are, and what's off limits.
- Data notes: what one row is, and known problems in the data.
- Rules: how to work, written so you could check the output and tell whether the rule was followed.

First, get a draft from Claude:

```
/init
```

`/init` reads the folder and writes a first CLAUDE.md. For research projects it usually writes a summary of the code and misses what matters: the question, the data's problems, what's off limits. So rewrite it against the template:

```
Rewrite CLAUDE.md using the four parts in ~/claude-code-research-workshop/tracks/1-your-own-project/examples/CLAUDE_template.md. Keep only what you can see in this folder. Where you'd be guessing, write TODO instead. Keep it under 40 lines.
```

Then open `CLAUDE.md` in your own editor and fill in the TODOs. You know things Claude can't see: the question, which file is the real one, which variable is broken. Delete anything vague or wrong.

For the data notes, have the data profiler look first. It describes the data and doesn't change anything:

```
Use the data-profiler agent on data/raw/<your file>
```

It writes `notes/data_report_<file>.md`: what one row is (and a test that it's true), what each column means, missing values by year, and anything that would make a simple sum wrong. Read it, and copy the problems that matter into the Data notes part of CLAUDE.md in one line each. In the experiment, this part made the difference between 7 of 20 and 20 of 20.

For the rules, aim for 4 to 6 you can check. The slide from the talk:

| Vague | Checkable |
|---|---|
| Be careful with the data | Print the row count after every filter or merge |
| Don't make things up | Never report a number you didn't compute from a file in this project |
| Use good sources | Cite only papers with a summary in literature/ |
| Understand the data | Read the codebook before using a column |

Watch your wording. Claude follows rules literally, as my "stop and say so" rule showed. The kit's version is: "If a check fails, say so first. If the fix is clear, fix it and report the number before and after. If the fix isn't clear, stop and ask."

Then add one line pointing to a decisions file (principle 5): `Decisions made so far are in notes/decisions.md. Read it before planning.` Create that file now, even if it's empty.

Test the file in a fresh session:

```
/clear
What rules do you follow in this project? What's in data/raw/, and what are you not allowed to do with it?
```

If the answer is missing something you wrote, the line is probably too vague or too long. Fix it and ask again.

Compare yours with the filled-in example in `examples/CLAUDE_example.md` (planned). If you're on the example project, do this after you've written your own, since the example lists the data problems you'd otherwise find yourself.

### 5. Write the plan yourself (10 min)

Principle 0: plan first, in detail. Write `notes/my_plan.md` for your task in your own editor. The template in `examples/plan_template.md` (planned) has the headings from the talk:

- Goal: what you want and why.
- Read first: the exact files.
- Definitions: what one unit is.
- Sample: which rows, which years.
- Steps: numbered.
- Checks: things that pass or fail, written before any code runs. A number from somewhere else you can compare to is the best kind.
- Output: which files, where.
- Out of scope: what not to do.
- Stop and ask me if: the cases where you want to decide.

Ten minutes on this saves you from reading a long plan from Claude and trying to spot what it assumed. If you're on the example project, a filled-in plan is on the "Plan first" slide; try writing your own before you look at it.

### 6. Plan mode (10 min)

Start a fresh session (`/clear`), then press Shift+Tab until the bottom of the screen says plan mode. In plan mode Claude can read files and write a plan but can't edit or run anything. Type:

```
Read CLAUDE.md, notes/decisions.md and notes/my_plan.md. Make a plan to carry out notes/my_plan.md. List the files you'll read and the files you'll create or change, the exact filters and merges, the row count you expect after each, and how we'll know it worked.
```

Check the plan against this list:

- Which files it reads, and which it changes. Nothing in `data/raw/` or your own writing should be on the change list.
- The exact filters and merges, in words you can check against the codebook.
- The row count it expects after each.
- What it won't touch.
- How you'll know it worked: the checks from your plan, with numbers.

Then tell it what to change, in plain language, and look at the new plan. Ctrl+G opens the plan in your editor if it's easier to edit it there. Most plans need two or three rounds. On the example project, the thing to look for is whether it sums every row in a year: that counts a county up to four times, and it's the first mistake from Part 4 of the talk.

What goes wrong: the plan is vague ("clean the data", "handle missing values"). Ask "which rows exactly?" until it says. Or it adds steps you didn't ask for, like a regression. Tell it they're out of scope.

### 7. Approve and check the result (15 min)

Approve the plan. Claude now writes the script in `code/`, runs it, and writes to `data/clean/` or `output/`. Then check:

- The script is in `code/` and runs again from start to finish: `python code/01_clean.py` (or however your project runs). Every number should come from a script, not from something Claude typed into the terminal once.
- The row counts in the log in `output/logs/` match what the plan said to expect. If they don't, ask why before anything else.
- Your checks passed. Ask: `For each check in notes/my_plan.md, say pass or fail and show the number.`
- `data/raw/` didn't change. If you made the backup in step 3: `diff -r data/raw ~/backup_my_project_raw` should print nothing.

What goes wrong: a check fails and Claude explains it away. Ask it to show you the rows. Or it ran fine but the numbers are off by a lot from what you know. Trust what you know and ask it to look for repeated rows.

### 8. Write down what you decided (10 min)

Principle 5: document all human decisions. During steps 6 and 7 you made choices Claude didn't know about. Write each one in `notes/decisions.md`: what you chose, what you rejected, and why. The format from the talk:

```
D1 · Which count to use
Claude's guess: add up every row in the year
We decided: June 30 count only
Why: BJS uses mid-year; summing counts a county up to 4 times
```

You can ask Claude for a first draft (`List every choice I made in this session that changed the plan or the result, in the format in notes/decisions.md`), but check it: it'll list choices it made too, and you want only yours, or ones you agreed to.

Then, for any mistake you don't want again, add one line to CLAUDE.md:

```
You summed every quarter. Add a line to CLAUDE.md so that doesn't happen again.
```

Read the line it adds, since it's going into every session from now on.

## If you finish early

- Have the referee check your plan before you run the next task: `Use the referee agent on notes/my_plan.md`. It lists the three most serious problems and doesn't change any file.
- Do a second task in a new session from the same CLAUDE.md, and see whether it follows the rules without being reminded. Every rule it ignores needs rewording; every mistake it makes again needs a line in the data notes.

## Finished when

- A fresh session (`/clear`, then "What rules do you follow in this project?") gives back your question, your folders, and your rules.
- Asking Claude to fix something in a file in `data/raw/` gets blocked.
- One task is done from a plan you checked, with its script in `code/`, its output in `output/`, and at least one entry in `notes/decisions.md`.
