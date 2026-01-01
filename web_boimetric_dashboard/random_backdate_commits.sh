#!/bin/bash

# Set the date range for backdated commits
START_DATE="2026-01-01"
END_DATE="2026-05-31"

# Number of commits per day
MIN_COMMITS=2
MAX_COMMITS=6

# Target directories that exist in the project
TARGET_FOLDERS=(
  "lib"
  "lib/src"
  "lib/src/controllers"
  "lib/src/models"
  "lib/src/services"
  "lib/src/widgets"
  "assets"
  "test"
)

apply_random_edit() {
  # Select a random folder from the target folders
  local folder=${TARGET_FOLDERS[$RANDOM % ${#TARGET_FOLDERS[@]}]}
  
  # Find all files in the selected folder (excluding build directories and other non-source files)
  local file=$(find "$folder" -type f -not -path '*/.*' -not -path '*/build/*' -not -name '*.g.dart' -not -name '*.freezed.dart' 2>/dev/null | shuf -n 1)

  # If no file was found, try another folder
  if [ -z "$file" ]; then
    return 1
  fi

  # Create a simple edit (append a comment with timestamp)
  echo "// Auto-generated comment for commit - $(date +%s)" >> "$file"
  
  # Also modify the modification time of the file to match the commit time
  touch -d "$CURRENT" "$file"
  
  return 0
}

CURRENT="$START_DATE"

# Set git config to ensure commits are properly attributed
git config --local user.name "$(git config user.name)"
git config --local user.email "$(git config user.email)"

echo "Starting to create backdated commits from $START_DATE to $END_DATE"
echo "This might take a while..."

while [ "$(date -d "$CURRENT" +%Y%m%d)" -le "$(date -d "$END_DATE" +%Y%m%d)" ]
do
  # Skip weekends (optional)
  if [ "$(date -d "$CURRENT" +%u)" -gt 5 ]; then
    echo "Skipping weekend: $CURRENT"
    CURRENT=$(date -I -d "$CURRENT + 1 day")
    continue
  fi

  # Random number of commits for this day
  NUM_COMMITS=$((RANDOM % (MAX_COMMITS - MIN_COMMITS + 1) + MIN_COMMITS))
  
  echo "\n[$CURRENT] Creating $NUM_COMMITS commits"

  for ((i=1; i<=NUM_COMMITS; i++)); do
    # Try to apply a random edit until successful
    while ! apply_random_edit; do
      echo "Retrying to find a suitable file to modify..."
      sleep 0.5
    done

    # Generate random time during working hours (9 AM to 6 PM)
    HOUR=$((RANDOM % 8 + 9))  # 9-16 (4 PM)
    MIN=$((RANDOM % 60))
    SEC=$((RANDOM % 60))

    COMMIT_TIME="$CURRENT $HOUR:$MIN:$SEC"
    
    # Add all changes
    git add . > /dev/null 2>&1
    
    # Create the commit with the specified date
    if GIT_AUTHOR_DATE="$COMMIT_TIME" \
       GIT_COMMITTER_DATE="$COMMIT_TIME" \
       git commit -m "Update: Random activity on $CURRENT" --quiet; then
      echo -n "✅"  # Success indicator
    else
      echo -n "❌"  # Error indicator
    fi
  done

  # Move to the next day
  CURRENT=$(date -I -d "$CURRENT + 1 day")
done

echo "\n\n✅ All done! To push these changes to GitHub, run:"
echo "git push origin main --force"
echo "\nNote: This will overwrite the remote history. Make sure this is what you want to do!"
echo "After pushing, it may take some time for GitHub to update your contributions graph."
