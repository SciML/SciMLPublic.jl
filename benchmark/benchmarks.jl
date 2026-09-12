using SciMLPublic, BenchmarkTools

const SUITE = BenchmarkGroup()

# The package's entire workload is @public macro expansion: symbol parsing in
# _get_symbols plus codegen of the `public` expression (or no-op on Julia <1.11).

single = :(@public foo)
multiple = :(@public foo, bar, baz, qux, quux)
macro_form = :(@public @mymacro)

SUITE["expand"] = BenchmarkGroup()

SUITE["expand"]["single"] = @benchmarkable macroexpand(@__MODULE__, $single)
SUITE["expand"]["multiple"] = @benchmarkable macroexpand(@__MODULE__, $multiple)
SUITE["expand"]["macro_form"] = @benchmarkable macroexpand(@__MODULE__, $macro_form)

mixed = :(@public foo, @mymacro, bar)

SUITE["expand"]["mixed_symbols_macros"] = @benchmarkable macroexpand(@__MODULE__, $mixed)
