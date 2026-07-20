using SciMLTesting, SciMLPublic, Test
using JET

run_qa(SciMLPublic; api_docs_kwargs = (; rendered = true), explicit_imports = true)
