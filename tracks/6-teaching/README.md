# Track 6: Teaching

Write a problem set, its solutions, and a grading rubric for a course you teach, and check all three with sessions that didn't write them.

I'd use Claude for this because the usual way I find a mistake in a problem set is a student emailing me the night before it's due. A question can have two reasonable readings, and I won't see the second one because I know what I meant. I saw this in the replication test in the talk: I asked for a wage-gap regression, and 4 of 40 runs ran it on State A only. That's a defensible reading of the question I wrote, and I'd never have noticed it on my own. So the main check in this track is the same idea: a separate session solves the problem set without seeing your solutions, and every place it disagrees with you is either a mistake in your solutions or a question that can be read two ways. The talk also showed the limit of this. When the same model checked the same model, it usually made the same reading, so agreement doesn't prove the solutions are right. You still read them yourself.

## Before you start

- The course, the topic, and what students should be able to do after this problem set. One page of lecture notes or an outline is enough.
- Which software your students use (R, Stata, or Python), and that it's installed on your laptop, since Claude will run the solution code.
- Optional: an old problem set on the topic, so Claude can match your style and level.
- No real student work. Don't paste in student answers, names, IDs, emails, or grades, and don't start Claude in a course folder that has rosters or grade files in it, because Claude can read every file in the folder you start it in. This track uses made-up student answers only.

If you don't bring your own course, use the example: a problem set on omitted variable bias for an intro econometrics course. It has two files (planned; check that they're in the kit before you rely on them):

- `examples/mine/lecture_outline_ovb.md`: a one-page lecture outline (the omitted variable bias formula, the sign of the bias, proxy variables, and a wages-and-schooling example).
- `examples/mine/data_spec_ovb.md`: the model for a small simulated dataset (log wage, years of schooling, a test score that measures ability with error, experience), with the true coefficients and the random seed. Because the data are simulated, you know the true effect of schooling, so you have a check that doesn't depend on Claude.

The example also has copies of the two agent files below in `examples/agents/` (planned).

## Steps

Times add up to 90 minutes. Steps 5 and 8 happen in a second folder, outside your course folder, so the checking session can't see your solutions.

### 1. Set up the course folder (10 min)

Make a new folder and copy the kit's `.claude/` folder into it. You want the kit's `number-checker` agent; the kit's `CLAUDE.md` is for the jail project, so don't copy that one. Set `KIT` to wherever you saved the kit.

```
KIT=~/path/to/workshop_kit
mkdir -p ~/ps_ovb/mine ~/ps_ovb/code ~/ps_ovb/output ~/ps_ovb/ps ~/ps_ovb/notes ~/ps_ovb/data/sim
cp -r $KIT/.claude ~/ps_ovb/
cp $KIT/tracks/6-teaching/examples/mine/*.md ~/ps_ovb/mine/
chmod -R a-w ~/ps_ovb/mine
cd ~/ps_ovb
```

If you brought your own course, put your lecture notes (and an old problem set, if you have one) in `mine/` instead of the example files. If your notes are a PDF, that's fine; Claude can read it.

`mine/` is your work, and the `chmod` makes it read-only so Claude can read it but not change it (principle 1). Everything Claude writes goes in `code/`, `output/`, `ps/`, and `notes/`.

### 2. Write CLAUDE.md and the decisions file (5 min)

Create `CLAUDE.md` in the folder (in your editor, or ask Claude to write it from this text and then read it). Change the bracketed parts.

```
# Course: [ECON 103, Introduction to Econometrics]. Problem set [4]: omitted variable bias

Students: [second-year undergraduates; they know OLS with two regressors; they use R].

## Folders
- mine/: my lecture outline and notes. Read only. Never edit.
- code/: 01_make_data.[R/py] makes the simulated data; 02_solutions.[R/py] computes every number in the solutions.
- data/sim/: the simulated data. Don't regenerate it after the solutions are written.
- output/: everything 02_solutions writes. Every number in ps/solutions.md comes from a file here.
- ps/: problem_set.md, solutions.md, rubric.md. Three separate files. problem_set.md never contains answers or hints from the solutions.
- notes/: decisions.md (my decisions) and check reports.

## Rules
- Every question tests something in mine/. In ps/solutions.md, give the section of the outline each question comes from.
- Use the notation in mine/, not a textbook's.
- Read notes/decisions.md before changing the problem set, the solutions, or the rubric.
- No real student work, names, IDs, or grades in this folder.
```

Then create `notes/decisions.md` with a few decisions you already know. For the example these could be:

```
# Decisions
D1. Bias means (short-regression estimate) minus (true effect). Students may use either sign convention if they say which.
D2. Numbers to 3 decimals. Accept answers within 0.002.
D3. No matrix algebra. The bias formula is the two-regressor version from the outline.
```

This is principle 5. Claude will guess on choices like these if you don't write them down, and every later session, including the checking ones, reads the file.

### 3. Plan the problem set (10 min)

Start `claude` in the course folder and press Shift+Tab until the prompt says plan mode. Type (for the example):

```
Read mine/lecture_outline_ovb.md, mine/data_spec_ovb.md and notes/decisions.md. Plan a problem set on omitted variable bias for the course in CLAUDE.md: 5 questions, about 2 hours of work for a student, 50 points. Two questions are conceptual (the direction of the bias, from the signs in the formula). Three use the simulated data: the short regression, the regression with the test score added, and a numerical check that the short estimate equals the long estimate plus the omitted coefficient times the auxiliary-regression coefficient. For each question give what it tests, the outline section it comes from, and what kind of answer it needs (a number, a sign, or a few sentences). List the files you'll write: code/01_make_data, code/02_solutions (it saves its numbers to output/solution_numbers.json), ps/problem_set.md and ps/solutions.md. Don't write the rubric yet. Stop and ask me if a question needs something the outline doesn't cover.
```

For your own course, change the topic, the files, and the question list.

Claude reads the files and writes a plan; it can't change anything yet. Press Ctrl+G to open the plan in your editor if you want to edit it directly. Check that the plan:

- maps every question to a section of your outline (a question on something you didn't teach is the most common problem here),
- says exactly which regressions the data questions run, on which variables,
- says what students hand in for each question,
- doesn't put answers into the problem set file,
- fits the time you gave it. Count the parts. Five questions with four parts each is more than 2 hours for most undergraduates.

Tell Claude what to change, then approve. Writing the plan is principle 0: every vague word in the plan becomes a vague question for students.

### 4. Write the data, problem set, and solutions (15 min)

After you approve, Claude writes the files. For the example, it writes `code/01_make_data` from `mine/data_spec_ovb.md`, runs it to make `data/sim/ovb_wages.csv`, then writes `code/02_solutions`, runs it, and writes `ps/problem_set.md` and `ps/solutions.md`.

Check these yourself:

- The simulated data match the spec. Ask: `Print the number of rows, the mean of each column, and the coefficients from regressing log wage on schooling, the test score and experience.` In the example, the coefficient on schooling in the long regression should be near the true value in `mine/data_spec_ovb.md`, and the short regression should be higher, because ability raises both schooling and wages.
- The problem set has no answers in it, and the questions refer to the data's actual column names.

Then run the kit's number checker on the solutions:

```
Use the number-checker agent on ps/solutions.md
```

It lists every number in the solutions and the file in `output/` it comes from, marked MATCH, MISMATCH, or NO SOURCE. Read its table (in `notes/numcheck_solutions.md`, or in its reply if it couldn't write the file). A NO SOURCE usually means Claude worked out a number in the text instead of in `02_solutions`. Ask Claude to add it to the script and rerun. This is principle 2: every number in the solutions points to a file.

### 5. Have a separate session solve it (15 min)

Open a second terminal. Make a folder outside the course folder and copy in only the problem set and the data:

```
mkdir -p ~/ps_check
cp ~/ps_ovb/ps/problem_set.md ~/ps_ovb/data/sim/ovb_wages.csv ~/ps_check/
cd ~/ps_check
claude
```

The folder has to be outside `~/ps_ovb`. If it were inside, Claude would also load the course's `CLAUDE.md`, and the solutions would be one folder up. If this session ever asks to read a file outside `~/ps_check`, say no.

If you can, use a different model here than in the course session (type `/model` to pick one). In the talk's replication test, a checker running on the same model as the worker usually made the same reading; a different model raised the problem more often.

Type:

```
Solve every question in problem_set.md as a strong student in this course would, using only that file and ovb_wages.csv. Write your code to solve.[R/py] and run it. Write your answers to answers.md, numbered as in the problem set. After each answer, add two lists: (1) every assumption you had to make because the question didn't say, and (2) any place where the wording could be read more than one way, with the other reading. Don't look for files outside this folder.
```

The assumption lists are the most useful part of the output. Read them before you compare any numbers. An entry like "assumed the regression includes experience" or "assumed 'bias' means estimate minus truth" is a question you need to tighten, even if the numbers end up matching.

### 6. Compare the two sets of answers, and fix (15 min)

Back in the course folder, copy the answers in:

```
cp ~/ps_check/answers.md ~/ps_ovb/notes/independent_answers.md
```

Create the comparison agent. Type `/agents`, choose to create a project agent, and paste this, or save it as `.claude/agents/ps-compare.md` (a copy is planned at `examples/agents/ps-compare.md`):

```
---
name: ps-compare
description: Compares the answer key with an independent solution of the problem set. Use after a separate session has solved the problem set.
tools: Read, Grep, Glob, Write
---

You did not write the problem set, the solutions, or the independent answers.

Read ps/problem_set.md, ps/solutions.md, notes/independent_answers.md, notes/decisions.md and the outline in mine/.

For each question and part, compare the key's answer with the independent answer. Numbers within the tolerance in notes/decisions.md count as the same. For every difference, and for every assumption or second reading the independent answers list, say which of these it is:
- KEY MISTAKE: the key is wrong. Quote the line and say why.
- UNCLEAR QUESTION: both answers follow from a reasonable reading of the question. Quote the words that allow both.
- SOLVER MISTAKE: the independent answer is wrong under any reasonable reading.
- NOT IN OUTLINE: the question needs something mine/ doesn't cover.

Write notes/compare_report.md: a table with question, key answer, independent answer, category, and evidence. Put KEY MISTAKE and UNCLEAR QUESTION rows first. Do not edit any other file.
```

Then type `Use the ps-compare agent`.

This is principles 3 and 4: the agent has one job and a list of what to look for, and it reports but doesn't change anything. You decide each row. For each one, write a line in `notes/decisions.md` (what you changed and why, or why you left it), then tell the course session what to fix, for example `Fix question 3 per D4 in notes/decisions.md: say that the long regression includes experience. Rerun 02_solutions and update the solutions.`

Things that go wrong here:

- The agent calls a real difference "rounding." Check any row where the two numbers differ in the second decimal.
- Claude, asked to fix things, changes the key to match the independent answer. Decide yourself which one is right before asking for any fix.
- Both sessions agree on a wrong answer. In the example, compare the long-regression estimate with the true value in the data spec. For your own course, read the solutions yourself.

After the fixes, copy the new `problem_set.md` to `~/ps_check/`, type `/clear` in the checking session, and have it solve only the questions you changed. Stop after two rounds; if a question still gets read two ways, rewrite it yourself.

### 7. Write the rubric (5 min)

In the course session:

```
Write ps/rubric.md from ps/problem_set.md, ps/solutions.md and notes/decisions.md. For each question and part: the points, what a full-credit answer must contain, the common mistakes and how many points each one loses, and what earns partial credit. Total 50 points. Describe partial credit by specific mistakes, not "a reasonable attempt." A grader who has not seen the solutions should be able to use it.
```

Check that the points add to 50 and that every part has at least one named mistake with a point value. Conceptual questions need the most detail, since "explains the direction of the bias" can mean a lot of things.

### 8. Test the rubric on made-up answers (15 min)

Ask the course session to write three made-up answer sheets:

```
Write three made-up student answer sheets for ps/problem_set.md in notes/fake_answers/: student_A.md is strong with one small slip; student_B.md gets the sign of the bias wrong in the conceptual question but does the data questions correctly; student_C.md gives the right numbers with no explanation. Write them the way real undergraduates write: incomplete sentences, some wrong notation. Don't include scores.
```

Before any grading, write your own score for each sheet, by part, in `notes/intended_scores.md`. This is your decision, so write it yourself.

Copy the rubric and the answer sheets (not your scores, not the solutions) to the checking folder:

```
cp ~/ps_ovb/ps/rubric.md ~/ps_ovb/notes/fake_answers/*.md ~/ps_check/
```

In the checking session, type `/clear`, then:

```
Grade student_A.md, student_B.md and student_C.md using only rubric.md and problem_set.md. For each part, give the points and quote the rubric line you used. Where the rubric doesn't say what to do with an answer, say so and give the score you'd give. Write grades.md.
```

Compare `grades.md` with your scores. A part where the grader quoted a different rubric line than you would have, or said the rubric doesn't cover the answer, is a part where two human TAs would also disagree. Tighten that line of the rubric, add a decision to `notes/decisions.md`, and grade again.

## If you finish early

- Check whether the grader is consistent: type `/clear` and grade the same three sheets again. Any part that gets a different score the second time needs a clearer rubric line.
- Make a second version of the data for another section or next year: change only the seed in `code/01_make_data`, rerun both scripts, and run the number checker on the updated solutions. If you want to make steps 5 and 6 a single command, Track 4 shows how to turn them into a skill.

## Finished when

- `ps/problem_set.md`, `ps/solutions.md` and `ps/rubric.md` are separate files, and the number checker marks every number in the solutions MATCH.
- Every row in `notes/compare_report.md` marked KEY MISTAKE or UNCLEAR QUESTION has a line in `notes/decisions.md` saying what you changed or why you left it.
- The grader's scores on the three made-up sheets match yours on every part, or you've changed the rubric where they didn't.
