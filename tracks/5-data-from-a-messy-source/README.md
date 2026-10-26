# Track 5: Data from a messy source

Write a script that rebuilds a dataset from a website, a PDF table, or an API (for example Census, IPUMS, or BLS).

## Before you start

- The source: a URL, a PDF, or the name of an API.
- The table you want at the end: one row is what, and which columns.

## Steps

1. Set up your folder as in Track 1.
2. In plan mode, describe the source and the table you want. Ask for a plan that saves the downloaded files to `data/raw/` and writes the script to `code/`.
3. Check the plan, approve, and let it run.
4. Run the data profiler on the result: `Use the data-profiler agent on data/clean/[file]`.
5. Check 3 rows by hand against the source.

## Finished when

- One script in `code/` rebuilds the table from the source.
- The 3 rows you checked match the source.
