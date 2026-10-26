# Track 3: Literature library

Build a searchable library of the papers in your field.

## Before you start

- 10–20 PDFs of papers you know well.

## Steps

1. Set up your folder as in Track 1. Put the PDFs in one folder, for example `papers_to_add/`.
2. Ingest one paper: `/ingest-paper papers_to_add/[file].pdf`. Read the summary in `literature/` and check it against the paper. Fix the skill's instructions if the summary misses something you care about.
3. Ingest the rest: `/ingest-paper` on each PDF.
4. Search the library: `/lit-search [a question you know the answer to]`. Check that it finds the right papers and that the citation checker agrees.

## Finished when

- Every PDF has a summary in `literature/`.
- A search for a question you know finds the papers you expected.
