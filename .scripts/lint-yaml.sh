#!/usr/bin/env bash
set -e

if ! command -v yamllint >/dev/null 2>&1; then
  echo 'This check needs yamllint from https://github.com/adrienverge/yamllint'
  exit 1
fi

echo "YAML_FILES value: ${YAML_FILES}"

if [ -z "${YAML_FILES}" ]; then
  YAML_FILES="./.github"
  echo "Using default YAML_FILES: ${YAML_FILES}"
fi

# Check for exclusion pattern
if [ -n "${EXCLUDE_PATHS}" ]; then
  echo "Will exclude paths matching: ${EXCLUDE_PATHS}"
fi

echo "Parsing file list..."

declare -a files_array

if [ -d "$YAML_FILES" ]; then
  echo "YAML_FILES is a directory, using it directly"
  files_array=("$YAML_FILES")
else
  # Otherwise try the eval approach
  # Temporarily disable exit on error for the eval
  set +e
  eval "files_array=($YAML_FILES)" 2>/tmp/eval_error
  eval_status=$?
  set -e
  
  if [ $eval_status -ne 0 ]; then
    echo "Error during eval:"
    cat /tmp/eval_error
    exit 1
  fi
fi

echo "Found ${#files_array[@]} files/directories to check"

# Track if any files failed validation
any_failures=0

# Process files
files_to_lint=()
for path in "${files_array[@]}"; do
  if [ -n "$path" ]; then
    # Skip if path matches exclusion pattern
    if [ -n "${EXCLUDE_PATHS}" ] && [[ $path =~ $EXCLUDE_PATHS ]]; then
      echo "⏭️  Skipping excluded path: ${path}"
      continue
    fi

    set +e
    output=$(yamllint --strict -c ./.yamllint.yaml "${path}" 2>&1)
    status=$?
    set -e
    echo "yamllint exit status: $status"
    if [ $status -eq 0 ]; then
      echo "✅ ${path}"
    else
      echo "❌ ${path} :"
      # Display the captured output
      echo "$output"
      any_failures=1
    fi
    files_to_lint+=("$path")
  fi
done

if [ ${#files_to_lint[@]} -eq 0 ]; then
  echo "No YAML files to lint."
  exit 0
fi

# Final summary
if [ $any_failures -eq 0 ]; then
  echo -e "\n✅ All YAML files passed validation"
  exit 0
else
  echo -e "\n❌ YAML files failed validation"
  exit 1
fi