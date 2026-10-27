# Track 7: Your writing voice

Build a style guide from your own writing, with numbers, so Claude can write summaries, emails, and drafts that sound like you, and so you can check whether they do.

I did this with my sent Gmail, text messages, ChatGPT messages, and other writing like my journal. The email part alone was 2,385 sent emails from 2012 to 2026. A script counted things about how I write: sentence length (median 15 words, and 27% of my sentences are under 8 words), the words and phrases I use most, how I open and close emails, punctuation, how often I hedge, and sentiment. Claude turned those counts into a one-page voice profile. Now every project's CLAUDE.md points to it, and when Claude writes a summary for me it reads like me and not like a press release.

The numbers matter more than the description. "Write casually" doesn't tell Claude much. "Median sentence 15 words, no em dashes, I say 'let's' and never 'delve'" does, and you can count whether the output follows it.

## Before you start

- Python 3 with `nltk` and `textblob` (`pip install nltk textblob`). Claude will download the NLTK data it needs.
- An export of your own writing. Email is the easiest, because everyone has a lot of it:
  - **Gmail:** Google Takeout (takeout.google.com), select only Mail, and pick the "Sent" label. It arrives as an `.mbox` file. A large mailbox can take hours, so start the export before the session.
  - **ChatGPT:** Settings, Data controls, Export data. You get a zip with `conversations.json`.
  - **Anything else you wrote yourself:** journal entries, blog posts, papers, referee reports, as `.txt`, `.md`, `.docx`, or PDF.
  - **Text messages:** on a Mac, these are in `~/Library/Messages/chat.db`, which needs Full Disk Access to read. Skip them unless you've done this before.

If you can't get an export in time, use 10–20 things you've written: paper introductions, referee reports, long emails copied into text files.

## Privacy

Your email has other people's private information in it. The plan in this track is that **Claude writes the scripts, the scripts read your raw writing on your laptop, and Claude only reads the counts.** The NLTK analysis runs locally; nothing in it sends text anywhere. You check the cleaned text yourself in step 3, so Claude never needs to read it.

Set this up before you start (step 1), and don't start Claude in a folder that has the raw exports in a place it can read.

## Steps

### 1. Set up the folder (10 min)

```
KIT=~/path/to/workshop_kit
mkdir -p ~/voice/data/raw ~/voice/code ~/voice/output ~/voice/notes
cp -r $KIT/.claude ~/voice/
cd ~/voice
```

Put your exports in `data/raw/` and make them read-only:

```
chmod -R a-w data/raw
```

The kit already blocks Claude from editing anything in `data/raw/`, which is why the exports go there.

Also stop Claude from opening those files. In `.claude/settings.json`, add this line to the `"deny"` list that's already there:

```
"Read(data/raw/**)",
```

Scripts you run can still read `data/raw/`; Claude's own Read tool can't. Claude could still print a file with a shell command like `cat`, but it asks you before running commands, and the rule in CLAUDE.md below tells it not to. Then write `CLAUDE.md`:

```
# Project: a style guide from my own writing

## Folders
- data/raw/: my exports (email, messages, writing). Read only. Never open or print these files.
- code/: 01_extract.py, 02_analyze.py
- output/: what the scripts write. Only output/report.txt and output/profile.json are for you to read.
- notes/: voice_profile.md and decisions.md

## Rules
- Never print, quote, or summarize text from data/raw/ or output/corpus_clean.txt.
- Only my own messages: for email, sent by me; for ChatGPT, role "user"; for texts, is_from_me.
- Every number in notes/voice_profile.md comes from output/report.txt.
```

### 2. Extract your own text (15 min)

Start `claude` and use plan mode (Shift+Tab). Ask:

```
Write code/01_extract.py. Read every export in data/raw/ and write output/corpus_clean.txt with one message per block, separated by a line "=====". Keep only text I wrote: drop quoted replies (lines starting with ">" and everything after "On ... wrote:"), signatures, forwarded messages, and automatic messages. Add a header line to each block with the source (email, chatgpt, other) and the year. Print counts: messages and words by source and year. Don't print any message text.
```

Read the plan, approve it, and look at the counts. A year with almost nothing in it, or a source that's ten times bigger than you expected, usually means the filter is wrong.

### 3. Check the cleaning (10 min)

Open `output/corpus_clean.txt` yourself and read 10 blocks at random. You're looking for things that aren't yours: quoted replies, signatures, "Sent from my iPhone", newsletter text, other people's messages. Each one you find goes in `notes/decisions.md` as a rule ("drop lines starting with 'Sent from my'"), then have Claude add it to `01_extract.py` and run it again.

This is the step that matters most. If a third of the corpus is quoted replies from your coauthors, the profile will describe them.

### 4. Measure your writing (20 min)

```
Write code/02_analyze.py. It reads output/corpus_clean.txt and writes output/profile.json and output/report.txt with only counts and statistics, no message text and no full sentences. Use nltk and textblob. Report, overall and by source:
- sentence length: mean, median, and the share under 8, 8-19, 20-34, and 35+ words
- the 50 most common words excluding stopwords, and the 30 most common two- and three-word phrases
- how messages start and end (first and last 3 words), as counts
- punctuation per 1,000 words: em dashes, semicolons, exclamation marks, question marks, parentheses
- I / we / you per 1,000 words
- hedging words (maybe, perhaps, might, I think, seems) and direct words (should, need, will) per 1,000 words
- sentiment: VADER compound score, mean and distribution
Run it and show me report.txt.
```

Read the report. Check two numbers yourself: pick a phrase from the top-30 list and search your own sent mail for it, and check that the message count matches step 2.

### 5. Write the voice profile (15 min)

```
Read output/report.txt and write notes/voice_profile.md: at most 300 words. The 5 to 8 things that are most distinctive about how I write, each with the number from the report. Then a short list of words and punctuation I almost never use. Don't describe my personality; describe what can be counted.
```

Then edit it yourself. Claude will try to describe you ("warm, direct, efficient"). Cut those and keep the numbers and the word lists. Add anything you know about yourself that the counts miss.

### 6. Test it (20 min)

Pick a short piece of writing you'd normally do: a paper summary, an email to a coauthor, a referee report paragraph. Start a new session with `/clear` and ask for it twice, in two files:

```
Write output/test_without.md: [the task]. Don't read notes/voice_profile.md.
```

```
Read notes/voice_profile.md and write output/test_with.md: [the same task], in my voice.
```

Then measure both the same way you measured yourself:

```
Run the same measures as code/02_analyze.py on output/test_without.md and output/test_with.md, and put them in a table next to my numbers from output/report.txt. Don't change 02_analyze.py.
```

The version with the profile should be closer on sentence length, punctuation, and the words on your "almost never" list. If it isn't, the profile is too vague; make the line that failed more specific and test again. Then read both yourself. The numbers can match and it can still not sound like you, and that's worth a line in the profile too.

## If you finish early

- Point every project at the profile. Add one line to `~/.claude/CLAUDE.md`, the file that applies to all your projects: "When writing for me, follow ~/voice/notes/voice_profile.md." Move the file somewhere permanent first.
- Make separate profiles by context. Your email to a coauthor isn't your referee report. Run `02_analyze.py` by source and see which numbers change.
- Make a checking agent. Write `.claude/agents/voice-checker.md` that runs the measures on a draft and lists every place it doesn't match the profile, without editing the draft.

## Finished when

- `output/corpus_clean.txt` has only your writing, and you've read 10 random blocks to check.
- `notes/voice_profile.md` is under 300 words, and every number in it is in `output/report.txt`.
- You've measured one piece written with the profile and one without, and you know which numbers moved.
