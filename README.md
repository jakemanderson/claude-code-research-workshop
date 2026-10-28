# Adversarial Agents: Using Claude Code for research

## Before the workshop

Do these before you come. Installing and logging in can take 15 minutes, and the room's wifi will be slow.

1. **A paid Claude plan** (Pro, Max, Team, or Enterprise). Claude Code doesn't work on the free plan.
2. **Install Claude Code.** On a Mac, open Terminal and run `curl -fsSL https://claude.ai/install.sh | bash`. On Windows, open PowerShell and run `irm https://claude.ai/install.ps1 | iex`. Then run `claude` once and log in.
3. **git.** On a Mac, run `git --version`. If it asks to install the developer tools, say yes. On Windows, install it from git-scm.com. Without git, use Code, then Download ZIP on this page and unzip it in the same place as step 4.
4. **Get this repo**, next to your project folders and not inside one:
   ```
   cd ~/Documents
   git clone https://github.com/jakemanderson/claude-code-research-workshop.git
   ```
5. **Python 3** for the tracks that use Python scripts. On a Mac the command is `python3`, not `python`. Install packages in a virtual environment inside your project folder, not system-wide:
   ```
   python3 -m venv .venv
   .venv/bin/pip install pandas
   ```
   If you work in R or Stata, tell Claude so in your CLAUDE.md.

## The next 90 minutes

Pick one track and work on it for the rest of the session. Each track has its instructions in `tracks/`. Anyone stuck can pair with someone in the same track. The tracks use your own files: your project, your papers, your draft, your course. If you didn't bring any, pick Data from a messy source (public data) or Your writing voice (your own email).

| Track | What you do | You leave with |
|---|---|---|
| Your own project | Set up folders and CLAUDE.md; plan mode on one real task | A project set up for Claude Code |
| Proof of concept | See if you can get from an idea to a proof of concept in 90 minutes | A first estimate, and whether to continue |
| Literature library | Ingest 10–20 of your PDFs; search the summaries | A searchable library of your papers |
| Agents and skills | Write a reviewer agent and run it on your draft; turn one task into a skill | One agent and one skill |
| Data from a messy source | Scrape a site, parse a PDF table, or pull from an API (Census, IPUMS, BLS) | A script that rebuilds the data |
| Teaching | Write a problem set, solutions, and a grading rubric for a course you teach | A problem set with solutions |
| Your writing voice | Measure your own emails and writing; turn the numbers into a style guide | A voice profile Claude can follow |

## Setup

Make a new folder for your track, or go into an existing project (Track 1). Copy in the `.claude/` folder, which has the agents, skills, and hooks, then start Claude from that folder:

```
mkdir ~/Documents/my_track && cd ~/Documents/my_track    # new folder
cp -R ~/Documents/claude-code-research-workshop/.claude .
claude
```

Write your own `CLAUDE.md` as your track's README describes. The `CLAUDE.md` in this repo is the example from the talk (a project on jail populations); read it, but don't copy it.

Start `claude` from the folder that has `.claude/` in it. If you start it from somewhere else, the agents, skills, and hooks won't load.
