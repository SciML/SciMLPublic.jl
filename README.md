# Public.jl

## Example usage

```julia
module HelloWorld

using SciMLPublic: @public

@public f

function f()
    return "hello"
end

function g()
    return "world"
end

end # module
```
