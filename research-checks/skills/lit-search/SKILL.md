---
name: lit-search
description: Find papers in literature/ related to a research question, and check each one. Use before claiming an idea is new.
---

# Literature search

Input: $ARGUMENTS (the research question)

1. Search `literature/` (titles, tags, and research-question sections) for related papers.
2. Cite only papers that have their own summary file. A paper mentioned inside another summary does not count; list it under "To find" instead.
3. Copy authors, year, and title exactly from each file's header.
4. Write `notes/lit_<date>.md` with:
   - a table: paper, file, what it does, how it relates to the question
   - "To find": papers mentioned in summaries that are not in the library yet (add them with `/ingest-paper`)
   - what would be new, in 2 or 3 sentences, and how sure you are, given that the library may be missing papers
5. Use the `citation-checker` agent on the file. Fix or remove anything it flags.
