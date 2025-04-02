#!/bin/bash

# -------------------------------
# CONFIGURATION
# -------------------------------

START_DATE="2025-04-01"
END_DATE="2025-08-28"

# Medium distribution: 2–7 commits/day
MIN_COMMITS=2
MAX_COMMITS=7

# Target folders from your project
TARGET_FOLDERS=(
  "lib/config"
  "lib/src/components/auth"
  "lib/src/components/dashboard"
  "lib/src/components/biometrics"
  "lib/src/models"
  "lib/src/screens"
  "lib/src/services"
  "lib/src/utils"
  "lib/assets/images"
  "lib/assets/icons"
  "lib/assets/fonts"
)

# -------------------------------
# FUNCTION TO APPLY SAFE EDITS
# -------------------------------

apply_random_edit() {
  folder=${TARGET_FOLDERS[$RANDOM % ${#TARGET_FOLDERS[@]}]}

  # Find a random file inside folder
  file=$(find "$folder" -type f 2>/dev/null | shuf -n 1)

  # If no file found, skip
  if [ -z "$file" ]; then
    return
  fi

  # Random harmless change
  rand=$((RANDOM % 3))
  case $rand in
    0)
      echo " " >> "$file" # add trailing space
      ;;
    1)
      echo "// auto-adjust" >> "$file" # add harmless comment
      ;;
    2)
      sed -i '' '$ s/$/ /' "$file" 2>/dev/null || sed -i '$ s/$/ /' "$file"
      ;;
  esac
}

# -------------------------------
# MAIN LOOP
# -------------------------------

CURRENT="$START_DATE"

while [ "$(date -d "$CURRENT" +%Y%m%d)" -le "$(date -d "$END_DATE" +%Y%m%d)" ]
do
  # Random commits for this day
  NUM_COMMITS=$((RANDOM % (MAX_COMMITS - MIN_COMMITS + 1) + MIN_COMMITS))

  echo "[$CURRENT] -> Creating $NUM_COMMITS commits..."

  for i in $(seq 1 $NUM_COMMITS)
  do
    # Apply random safe edit
    apply_random_edit

    # Random hour/min/sec for natural GitHub look
    HOUR=$((RANDOM % 12 + 8))       # between 8:00–20:00
    MIN=$((RANDOM % 60))
    SEC=$((RANDOM % 60))

    COMMIT_TIME="$CURRENT $HOUR:$MIN:$SEC"

    git add .

    GIT_AUTHOR_DATE="$COMMIT_TIME" \
    GIT_COMMITTER_DATE="$COMMIT_TIME" \
    git commit -m "Random activity on $CURRENT at $HOUR:$MIN:$SEC"
  done

  # Next day
  CURRENT=$(date -I -d "$CURRENT + 1 day")
done

echo "----------------------------------------"
echo "DONE! All backdated commits created."
echo "Now run: git push origin main"
echo "----------------------------------------"
