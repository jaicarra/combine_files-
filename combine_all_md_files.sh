#!/bin/bash

# Define the output file name
OUTPUT_FILE="combined_all_content.md"

# IMPORTANT: Remove the output file if it already exists to prevent content duplication
echo "Removing existing ${OUTPUT_FILE} to prevent duplication..."
rm -f "${OUTPUT_FILE}"

# Create an empty file to start with
touch "${OUTPUT_FILE}"

echo "Starting recursive consolidation of all .md files from current directory and subdirectories..."

# Use 'find' to get all .md files recursively and safely handle filenames with spaces.
# It then pipes each found file to the 'while' loop.
# -type f: ensures we only process files, not directories.
# -name "*.md": filters for files ending with .md.
# -print0: prints filenames separated by a null character, which is safe for spaces/special characters.
# while IFS= read -r -d $'\0' f; do ...: reads each null-separated filename into variable 'f'.
find . -type f -name "*.md" -print0 | while IFS= read -r -d $'\0' f; do
  # Skip the output file itself if it happens to be found by find (e.g., if it's in the root of the search)
  if [[ "$f" == "./${OUTPUT_FILE}" ]]; then
    continue
  fi

  echo "--- Appending content from: $f ---" # Added clearer header for each file
  # Append the content of the current markdown file to the output file
  cat "$f" >> "${OUTPUT_FILE}"

  # Add 7 blank lines after each file's content for separation
  for i in $(seq 1 7); do
    echo >> "${OUTPUT_FILE}"
  done
done

echo "Consolidation complete! All content is in ${OUTPUT_FILE}"
echo "Please upload this new file to me, and we'll proceed with building the book."
