# Shared workflows

<!-- toc -->

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

This reusable GitHub Actions workflow automatically generates or updates a Table of Contents (TOC) for a Markdown file using markdown-toc. It also post-processes the TOC to use - dashes for list items to comply with Markdown linting rules.

### Lint markdown

This reusable GitHub Actions workflow lints Markdown files using markdownlint-cli2 and a shared configuration.

## Workflows for other repositories

Location for workflow files: [repository workflows](./repository%20workflows/)

### Invoke Generate ToC

This workflow triggers a shared GitHub Action to automatically update the Table of Contents in the README.md file by invoking a shared reusable workflow from apaivinen/shared-workflows.

### Invoke Lint markdown

This workflow lints Markdown files by invoking a shared reusable workflow from apaivinen/shared-workflows.
