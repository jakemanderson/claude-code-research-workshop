#!/bin/bash
# Checker agents may write their reports, but not change the code, data, or output.
# referee, citation-checker, number-checker, data-profiler: only notes/.
# replicator: only replication/.
# The main session and other agents are not affected.
INPUT=$(cat)
AGENT=$(echo "$INPUT" | jq -r '.agent_type // empty')
AGENT=${AGENT##*:}   # plugin agents are named research-checks:referee
case "$AGENT" in
  referee|citation-checker|number-checker|data-profiler) ALLOWED="notes" ;;
  replicator) ALLOWED="replication" ;;
  *) exit 0 ;;
esac
ROOT=${CLAUDE_PROJECT_DIR:-$(echo "$INPUT" | jq -r '.cwd')}
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
[[ "$FILE_PATH" != /* ]] && FILE_PATH="$ROOT/$FILE_PATH"
if [[ "$FILE_PATH" == "$ROOT/$ALLOWED/"* && "$FILE_PATH" != *"/../"* ]]; then
  exit 0
fi
echo "Blocked: the $AGENT agent can only write to $ALLOWED/. Report the problem; don't fix it." >&2
exit 2
