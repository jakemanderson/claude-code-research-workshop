# Track 3: Literature library

Build a library of 10–20 papers you can search, where every paper has a summary with the same sections, and every citation Claude gives you can be checked against those summaries.

I have about 800 papers summarized this way. When I asked Claude for papers from memory on jail populations during COVID, 41 of 43 citations were real, with the right authors, year, and title. That sounds good, but you can't tell which 2 are wrong without checking every one, and one of them was a paper that doesn't exist, by real authors who work on that topic. On my immigration bond project, four search agents went through the literature and found that nobody had used bond-judge assignment as an instrument. Some papers were behind a login, so Claude couldn't get them; I downloaded those in Chrome myself and had Claude ingest them. Because every summary has the same sections, a search agent can compare identification strategies across papers: the design is always under the same heading.

Claude gets most of a summary right and some numbers wrong, so a big part of this track is checking a few summaries against the PDFs before you trust the rest.

## Before you start

- 10–20 PDFs of papers you know well. Papers you know well matter more than the number: you'll check the summaries against your own memory, and you'll test the search with a question you already know the answer to.
- Claude Code installed and logged in. Ingesting 15 long papers uses a lot of tokens; on a Pro plan you may hit the usage limit, so start with 10.
- The workshop kit cloned into `~/Documents/claude-code-research-workshop`. You'll copy its `.claude/` folder.

## Steps

### 1. Set up the folder (10 min)

Make a new folder for the library and copy the kit's `.claude/` folder into it:

```
mkdir -p ~/research/lit_library/papers_to_add
cd ~/research/lit_library
cp -R ~/Documents/claude-code-research-workshop/.claude .
mkdir -p literature notes papers
```

Put your PDFs in `papers_to_add/`. Then make them read-only, so nothing Claude does can change your originals:

```
chmod -R a-w papers_to_add
```

This is principle 1, keep your work apart from the AI's. `papers_to_add/` is yours. `papers/` (renamed copies) and `literature/` (summaries) are written by Claude. The skill copies each PDF and never moves it, but making the folder read-only means you don't have to trust that.

Write your own `CLAUDE.md` in this folder. Start it with a title for your project and a Question line, like `Question: How does pretrial detention affect case outcomes?` The skill uses the Question line: at the end of each ingest it tells you in two sentences how the paper relates to it. Add the folders above and what each one is for, and the rule "Cite only papers that have a summary in `literature/`."

Then start Claude Code from the folder:

```
claude
```

### 2. Ingest one paper (10 min)

Pick the paper you know best and type:

```
/ingest-paper papers_to_add/[file].pdf
```

Claude will read the first pages to get the title, authors, and year, pick a name like `dobbie_2018_pretrial_detention_judges.pdf`, copy the PDF to `papers/`, read the rest of the paper, and write `literature/[same name].md`. It asks for permission the first time it copies a file or writes a summary; choose the option that allows it for the rest of the session.

Open the summary. It has a header (title, authors, year, journal, status, tags, location, doi, source file) and eight sections: Research Question, Contribution, Econometric Strategy, Identification, Data & Sample Construction, Key Findings, Limitations, References to Related Work.

### 3. Check that summary against the paper (10 min)

This is principle 2, ask for citations, applied to the summaries themselves. Check these by hand, with the PDF open:

- Title, authors, and year match the first page of the PDF. A working paper should say `status: working_paper`, not the journal it was later published in.
- The doi. If the DOI isn't printed in the PDF and the field is filled in, Claude probably filled it from memory. Look it up at doi.org. A wrong DOI is the same problem as a made-up citation.
- Every number in Key Findings. Search the PDF for each one (Cmd+F or Ctrl+F). Numbers that only appear in a table are harder to find this way, so look those up in the table itself.
- Identification. Would you describe the design to a colleague the same way?
- Limitations. The skill asks for the gaps the authors acknowledge. Check that these are in the paper and aren't Claude's own opinions.

To have Claude do the lookup with you, ask it to report without changing anything:

```
For each number in Key Findings in literature/[file].md, find where it appears in papers/[file].pdf. Give the page and quote the sentence or table row. Don't edit the summary. If you can't find a number, say so.
```

Then check two or three of its quotes yourself. Mistakes to look for: a number from a different specification or a robustness table, a percent where the paper says percentage points, or a result for a subgroup reported as the main result. For long papers the skill reads the introduction, results, and conclusion, so results that are only in an appendix get missed.

### 4. Fix the skill, not the summary (10 min)

When a summary misses something, change the instructions so every future summary gets it right. Open `.claude/skills/ingest-paper/SKILL.md` and edit step 5. Changes people usually want:

- "After each number in Key Findings, give the page it's on, like (p. 14)." This makes every later check faster.
- "Leave doi empty unless it is printed in the PDF."
- Sections for your field. The sections are written for applied economics. A sociologist or demographer might want Theory, Design, Data, Measures, Findings, Limitations. If you rename or drop Research Question, also change step 1 of `.claude/skills/lit-search/SKILL.md`, which searches the titles, tags, and research-question sections.
- Things you always want to know, for example the sample period, the geography, or how the outcome is defined.

Write each change and the reason in `notes/decisions.md` (principle 5). A new session doesn't know why the sections are the way they are, and you'll forget too.

Then type `/clear` to start a fresh session, so Claude isn't working from what it remembers of the first summary, and run `/ingest-paper` on the same paper again. Check that the changes show up. If they don't, the instruction is probably too vague; make it a specific action.

### 5. Ingest the rest (25 min)

You can run `/ingest-paper` on each PDF one at a time; it's slow but you see each result. Or ask Claude to do them in parallel:

```
Ingest every PDF in papers_to_add/ that doesn't have a summary in literature/ yet. For each one, follow .claude/skills/ingest-paper/SKILL.md exactly. Use one subagent per paper, at most 4 at a time. At the end give me a table: original file, new file name, summary file, and anything you weren't sure about.
```

A subagent is a separate Claude session that gets one job and reports back. Here each one reads one paper, so the long PDFs don't fill up your main session. If your `CLAUDE.md` says to use plan mode for anything that changes more than one file, Claude may show you a plan first; read it, check it covers every PDF, and approve it.

While it runs, pick a second paper you know well and check its summary the way you did in step 3. When it's done, check:

- The counts match: `ls papers_to_add/*.pdf | wc -l` and `ls literature/*.md | wc -l` should give the same number (the second will be off by one if you ingested the first paper twice under different names, so look for duplicates).
- No two papers got the same file name. Two papers by the same author in the same year are the usual case.
- Check the summaries of old scanned PDFs (no selectable text) next. Claude has to read those pages as images, so the numbers are the first thing to look at.

If Claude stops partway because of the usage limit, the summaries it already wrote are saved. Run the same prompt again later; it skips papers that already have a summary.

### 6. Search the library (15 min)

Before you run anything, write down your own answer in `notes/expected.md`: the question, and the papers in your library you'd expect a good search to find. Do this yourself, not with Claude, so you have something to compare against (principle 1 again).

Then run:

```
/lit-search [your question]
```

The skill searches the titles, tags, and research-question sections in `literature/`, and writes `notes/lit_<date>.md` with a table of papers (paper, file, what it does, how it relates to the question), a "To find" list, and two or three sentences on what would be new. Then it hands the file to the `citation-checker` agent and fixes or removes anything the checker flags.

Check:

- Compare the table with `notes/expected.md`. A paper you expected that's missing usually means its tags or research question don't use the words in your question; read its summary and see why.
- Every paper in the table has its own file in `literature/`. Papers that are only mentioned inside another summary should be under "To find." The "To find" list is how the library grows: those are the papers your library cites but doesn't have.
- The citation checker's report is in `notes/citecheck_<file>.md`. The checker didn't pick the citations and can't edit the draft (principles 3 and 4). It only has tools to read files, so if the report file isn't there, ask Claude: "Save the citation checker's table to notes/citecheck_lit_<date>.md exactly as it returned it."
- If the checker flagged something, look at what Claude changed in `notes/lit_<date>.md` to fix it, and check that the fix matches the flag.

### 7. Test the checker with mistakes you planted (10 min)

A checker that says everything is OK hasn't shown you anything until you've seen it catch a mistake. You know where the mistakes are in a paragraph you wrote yourself, so you can tell exactly what the checker caught and what it missed. Write a short paragraph in `notes/check_me.md` that cites four papers from your library, and put in three mistakes: one wrong year, one claim the paper doesn't make, and one paper that isn't in your library at all. Keep the fourth citation correct.

Then ask:

```
Use the citation-checker agent on notes/check_me.md. Don't change check_me.md.
```

You want three flags (WRONG DETAILS, CLAIM NOT SUPPORTED, NOT FOUND) and one OK. If it misses one, read the agent file `.claude/agents/citation-checker.md` and add a specific thing to check, then run it again. The checker compares against the summaries, not the PDFs, so it can't catch a number that's wrong in the summary itself. That's why step 3 matters.

## If you finish early

- Make the tags consistent. Ask: "List every tag used in literature/ and how many summaries use each. Don't change anything." You'll usually find the same idea under two spellings, like `pretrial-detention` and `pretrial detention`. Pick a fixed list, put it in step 5 of the ingest skill, and have Claude update the existing summaries to use it.
- Write a summary checker. Make `.claude/agents/summary-checker.md` with `tools: Read, Grep, Glob, Write`, whose one job is to take a summary, find every number and claim in the PDF in `papers/`, and write `notes/summarycheck_<file>.md` with the page and quote for each one, or NOT FOUND. Tell it not to edit the summary. Run it on all the summaries and fix the ones it flags yourself, or have the main session fix them.
- Build a full RAG (retrieval-augmented generation) search over your summaries: it finds passages by meaning, not by matching words, and runs on your laptop. My slides on how I built mine are in [`rag_slides.pdf`](rag_slides.pdf) in this folder. You need Ollama and the `nomic-embed-text` model (about 274 MB) plus the Python packages `duckdb`, `ollama`, and `python-frontmatter`.
- Ingest the papers on your "To find" list. If a PDF is behind a login, download it in your browser and ingest it from your Downloads folder: `/ingest-paper [filename].pdf` looks there when you give only a file name.

## Finished when

- Every PDF in `papers_to_add/` has a summary in `literature/`, and you've checked the header and every Key Findings number in at least two of them against the PDF.
- `notes/lit_<date>.md` exists for a question you wrote your own answer to in `notes/expected.md`, and you know which expected papers it found and which it missed.
- The citation checker flagged all three mistakes you planted in `notes/check_me.md`, or you changed the agent file until it did.
