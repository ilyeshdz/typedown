package main

import "core:fmt"
import "lexer"

main :: proc() {
    source := `---
schema: "my-custom-schema"
test: 10
test2: 3.14
    test3:
    	- hello world
---
    `

    my_lexer := lexer.lexer_init(source);

    tokens := [dynamic]lexer.Token{}
    defer delete(tokens);

    for {
        tok := lexer.lexer_next_token(&my_lexer)
        if tok.kind == .Eof {
            break
        }
        append(&tokens, tok)
    }

    for token in tokens {
        fmt.println(token)
    }
}
