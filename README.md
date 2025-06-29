# Shared workflows

<!-- toc -->

- [About Repository](#about-repository)
- [Workflows](#workflows)
  - [Generate ToC](#generate-toc)
  - [Lint markdown](#lint-markdown)
- [Workflows for other repositories](#workflows-for-other-repositories)
  - [Invoke Generate ToC](#invoke-generate-toc)
  - [Invoke Lint markdown](#invoke-lint-markdown)

<!-- tocstop -->

## About Repository

This repository is a central place for my github actions for my  other repositories

## Workflows

This repository contains two types of workflows.

1. Shared workflows
1. Invoker workflows

Shared workflows are designed to be in this centralized repository.

Invoker workflows uses shared workflows from their own repositories.

### Generate ToC

This reusable workflow (`generate-toc.yml`) automates the generation and normalization of a Markdown Table of Contents (TOC) and is designed to be invoked from other repositories using `workflow_call`. It accepts an optional `target_file` input (defaulting to `README.md`), installs `markdown-toc`, inserts or updates the TOC between `<!-- toc -->` and `<!-- tocstop -->` markers, and uses `awk` to normalize list bullets to dashes for Markdown linting compliance. If changes are detected, it commits and pushes the updated file back to the repository, streamlining TOC maintenance across projects.

### Lint markdown

This reusable workflow (`lint-markdown.yml`) is designed to be invoked via `workflow_call` from other repositories to perform Markdown linting using `markdownlint-cli2`. It accepts an optional `markdown_globs` input to define which Markdown files to lint (defaulting to `**/*.md`), and optionally supports a `GH_TOKEN` secret if needed. The workflow checks out the calling repository, fetches a shared `.markdownlint.yaml` configuration from the `apaivinen/shared-workflows` repository using sparse checkout, and runs linting using the specified config and file patterns, promoting consistent Markdown standards across projects.

### Lint yaml

This reusable GitHub Actions workflow (`lint-yaml.ym`l) enables centralized YAML linting across repositories using a shell script and customizable inputs. Designed to be invoked via `workflow_call`, it accepts `yaml_files` and exclude_paths parameters to control which files are checked and which are excluded. It runs `yamllint` with strict mode using a script located at `.scripts/lint-yaml.sh`

## Scripts

### lint-yaml.sh

This `lint-yaml.sh` script performs YAML validation using `yamllint` in strict mode, supporting configurable file targets via the `YAML_FILES` environment variable and optional exclusions via `EXCLUDE_PATHS`. It parses the input as either a directory or a space-separated list of paths, skips any that match the exclusion regex, and runs linting on the rest using a specified config file (`.yamllint.yaml`). The script prints results per path, tracks failures, and exits with an appropriate status code to indicate overall success or failure

## Workflows for other repositories

Location for workflow files: [repository workflows](./repository%20workflows/)

### Invoke Generate ToC

This workflow (`invoke-generate-toc.yml`) in the consumer repository is designed to automatically update the Table of Contents in the `README.md` file by invoking a reusable workflow from `apaivinen/shared-workflows`. It triggers on pushes to the `main` branch that modify the `README.md`, or can be run manually via `workflow_dispatch`. The workflow passes `README.md` as the target file and requires `contents: write` permissions to commit any TOC updates back to the repository.

### Invoke Lint markdown

This workflow (`invoke-lint-markdown.yml`) in the consumer repository triggers on pull requests that modify Markdown files or via manual dispatch, and delegates the linting task to a reusable workflow defined in `apaivinen/shared-workflows`. It passes a `markdown_globs` input (`**/*.md`) to specify which files to lint, ensuring consistent Markdown formatting by leveraging the shared `markdownlint` configuration and centralized logic from the shared workflow.

### Invoke Lint yaml

This workflow (`invoke-lint-yaml.yml`) is a consumer-side GitHub Actions workflow that triggers on pull requests affecting `.yml` or `.yaml` files in the `.github/workflows` directory or via manual dispatch. It delegates YAML linting to a reusable workflow from the apaivinen/shared-workflows repository, passing configurable inputs to define the target folder (`.github/workflows`) and optional exclusion patterns.
