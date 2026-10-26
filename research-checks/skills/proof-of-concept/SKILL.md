---
name: proof-of-concept
description: Run a quick proof of concept for a research idea: profile the data, write a plan, get it refereed, compute one key number, and replicate it independently. Use when the user wants to know whether an idea is worth a full project.
---

# Proof of concept

Goal: decide whether to continue. The result can be rough, except the one number the decision depends on.

Input: $ARGUMENTS (the question, and the data file to use)

Run these steps in order. Do not skip a step. Do not do a checker's job yourself.

1. **Profile.** Use the `data-profiler` agent on the data file. Wait for `notes/data_report_*.md`.
2. **Plan.** Write `notes/poc_plan.md`: the one number to compute, the exact rows and filters, what one unit is, how to avoid counting a unit twice, which units to compare across years, and the checks the result must pass. Base it on the data report and the codebook.
3. **Referee the plan.** Use the `referee` agent on `notes/poc_plan.md`. If it lists problems, revise the plan and send it back. At most 2 revisions. If the referee still objects, stop and show the user the objections.
4. **Compute.** Write `code/poc.py` following the plan exactly. Print the row count after each step to `output/logs/poc_log.txt`. Save the number to `output/poc_numbers.json`.
5. **Replicate.** Use the `replicator` agent with `notes/poc_plan.md`. If its numbers differ by more than 0.5%, find out why before going on. At most 2 rounds.
6. **Report** to the user, in this order:
   - the number, and whether the replication matched
   - what is still rough (a list)
   - the referee's open objections
   - your recommendation: continue, change the question, or stop
