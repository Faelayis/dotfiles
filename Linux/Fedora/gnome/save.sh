#!/bin/bash

START_DIR=$(pwd)

find . -type f -name "dump.sh" -print0 | xargs -0 -I {} bash -c '
  SCRIPT_PATH="{}"
  DIR=$(dirname "$SCRIPT_PATH")
  SCRIPT_NAME=$(basename "$SCRIPT_PATH")

  echo "[Processing]: $DIR"
  cd "$DIR" || { echo "[Error]: Could not change to $DIR. Skipping."; return 1; }
  source "./$SCRIPT_NAME"
  
  echo "[Finished]"
  echo ""
  
  cd "$START_DIR" || { echo "[Error]: Could not return to $START_DIR from $DIR. This might cause issues."; return 1; }
' _

echo "[Git]: Pushing changes to remote repository..."
git add --all
git commit -m "[Script] Update Data"
git push
echo "[Git]: Push complete."