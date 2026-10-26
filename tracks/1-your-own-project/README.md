# Track 1: Your own project

Set up one of your projects so Claude Code can work in it, then use plan mode on one real task.

## Steps

1. Copy the kit into your project folder: `CLAUDE.md` and the `.claude/` folder.
2. Arrange your files into these folders: `data/raw/`, `data/clean/`, `code/`, `output/`, `literature/`, `notes/`.
3. Start `claude` from your project folder.
4. Edit `CLAUDE.md`: your research question, your data files, and the rules you want Claude to follow. Ask Claude to help: `Read my project and suggest edits to CLAUDE.md. Don't change anything yet.`
5. Pick one real task (for example, cleaning one data file). Press Shift+Tab until the prompt says plan mode, and describe the task.
6. Check the plan: which files it reads and changes, the filters and merges, the row counts it expects, and how you'll know it worked. Tell it what to change, then approve.

## Finished when

- `CLAUDE.md` describes your project.
- One task is done from a plan you checked.
