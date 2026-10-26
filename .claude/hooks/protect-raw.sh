#!/bin/bash
# Block changes to anything under data/raw/.
# Edit and Write: check the file path.
# Bash: block commands that write to data/raw/ (sed -i, >, tee, mv, rm, cp, chmod, ...).
# A script that opens a raw file for writing is not caught here; make data/raw read-only for that.
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name')
if [[ "$TOOL" == "Bash" ]]; then
  CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
  if echo "$CMD" | grep -Eq '((sed|perl) -i[^|;&]*data/raw|>>? *[^ ]*data/raw|tee [^|;&]*data/raw|\b(mv|rm|chmod|touch|truncate|ln)\b[^|;&]*data/raw|\bcp\b[^|;&]* [^ |;&]*data/raw[^ |;&]* *($|[|;&]))'; then
    echo "Blocked: this command could change raw data in data/raw/. Write cleaned files to data/clean/ instead." >&2
    exit 2
  fi
  exit 0
fi
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
if [[ "$FILE_PATH" == *"/data/raw/"* ]]; then
  echo "Blocked: $FILE_PATH is raw data. Write cleaned files to data/clean/ instead." >&2
  exit 2
fi
exit 0
