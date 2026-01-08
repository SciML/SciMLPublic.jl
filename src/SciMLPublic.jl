"""
    SciMLPublic

A compatibility package providing the `@public` macro for Julia versions before 1.11.

This package backports Julia 1.11's `public` keyword functionality to earlier Julia versions,
allowing package developers to mark APIs as public without exporting them. This provides a
middle ground between exported (fully public) and unexported (internal) functions.

# Exports
- `@public`: Macro to mark symbols as part of the public API

# Example
```julia
module MyModule
using SciMLPublic: @public

export exported_function
@public public_function

exported_function() = "exported"
public_function() = "public but not exported"
_internal_function() = "internal"

end
```

Based on Compat.jl implementation.
License: MIT
https://github.com/JuliaLang/Compat.jl
"""
module SciMLPublic

# Based on Compat.jl
# License: MIT
# https://github.com/JuliaLang/Compat.jl
# https://github.com/JuliaLang/Compat.jl/blob/master/src/compatmacro.jl
# https://github.com/JuliaLang/Compat.jl/blob/a62d95906f3c16c9fa0fe8369a6613dcfd2a4659/src/compatmacro.jl

"""
    @public symbol
    @public symbol1, symbol2, ...
    @public @macro

Mark one or more symbols as part of the public API without exporting them.

On Julia 1.11+, this macro uses the native `public` keyword. On earlier versions,
it is a no-op that does nothing but ensures compatibility.

Public symbols are part of the stable API but must be accessed with module qualification
(e.g., `ModuleName.function_name`), unlike exported symbols which can be used without
qualification after `using ModuleName`.

# Arguments
- `symbols_expr`: A symbol, macro, or tuple of symbols/macros to mark as public

# Examples
```julia
using SciMLPublic: @public

# Mark a single function as public
@public my_function

# Mark multiple symbols at once
@public foo, bar, baz

# Mark a macro as public
@public @my_macro
```

# Julia Version Compatibility
- Julia 1.11+: Uses native `public` keyword functionality
- Julia <1.11: No-op for compatibility (symbols remain unexported but package will work)

See also: [`export`](@ref)
"""
@static if Base.VERSION >= v"1.11.0-DEV.469"
    macro public(symbols_expr::Union{Symbol, Expr})
        symbols = _get_symbols(symbols_expr)
        return esc(Expr(:public, symbols...))
    end
else
    macro public(symbols_expr::Union{Symbol, Expr})
        return nothing
    end
end

"""
    _get_symbols(sym::Symbol) -> Vector{Symbol}
    _get_symbols(expr::Expr) -> Vector{Symbol}

Internal helper function to extract symbols from the argument passed to `@public`.

Handles both single symbols and tuple expressions containing multiple symbols and/or macros.

# Arguments
- `sym::Symbol`: A single symbol to mark as public
- `expr::Expr`: Either a macro expression or tuple of symbols/macros

# Returns
- `Vector{Symbol}`: Vector of symbols to mark as public

# Throws
- `ArgumentError`: If the expression has an invalid format
"""
_get_symbols(sym::Symbol) = [sym]

function _get_symbols(expr::Expr)
    # `expr` must either be a "valid macro expression" or a tuple expression.

    # If `expr` is a "valid macro expression", then we simply return it:
    if _is_valid_macro_expr(expr::Expr)
        return [expr.args[1]]
    end

    # If `expr` is not a "valid macro expression", then we check to make sure
    # that it is a tuple expression:
    if expr.head != :tuple
        msg = """
            Invalid expression head `$(expr.head)` in expression `$(expr)`.
            Try `@public foo, bar, @hello, @world`
        """
        throw(ArgumentError(msg))
    end

    # Now that we know that `expr` is a tuple expression, we iterate over
    # each element of the tuple
    num_symbols = length(expr.args)
    symbols = Vector{Symbol}(undef, num_symbols)
    for (i, arg) in enumerate(expr.args)
        if arg isa Symbol
            symbols[i] = arg
        elseif _is_valid_macro_expr(arg)
            symbols[i] = arg.args[1]
        else
            throw(ArgumentError("cannot mark `$arg` as public. Try `@compat public foo, bar`."))
        end
    end
    return symbols
end

"""
    _is_valid_macro_expr(expr::Expr) -> Bool

Internal helper function to validate that an expression is a valid macro call with no arguments.

This function checks whether an expression represents a macro that can be marked as public,
such as `@mymacro`. It validates the structure of the expression to ensure it's a proper
macro call without arguments.

# Arguments
- `expr::Expr`: Expression to validate

# Returns
- `Bool`: `true` if the expression is a valid macro call, `false` otherwise

# Examples of valid input
- `@foo`
- `@my_macro`

# Examples of invalid input
- `@foo bar` (has arguments)
- `@foo(bar)` (has arguments)
- `foo()` (not a macro)
"""
function _is_valid_macro_expr(expr::Expr)
    # `expr` must be a `:macrocall` expression:
    Meta.isexpr(expr, :macrocall) || return false

    # `expr` must have exactly two arguments:
    (length(expr.args) == 2) || return false

    # The first argument must be a Symbol:
    (expr.args[1] isa Symbol) || return false

    # The first argument must begin with `@` and have length >= 2
    # (because otherwise the first argument would just be `@`, which doesn't make sense)
    arg1_str = string(expr.args[1])
    (length(arg1_str) >= 2 && arg1_str[1] == '@') || return false

    # The second argument must be a `LineNumberNode`
    (expr.args[2] isa LineNumberNode) || return false

    return true
end

# Shorter alias used internally
const _valid_macro = _is_valid_macro_expr

@public @public

end # module Public
