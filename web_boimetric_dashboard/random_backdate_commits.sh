#!/bin/bash

START_DATE="2025-04-01"
END_DATE="2025-08-28"

MIN_COMMITS=2
MAX_COMMITS=7

TARGET_FOLDERS=(
  "lib/config"
  "lib/src/components/auth"
  "lib/src/components/dashboard"
  "lib/src/components/biometrics"
  "lib/src/models"
  "lib/src/screens"
  "lib/src/services"
  "lib/src/utils"
  "assets/images"
  "assets/icons"
  "assets/fonts"
)

apply_random_edit() {
  folder=${TARGET_FOLDERS[$RANDOM % ${#TARGET_FOLDERS[@]}]}

  file=$(find "$folder" -type f 2>/dev/null | shuf -n 1)

  if [ -z "$file" ]; then
    return
  fi

  echo "// $(date +%s)" >> "$file"
}

CURRENT="$START_DATE"

while [ "$(date -d "$CURRENT" +%Y%m%d)" -le "$(date -d "$END_DATE" +%Y%m%d)" ]
do
  NUM_COMMITS=$((RANDOM % (MAX_COMMITS - MIN_COMMITS + 1) + MIN_COMMITS))

  echo "[$CURRENT] -> $NUM_COMMITS commits"

  for ((i=1;i<=NUM_COMMITS;i++)); do
    apply_random_edit

    HOUR=$((RANDOM % 10 + 9))
    MIN=$((RANDOM % 60))
    SEC=$((RANDOM % 60))

    COMMIT_TIME="$CURRENT $HOUR:$MIN:$SEC"

    git add .

    GIT_AUTHOR_DATE="$COMMIT_TIME" \
    GIT_COMMITTER_DATE="$COMMIT_TIME" \
    git commit -m "Activity on $CURRENT"
  done

  CURRENT=$(date -I -d "$CURRENT + 1 day")
done

echo "DONE — Now push with:"
echo "git push origin main --force"
