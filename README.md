# yaml-parser

Like the name suggests, it is a YAML parser written in Odin. Why Odin? Cuz it's fun :)

I started this project because I wanted to work on something (even if it might end up being useless) that would teach me new things, and somehow it turned into a complex project that will be under continuous development until I actually finish it.

And no, I initially thought it was a great idea to match what the specification says in terms of how to implement it, but it was such a messy and complex architecture that I would never finish it in a reasonable amount of time. So, why not just build it my own way (even if it's not the "official" way and might lead to a bunch of bugs and stuff)?

Also, reading the YAML spec was... an experience. Did you know YAML technically supports JSON as a subset? Yeah, I'm not gonna bother with that. Full spec compliance is completely out of scope - the spec is 70 pages of pure chaos and I will never use all of it anyway.

Here's the current state of the project:

* **Lexer** [x] - Handles identifiers, quoted strings, integers, floats, indentation (`Indent`/`Dedent` tokens via an indent stack), stream markers (`---`), bullets (`- `), and colons. Pretty solid.
* **Parser** [~] - Recursive-descent parser that can handle flat and nested block mappings. Scalar values are typed (string, integer, float). Errors are propagated with line:col reporting. Still missing sequences (the AST has `SequenceNode` but it's not wired up yet), and deeper nesting beyond the first indent level could use more testing. Flow sequences/containers are planned but not implemented.

Hope you find this project at least a little bit useful and interesting :)))

Made with ❤️ by [@ilyeshdz](https://github.com/ilyeshdz)
