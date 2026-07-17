# yaml-parser

Like the name suggests, it is a YAML parser written in Odin. Why Odin? Cuz it's fun :)

The project is quite simple and tries to be as compliant as possible to a poorly made specification that has around 70 pages just for... a "simple" and "readable" configuration format.

I started this project because I wanted to work on something (even if it might end up being useless) that would teach me new things, and somehow it turned into a complex project that will be under continuous development until I actually finish it.

Here's the roadmap of the project for now:

* A working lexer [x] (maybe not 100% finished, but well, it pretty much works)
* A working parser [ ] (in progress, will take a million minutes but well, we'll get there)

The parser kind of exists at this point? I mean, I did write a bunch of code for it, but it's far from complete. There's some data structures for sequences and nested stuff, but the actual parsing logic doesn't handle them yet. It only really works for flat key-value pairs. Indentation is tracked (we have indent/dedent tokens), but you can't actually make nested objects right now. It's a work in progress, and it will probably stay that way for a while.

And no, I initially thought it was a great idea to match what the specification says in terms of how to implement it, but it was such a messy and complex architecture that I would never finish it in a reasonable amount of time. So, why not just build it my own way (even if it's not the "official" way and might lead to a bunch of bugs and stuff)?

Also, reading the YAML spec was... an experience. Did you know YAML technically supports JSON as a subset? Yeah, I'm not gonna bother with that. Full spec compliance is completely out of scope - the spec is 70 pages of pure chaos and I will never use all of it anyway. I'll probably add stuff like flow sequences at some point, but only the things that actually make sense to have.

Hope you find this project at least a little bit useful and interesting :)))

Made with ❤️ by [@ilyeshdz](https://github.com/ilyeshdz)
