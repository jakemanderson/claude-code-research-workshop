# Track 5: Data from a messy source

Write a script that rebuilds a dataset from a PDF table, an API, or a web page, then check it against the source by hand.

A lot of my empirical work starts with collecting data from government websites and PDFs, and I used to lose weeks to technical PDFs, old government sites, and codebooks. Claude is good at this kind of code; a scraper now takes me an afternoon. The catch is that the script runs and gives you a nice-looking table whether or not it read the source right. In my immigration bond project, Claude converted 19 EOIR tables to Parquet and then wrote an inventory of every column, and it marked the codes it couldn't find documentation for as "not verified" instead of guessing. For the budget numbers, it pulled the yearly ICE detention money from the budget justifications, and we checked the $45 billion against the text of the law. Some papers were behind a login, so I downloaded those myself in Chrome. In this track you do the same thing on a smaller scale: get the data, save the original untouched, rebuild the table with a script, and check it against the source until you trust it.

## Before you start

- A laptop with Claude Code working, and Python 3 with pandas. Depending on the source you'll also need `requests` and one of `pdfplumber` (PDFs) or `beautifulsoup4` and `lxml` (web pages). Claude will ask to install them; say yes, or run `pip install requests pdfplumber beautifulsoup4 lxml` yourself first.
- Your own source, if you have one: the URL of the PDF, page, or API, and the table you want at the end (what one row is, and which columns).
- One number from the source that you can read with your own eyes, for example a total for one year. This is your check number. If you can't name one, pick a different source.
- If you want to use the Census API, get a key before the session at https://api.census.gov/data/key_signup.html (free, sent by email). When I tested on 10/26/2026, requests without a key were sent to a "Missing Key" page. IPUMS needs an account and an extract request that can take a while to process, so set that up in advance too, or pick one of the examples below.

If you don't bring your own, pick one of these three. I checked each URL and each check number on 10/26/2026.

| | A. PDF table | B. API, no key | C. Web page |
|---|---|---|---|
| Source | BJS, *Jail Inmates in 2023 – Statistical Tables* (NCJ 309965), Display 5 on page 17 | BLS Public Data API, version 1 (no key or sign-up) | NCES, *Digest of Education Statistics* 2024, Table 203.20: public school enrollment by state, fall 1990 to fall 2023 |
| URL | https://bjs.ojp.gov/document/ji23st.pdf | https://api.bls.gov/publicAPI/v1/timeseries/data/ | https://nces.ed.gov/programs/digest/d24/tables/dt24_203.20.asp |
| Target table | One row per year, 2013–2023; columns: total and the 7 race and ethnicity groups (counts only, no percent-change rows) | One row per California county per month, Jan 2019 – Dec 2021 (58 counties, 36 months); column: unemployment rate, not seasonally adjusted | One row per state per year (50 states and DC, 15 years: 765 rows); columns: state, year, enrollment, and whether the footnote marker is there |
| Check number | 2019 total: 734,500. 2020 Black: 192,700 | Los Angeles County, April 2020: 16.8 | United States, fall 2023: 49,516,361. California, fall 2023: 5,924,113 |
| Second check | The 7 groups add up to the total within 100 in every year (counts are rounded to 100) | 58 counties × 36 months = 2,088 rows | In every year, the 51 rows add up exactly to the United States row, and so do the 4 regions |
| Answer key | BJS's own CSVs: https://bjs.ojp.gov/document/ji23st.zip (file `ji23stt05.csv`) | BLS's own page for one series: https://data.bls.gov/timeseries/LAUCN060370000000003 | NCES's Excel version of the same table: https://nces.ed.gov/programs/digest/d24/tables/xls/tabn203.20.xlsx |

Notes on each:

- A connects to the kit's `CLAUDE.md`, which is about US jail populations; the 734,500 is the BJS 2019 number the kit's plan checks against. The table has a † after many numbers (a significance marker), headers that run over several lines, and percent-change rows under the years. The "Reference dates" section on page 11 says something the table note doesn't: in 2015 and 2016 the counts by race were taken on December 31 and scaled up to midyear.
- B needs a list of the 58 California county codes. BLS publishes it at https://download.bls.gov/pub/time.series/la/la.area (rows that start with `F` and `CN06`). That server refused requests from a plain script and from a browser-style header when I tried, and accepted them once the User-Agent header had a contact email in it, so tell Claude to put your email in that header. Version 1 of the API takes at most 25 series and 10 years per request and has a low daily limit, so this table needs 3 requests; don't let the script retry in a loop. The series ID for a county is `LAU` + the area code + `03` (for example `LAUCN060370000000003` is Los Angeles County).
- C is a plain HTML table with several traps. The rows mix the United States total, 4 regions, the states, two school systems run by federal agencies (Bureau of Indian Education and DoDEA, the Defense Department's schools), and 5 territories; the United States total includes only the 50 states and DC, so adding up every row in the state section counts some students twice and others who aren't in the total. From fall 2019 on, each number has a separate cell next to it for a footnote marker, so there are more cells in a row than year headers. One footnote is glued to a name ("DoDEA2"), missing values are `---`, `#` means a percent change that rounds to zero, and the fall 2023 United States number has no commas.

## Steps

### 1. Set up the folder (10 min)

Make a new folder for this track and copy the kit's `CLAUDE.md` and `.claude/` folder into it. Make the folders `data/raw/`, `data/clean/`, `code/`, `output/`, and `notes/`. Start `claude` from that folder.

Edit `CLAUDE.md` so it describes this project. Replace the question with one line about the table you're building, and replace the Data section with the source: its URL, today's date, and what one row of your target table is. Keep the Rules section. You can ask Claude to draft it:

```
I'm building a table from [source URL]. One row is [one year / one county-month / one state-year]. Read CLAUDE.md and suggest edits to the Question and Data sections for this project. Don't change anything yet.
```

The kit's `.claude/settings.json` and `.claude/hooks/protect-raw.sh` stop Claude from editing anything in `data/raw/` with its edit tools or with shell commands like `sed -i`, `>`, `mv`, or `cp`. They don't stop a Python script from writing there. That's what you want for downloads, but it also means a buggy script could overwrite a raw file, which is why step 3 asks for a script that never overwrites.

### 2. Look at the source yourself (10 min)

Before Claude touches it, open the source in your browser and spend a few minutes on it. This is where you decide what counts as right.

- Find your check number and write it down in `notes/checks.md` with where you found it (page and table, or URL and row). Add the second check from the table above, or one of your own.
- Read the footnotes and notes under the table. Copy anything that changes what a number means into `notes/checks.md`.
- Read the site's `robots.txt` (put `/robots.txt` after the domain, for example https://nces.ed.gov/robots.txt) and its terms of use or site policies. `robots.txt` lists the parts of a site the owner asks automated programs to stay out of. If the page you want is on that list, or the terms say no automated access, use a download file or an API instead, or ask the agency. For an API, read the limits on its documentation page.
- Check whether the agency already publishes the data as a CSV or an API. BJS does (that's the answer key for example A). If it does, scraping is still good practice here, but in your own work you'd use the CSV.

This step is principle 1 in practice: `notes/checks.md` is yours. Claude can read it but shouldn't write it.

### 3. Write the plan, then plan mode (25 min)

Write `notes/my_plan.md` yourself. It doesn't have to be long, but every heading should be there, because each one is a choice Claude would otherwise make on its own without telling you (principle 0). A starting point:

```
# Plan: rebuild [table] from [source]

## Goal
One table, data/clean/[name].csv, rebuilt from the source by scripts in code/.

## Source
URL: ...  (checked robots.txt and terms on [date]: ...)
Notes on the source I copied into notes/checks.md.

## Target table
One row = ...   Columns and types: ...
Expected number of rows: ...

## Steps
1. code/01_download.py: download the source to data/raw/ with today's date in the file name. If the file is already there, skip the download and say so. Never overwrite or edit a file in data/raw/. Wait at least 1 second between requests. Set the User-Agent header to "[your name] research script ([your email])".
2. code/02_parse.py: read only from data/raw/, write data/clean/[name].csv. Print the row count after each step and save the log to output/logs/.
3. Write the source's notes and footnotes (or the API documentation) to notes/source_notes.md, with the page or URL for each.

## Checks (all must pass, written to output/checks.txt)
- [your check number]
- [your second check]
- No duplicate rows on [the columns that should identify a row].

## Out of scope
No analysis, no charts. Don't open [the answer key file] until I say so.

## Stop and ask me if
A check fails, the source doesn't look like what's described here, or the script needs to change anything in data/raw/.
```

Then press Shift+Tab until the prompt says plan mode and type:

```
Read notes/my_plan.md and notes/checks.md, and look at the source. Write a plan for the two scripts. For every column, say exactly where in the source it comes from. List anything in the source that doesn't match my plan.
```

Check Claude's plan for these things before you approve it:

- It downloads once and parses from the saved copy. A script that downloads and parses in one go has to hit the website every time you fix a parsing bug, and you lose the copy you parsed.
- It never writes to an existing file in `data/raw/`.
- It says where each column comes from (for a PDF: the page and the column header; for an API: the field name; for a web page: the table and column).
- It says how it handles the messy parts you saw in step 2: footnote markers, commas in numbers, two date formats, percent-change rows, preliminary values.
- It prints row counts and runs your checks.

If any of that is missing, tell it what to change and ask for a new plan. Then approve.

### 4. Let it run (15 min)

Watch what it does. Things that usually go wrong:

- The download fails with a 403 or a page that isn't the data. Agencies block scripts. Don't let Claude try one header after another until something gets through; that's working against the site's rules. Check `robots.txt` and the terms, set a User-Agent with your email, and if it still fails, download the file by hand in your browser and put it in `data/raw/` yourself. That's what I did with papers behind a login.
- Claude tries to write the download straight into `data/raw/` with its own tools and the hook blocks it. That's the hook working. Tell it to put the download in `code/01_download.py`.
- The PDF parser reads two columns as one, or shifts a row by one column. The numbers still look like numbers, so this only shows up in the checks. Make it print the parsed rows for one page next to the text it read.
- It "fixes" a check that fails by changing the check, or by dropping the rows that don't fit. `CLAUDE.md` says to report a failed check first; hold it to that. A failed check means you look at the source again.
- For example B: the script retries in a loop and uses up the daily limit. Stop it (Esc) and tell it to make at most 3 requests.

When it finishes, make the raw files read-only yourself, in a separate terminal window (the hook blocks Claude from running this): `chmod a-w data/raw/*`

### 5. Profile the result (10 min)

```
Use the data-profiler agent on data/clean/[name].csv. The source notes are in notes/source_notes.md; treat them as the codebook.
```

The profiler only describes the data and writes `notes/data_report_[name].md`; it can't change anything (principles 3 and 4). Read the report and look for:

- whether the columns that should identify a row actually do (no duplicates)
- missing values: where they are, and whether the source had a value there
- anything that would make a simple sum wrong; for example A, totals and subgroups in the same table; for example C, the United States and region rows, or the federal school systems that aren't in the total
- notes about how values were built, such as the 2015–2016 scaling in example A or "preliminary" flags in example B

### 6. Check it by hand (15 min)

Do this step yourself, not with Claude.

1. Open `data/clean/[name].csv` and the source side by side. Check your check number.
2. Pick 3 rows: the first, the last, and one from the middle that looked odd in step 2 or in the profile. Check every column of those rows against the source.
3. Look at `output/checks.txt`. Every check should say pass or fail with the numbers it compared.
4. Now compare against the answer key (the BJS CSV, the BLS series page, or the NCES Excel file). For example A, ask: `Compare data/clean/[name].csv with the table in ji23stt05.csv cell by cell. List every cell that differs. Don't change either file.`

If something doesn't match, find out which side is wrong before changing anything. Sometimes it's the source: agency pages have errors too, and a total row on a web page isn't always updated when the rows above it are. If it's the source, write that down; don't make your table match it.

### 7. Write down your decisions and rebuild (5 min)

Add a `notes/decisions.md` with each choice you made (principle 5): what you chose, what you didn't, and why. For example: "Dropped the † markers; they mark significance, not a different value." "Kept 2015–2016 race counts as BJS published them (year-end counts scaled to midyear); flag them in any figure." Point to the file from `CLAUDE.md` so the next session reads it.

Then rebuild from scratch to show the table comes from the scripts alone: delete `data/clean/[name].csv` yourself in your terminal (the kit blocks Claude from running `rm`), run `python code/02_parse.py`, and check that you get the same file and the checks still pass.

## If you finish early

- Have the replicator agent rebuild the table from your plan without seeing your scripts: first save your check numbers to `output/checks.json`, then type `Use the replicator agent with notes/my_plan.md`. It writes its own script in `replication/` and reports whether its numbers match yours within 0.5%. This is a second, independent parse of the same raw file, so a mismatch points to a parsing choice.
- Add a second source and merge it. For A, add Display 1 on page 13 (total, average daily population, admissions). For B, extend the years to 2024–2026 and see what the API returns for October 2025 (it was not collected because of the federal shutdown). For C, add the same table from the 2023 edition (https://nces.ed.gov/programs/digest/d23/tables/dt23_203.20.asp), which has projections in place of fall 2023, and check that the years the two editions share have the same numbers.

## Finished when

- `code/01_download.py` and `code/02_parse.py` rebuild `data/clean/[name].csv` from the files in `data/raw/`, and running `02_parse.py` again gives the same file.
- Your check number, your second check, and the 3 rows you picked match the source, and `output/checks.txt` says so.
- `notes/decisions.md` lists each choice you made about the source, including anything in the source you think is wrong.
