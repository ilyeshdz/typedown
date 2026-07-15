package main

import "core:fmt"
import "core:unicode"

is_identifier_char :: proc(c: rune) -> bool {
    return unicode.is_alpha(c) || c == '_'
}

main :: proc() {
    source := `
schema: "my-custom-schema"
test: 10
test2: 3.14
    `
    tokens := lex_yaml(source)
    defer delete(tokens)

    for token in tokens {
        fmt.printf("TokenKind: %-15v | Value: %q\n", token.kind, token.value)
    }

    doc, err := parse_yaml(tokens);
    if err != nil {
        fmt.printf("Error: %v\n", err)
        return
    }

    for entry in doc.entries {
        fmt.printf("Key: %q | Value: %q | Type: %v\n", entry.key, entry.value, entry.type)
    }
}
