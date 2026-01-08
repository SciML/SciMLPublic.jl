# SciMLPublic.jl

[![CI](https://github.com/SciML/SciMLPublic.jl/workflows/CI/badge.svg)](https://github.com/SciML/SciMLPublic.jl/actions?query=workflow%3ACI)

A compatibility package providing the `@public` macro for Julia versions before 1.11.

## Overview

SciMLPublic.jl backports Julia 1.11's `public` keyword functionality to earlier Julia versions. This allows package developers to mark APIs as public without exporting them, providing a middle ground between exported (fully public) and unexported (internal) functions.

## Installation

```julia
using Pkg
Pkg.add("SciMLPublic")
```

## What is `@public`?

In Julia 1.11+, the `public` keyword marks symbols as part of the public API without exporting them. This means:
- **Exported** functions (via `export`) are automatically public and don't require qualification
- **Public** functions (via `@public`) are part of the stable API but must be qualified with the module name
- **Unexported** functions are internal implementation details

SciMLPublic.jl provides the `@public` macro that:
- On Julia 1.11+: Uses the native `public` keyword
- On Julia <1.11: Does nothing (no-op for compatibility)

## Usage

### Basic Example

```julia
module HelloWorld

using SciMLPublic: @public

# Exported: can be used without qualification
export f

# Public but not exported: must be qualified as HelloWorld.g
@public g

# Internal: not part of public API
function _internal_helper end

function f()
    return "hello"
end

function g()
    return "world"
end

end # module
```

### Marking Multiple Symbols as Public

```julia
using SciMLPublic: @public

# Mark individual symbols
@public foo
@public bar

# Or mark multiple symbols at once
@public foo, bar, baz

# Works with macros too
@public @mymacro
```

## Why Use `@public`?

The `@public` macro helps package maintainers:

1. **Clarify API stability**: Distinguish between stable public APIs and internal implementation details
2. **Avoid namespace pollution**: Keep commonly-named utilities (like `solve`, `step`, etc.) qualified to prevent conflicts
3. **Enable better tooling**: Documentation generators and IDEs can leverage public declarations
4. **Maintain compatibility**: Write code that works across Julia versions

## Example in Practice

```julia
module MyPackage

using SciMLPublic: @public

# Main user-facing function (exported)
export solve

# Public utilities (stable API, but qualified)
@public configure, reset!, get_status

# Internal helpers (not part of public API)
function _validate_input end
function _allocate_cache end

function solve(problem)
    _validate_input(problem)
    cache = _allocate_cache(problem)
    # ... implementation
end

function configure(options)
    # Public configuration API
end

function reset!(state)
    # Public reset API
end

function get_status(obj)
    # Public status query
end

end # module
```

Users would interact with this package as:
```julia
using MyPackage

# Exported function - no qualification needed
solve(my_problem)

# Public functions - must qualify
MyPackage.configure(options)
MyPackage.reset!(state)
status = MyPackage.get_status(obj)

# Internal functions - not accessible/not part of public API
# MyPackage._validate_input(x)  # Should not be used
```

## Compatibility

- Julia 1.0+: The macro is a no-op on versions before 1.11
- Julia 1.11+: Uses native `public` keyword functionality

## Credits

This package is based on [Compat.jl](https://github.com/JuliaLang/Compat.jl)'s implementation of the `@public` macro.

## License

MIT License
