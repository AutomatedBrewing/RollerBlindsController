# Embedded build system
Sample implementation

## Setup

Before building, install all required dependencies:

```bash
./setup_repo.sh
```

For detailed information about dependencies, see [DEPENDENCIES.md](DEPENDENCIES.md).

## Building
To build specific target:
`./build.sh -c blink_F072`

## Formatting & Linting

The project uses `clang-format` and `clang-tidy` for code quality.

You can:
1. Format whole codebase: `./format_all.sh`
2. Run linting: `./lint_all.sh`
3. Check formatting on commit: `git-clang-format --diff --style=file HEAD`
