---
name: ingest-paper
description: Ingest a paper PDF: copy it to papers/, read it, and write a structured summary to literature/.
user-invocable: true
allowed-tools: Read, Write, Bash, Glob, Grep, Agent
---

# Ingest Paper

You are ingesting an academic paper into this project's literature folder.

**Input:** $ARGUMENTS (path to a PDF file, or a filename in ~/Downloads/)

**Steps:**

1. **Locate the PDF.** If the argument is just a filename, look in ~/Downloads/. If it's a full path, use that. Read the first 5 pages to extract metadata.

2. **Name the file.** Use the format: `authorlast_year_short_description.pdf` (e.g., `silveira_2017_bargaining_asymmetric_information_plea.pdf`). All lowercase, underscores, no special characters.

3. **Copy to papers/.** Copy (not move) the PDF to `papers/[named_file].pdf`. Leave the original in place.

4. **Read the paper.** Read enough pages to understand: title, authors, year, journal, abstract, research question, methods, key findings, and limitations. For long papers, focus on abstract, introduction, results, and conclusion sections.

5. **Generate the summary.** Write a structured markdown summary to `literature/[same_name_without_pdf].md` using this exact frontmatter format:

```yaml
---
title: "Full Paper Title"
authors: ["Author One", "Author Two"]
year: YYYY
journal: "Journal Name"
status: published  # or working_paper
tags: [tag1, tag2, tag3]
location: "Country/State"
doi: "10.xxxx/xxxxx"
source_file: "filename.pdf"
---
```

Then include these sections:
- **Research Question** — What problem does it address?
- **Contribution** — What's new relative to prior work?
- **Econometric Strategy** — Methods used
- **Identification** — Source of exogenous variation
- **Data & Sample Construction** — Sources, sample size, construction
- **Key Findings** — Main results with numbers
- **Limitations** — Acknowledged gaps
- **References to Related Work** — Key papers cited

6. **Report back.** Tell the user the file location, the summary location, and in 2 sentences how the paper relates to the question in CLAUDE.md.
