package main

import "core:fmt"
import "core:unicode"

Token :: struct {
    kind:  TokenKind,
    value: string,
}

TokenKind :: enum {
    YamlIdentifier,
    YamlString,
    YamlInt,
    YamlFloat,
    YamlBool,
    YamlColon,
    YamlHyphen,
}

lex_yaml :: proc(source: string) -> [dynamic]Token {
    tokens := [dynamic]Token{}
    i := 0

    for i < len(source) {
        char := cast(rune)source[i]

        if char == ' ' || char == '\t' || char == '\n' || char == '\r' {
            i += 1
            continue
        }

        if is_identifier_char(char) {
            start_index := i

            for i < len(source) && is_identifier_char(cast(rune)source[i]) {
                i += 1
            }

            str := source[start_index:i]
            append(&tokens, Token{.YamlIdentifier, str})
            continue
        }

        if char == '"' || char == '\'' {
            quote_char := char
            i += 1
            start_index := i

            for i < len(source) && cast(rune)source[i] != quote_char {
                i += 1
            }

            str := source[start_index:i]
            append(&tokens, Token{.YamlString, str})

            if i < len(source) {
                i += 1
            }
            continue
        }

        if char == ':' {
            str := source[i : i+1]
            append(&tokens, Token{.YamlColon, str})
            i += 1
            continue
        }

        if char == '-' {
            str := source[i : i+1]
            append(&tokens, Token{.YamlHyphen, str})
            i += 1
            continue
        }

        i += 1
    }

    return tokens
}

is_identifier_char :: proc(c: rune) -> bool {
    return unicode.is_alpha(c) || unicode.is_digit(c) || c == '_'
}

main :: proc() {
    source := `
schema: "my-custom-schema"
- item-one
- 'another item'
    `
    tokens := lex_yaml(source)
    defer delete(tokens)

    for token in tokens {
        fmt.printf("TokenKind: %-15v | Value: %q\n", token.kind, token.value)
    }
}
