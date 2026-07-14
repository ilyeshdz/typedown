package main

import "core:fmt"
import "core:unicode"
import "core:strings"

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

        if unicode.is_digit(char) {
            sb := strings.Builder{}
            strings.write_rune(&sb, char)
            has_decimal := false
            for i < len(source) && unicode.is_digit(cast(rune)source[i]) || (char == '.' && !has_decimal) {
                if char == '.' {
                    has_decimal = true
                }
                char := cast(rune)source[i]
                strings.write_rune(&sb, char)
                i += 1
            }
            append(&tokens, Token{.YamlInt, strings.to_string(sb)})
            continue
        }

        i += 1
    }

    return tokens
}

YamlDocument :: struct {
	entries: [dynamic]YamlEntry,
};

YamlEntry :: struct {
	key:   string,
	value: string,
	type:  YamlEntryType,
}

YamlEntryType :: enum {
	YamlString,
	YamlInteger,
	YamlFloat,
	YamlBoolean,
}

YamlDocumentError :: enum {
	YamlDocumentErrorInvalidToken
}

parse_yaml :: proc(tokens: [dynamic]Token) -> (YamlDocument, YamlDocumentError) {
	doc := YamlDocument{}

	for i := 0; i < len(tokens); i += 1 {
		token := tokens[i];


		#partial switch token.kind {
		    case .YamlColon:
			    key := tokens[i-1].value
			    value := tokens[i+1].value
			    type: YamlEntryType;
				fmt.println("Something happen", key, value, type)
				fmt.println(tokens[i+1].kind)
			    #partial switch tokens[i+1].kind {
			    case .YamlString:
			        type = .YamlString
			    case .YamlInt:
			        type = .YamlInteger
			    case .YamlFloat:
			        type = .YamlFloat
			    case .YamlBool:
			        type = .YamlBoolean
			    case:
					return doc, .YamlDocumentErrorInvalidToken
			    }
			    append(&doc.entries, YamlEntry{key, value, type})
		}
	}

	return doc, nil
}

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
