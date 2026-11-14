# Shell Scripting Project Rules & Architecture

## 1. Syntax, Formatting & Code Style

- All `case` statement patterns MUST be explicitly and symmetrically enclosed with both left and right parentheses: `(pattern)` instead of `pattern)`.
  - Example: Use `(*)` instead of `*)`.
  - Example: Use `(key)` instead of `key)`.
  - Example: Use `(raw|*)` instead of `raw|*)`.
- **Block Formatting Rules:**
  - A `case` statement structure CANNOT be compressed into a single line. It must be cleanly structured across multiple lines.
  - *Exception:* Individual code paths inside a specific case match *can* be written on a single line if they are brief (e.g., `shift ;;`).
  - Strict indentation MUST be exactly **2 spaces** per level.
- **Variable Expansion Rule:**
  - All user-defined and standard variables MUST be accessed using explicit curly braces: `${variable_name}` instead of `$variable_name`.
  - *Exception:* This rule does not apply to special positional or shell systemic variables (e.g., `$1`, `$#`, `$@`, `$*`, `$?`). Additionally, variables referenced inside arithmetic evaluation contexts `((...))` or arithmetic expansions `$((...))` MAY omit the curly braces and the `$` prefix entirely (e.g., `i++` or `i < len`), as the shell automatically evaluates them as variables in these contexts.
    - Example (Allowed): `while (( i < len )); do`
    - Example (Allowed): `(( i++ ))`
    - Example (Disallowed): `while [[ $i -lt $len ]]; do` (Variables inside `[[ ... ]]` still strictly require `${variable_name}`).
- **Variable Pattern Trimming Rule:**
  - When performing variable substring deletion or trimming (`${var#pattern}` or `${var%pattern}`), if the right-hand side is a variable, it MUST be strictly wrapped in double quotes to prevent the shell from interpreting its content as a glob pattern (e.g., `*`, `?`, `[...]`).
  - Example: Use `stream="${stream#"${text}"}"` instead of `stream="${stream#${text}}"`.
- **Markdown Documentation Rules:**
  - There MUST always be a blank/empty line immediately following any Markdown heading element (`#`, `##`, `###`, etc.) to ensure readability and correct rendering.

## 2. CLI Argument Parsing Design

- Configuration flags (e.g., `-d=*`, `-s=*`, `-m=*`) MUST always be placed and evaluated BEFORE positional arguments in functions.
- Avoid "dead code" or unused legacy flags.
- Standardized flags across the library:
  - `-d=* | -data=* | --data=*` -> Input data stream.
  - `-s=* | -sep=* | --sep=*` -> Element separator character.
  - `-k=* | -ksep=* | --ksep=*` -> Key-value separator character.
  - `-m=* | -mode=* | --mode=*` -> Search context mode (default is "raw").
