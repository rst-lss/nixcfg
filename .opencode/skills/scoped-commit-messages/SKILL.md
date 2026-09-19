---
name: scoped-commit-messages
description: Use when the user asks for a git commit message, wants commits proposed from staged or working-tree changes, or asks to commit changes. Generates Scoped Commits-style messages using the repository's actual history to determine appropriate scopes. Do not use Conventional Commits unless explicitly requested.
---

# Scoped Commit Messages

Generate commit messages using the **Scoped Commits** convention:

```text
<scope>: <description>

[optional body]

[optional trailer]
```

Reference:
[https://scopedcommits.com/](https://scopedcommits.com/)

Do **not** use Conventional Commits.

Never introduce Conventional Commit types such as:

```text
feat:
fix:
chore:
docs:
refactor:
perf:
test:
build:
ci:
style:
```

unless the user explicitly requests Conventional Commits.

## Commit message format

### Scope

The scope identifies the subsystem, module, component, or conceptual area
affected by the change.

Use:

```text
scope: description
```

The scope should be:

- lowercase
- short
- without spaces
- hyphenated when necessary
- meaningful to someone reading the repository history

Scopes are **not a predefined enum**.

Do not create an artificial taxonomy merely to satisfy this convention.

### Description

Write a concise description of the change.

Prefer imperative wording:

```text
add support for ...
remove ...
update ...
move ...
introduce ...
```

Avoid:

```text
added ...
adds ...
fixing ...
updated ...
```

Do not add a trailing period.

Keep the complete summary line concise, ideally around 72 characters,
but prioritize clarity over an arbitrary character limit.

### Body

Add a body only when the summary does not adequately explain the change.

The body should primarily explain:

- why the change was necessary
- important design decisions
- relevant trade-offs
- behavior that is not obvious from the summary

Do not restate the diff.

Small or obvious changes should normally have no body.

### Task-Id trailer

If the user provides a task/ticket ID, include it as a Git trailer:

```text
Task-Id: <id>
```

Example:

```text
nix: establish reproducible development environment

Task-Id: PJSF-123
```

Never invent a task ID.

If no task ID is available, omit the trailer entirely.

Do not put the task ID into the scope or summary merely to make it visible.

## Determining the scope

The scope should describe the **conceptual subject of the change**, not
merely the first filesystem path that happens to appear in the diff.

Before proposing a scope:

1. Inspect the relevant Git diff.
2. Inspect recent commit history.
3. Look for scopes already used by the repository.
4. Reuse an existing scope when it accurately describes the change.
5. If no suitable scope exists, derive a new scope from the affected
   subsystem or concept.
6. If introducing a new scope, explicitly tell the user that it is new.

Useful commands include:

```bash
git status --short
git diff --cached
git diff
git log --oneline -20
```

When useful, inspect scope usage directly:

```bash
git log --format='%s' -50
```

Do not assume that a directory name is automatically the correct scope.

For example, a change involving:

```text
flake.nix
pyproject.toml
packages/
```

may conceptually be:

```text
packaging: migrate project development to Nix
```

rather than forcing the scope to be `nix`.

## Staged versus unstaged changes

When proposing a message for a commit, distinguish carefully between
staged and unstaged changes.

### If changes are staged

Use:

```bash
git diff --cached
```

as the primary source for the proposed commit message.

Do not accidentally describe unrelated unstaged changes.

### If nothing is staged

Inspect the working tree:

```bash
git diff
```

and make it clear that the proposal is based on unstaged changes.

### If both staged and unstaged changes exist

Treat the staged changes as the intended commit by default.

Do not combine the staged and unstaged diffs unless the user explicitly
asks you to consider the entire working tree.

## Assess commit cohesion

Before proposing a message, determine whether the changes represent one
coherent conceptual change.

If they do not:

- do not force an artificial scope or summary
- explain that the changes appear to contain multiple concerns
- suggest splitting them when appropriate

A single commit may legitimately touch multiple directories when those
changes form one coherent conceptual change.

## Output

When the user asks for a commit message, normally provide **2–3 options**.

Options should represent genuinely useful alternatives, such as:

- different reasonable scope granularity
- different emphasis in the description
- different levels of abstraction

Do not provide three cosmetically reworded versions.

Prefer a short output:

```text
1. nix: establish reproducible development environment

2. packaging: establish reproducible development environment

3. dev-env: add Nix-based development environment
```

Include a body only when the change genuinely requires additional
explanation.

If a task ID is available, include the trailer in each proposed option.

## Repository history takes precedence

The repository's actual history is the primary source for established
scope vocabulary.

Do not maintain a manually duplicated list of scopes in this skill.

As the repository evolves, its Git history should naturally become the
source of truth for commonly used scopes.

## Do not over-engineer commits

Commit messages are documentation for the repository's history.

Do not introduce:

- Conventional Commit types
- arbitrary scope enums
- mandatory bodies
- artificial categories
- unnecessary metadata
- invented task IDs
- `[wip]` markers as a pseudo-type

Prefer simple, informative commit messages.
