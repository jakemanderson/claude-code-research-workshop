# Project: jail populations after 2020

Question: How much did US jail populations fall in 2020, and which counties went back to pre-2020 levels?

## Folders
- `data/raw/`: original files. Never edit, move, or overwrite anything here.
- `data/clean/`: cleaned data, written only by scripts in `code/`.
- `code/`: numbered scripts, run in order (`01_ingest.py`, `02_clean.py`, ...).
- `output/`: tables, figures, logs. Every number in the paper comes from a file here.
- `literature/`: one summary per paper (see `/ingest-paper`).
- `notes/`: idea, plans, referee reports, decisions.

## Data
- Vera Incarceration Trends, county file: `data/raw/vera_county.csv.gz`. Codebook: `data/raw/codebook.pdf`.
- One row is county x year x quarter. Use quarter 2 (June 30) unless the plan says otherwise.
- Some counties repeat a shared jail's total (regional jails; state-run systems in AK, CT, DE, HI, RI, VT). Count each jail once.

## Rules
- Use plan mode for anything that changes more than one file.
- Read the codebook before using a column.
- Print the row count after every filter or merge, and save the log to `output/logs/`.
- Never report a number you did not compute from a file in this project.
- Cite only papers that have a summary in `literature/`.
- If a check fails, say so first in your answer. If the fix is clear, fix it and report the number before and after. If the fix is not clear, stop and ask.
- Python 3.12, pandas. Set random seeds.
