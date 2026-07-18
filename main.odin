package main

import "core:mem"
import "core:fmt"
import "lexer"
import "parser"
import yaml_error "yaml_error"

main :: proc() {
	source := `---
parent_key:
	child_key:
		test_it_out: value
---`

	my_lexer := lexer.lexer_init(source)
	arena: mem.Dynamic_Arena
	mem.dynamic_arena_init(&arena)
	defer mem.dynamic_arena_destroy(&arena)
	arena_allocator := mem.dynamic_arena_allocator(&arena)

	my_parser, p_err := parser.parser_init(&my_lexer)
	if p_err != nil {
		switch e in p_err {
		case yaml_error.LexerError:
			fmt.eprintf("Lexer error at %d:%d: %s\n", e.line, e.col, e.message)
		case yaml_error.ParserError:
			fmt.eprintf("Parser error at %d:%d: %s\n", e.line, e.col, e.message)
		}
		return
	}
	document, err := parser.parser_parse(&my_parser, arena_allocator)

	if err != nil {
		switch e in err {
		case yaml_error.LexerError:
			fmt.eprintf("Lexer error at %d:%d: %s\n", e.line, e.col, e.message)
		case yaml_error.ParserError:
			fmt.eprintf("Parser error at %d:%d: %s\n", e.line, e.col, e.message)
		}
		return
	}

	root_node: parser.YamlNode
	root_node.kind = .Mapping
	root_node.value = document.root^
	print_yaml_node(&root_node)
}

print_yaml_node :: proc(node: ^parser.YamlNode, depth: int = 0) {
    switch v in node.value {
    case parser.ScalarNode:
        for _ in 0 ..< depth {
            fmt.print("  ")
        }
        fmt.println(v.value)
    case parser.MappingNode:
        for pair in v.pairs {
            for _ in 0 ..< depth {
                fmt.print("  ")
            }
            key_str := pair.key.value.(parser.ScalarNode).value
            fmt.printf("%s:\n", key_str)
            print_yaml_node(pair.value, depth + 1)
        }
    case parser.SequenceNode:
        for item in v.items {
            print_yaml_node(item, depth)
        }
    }
}
