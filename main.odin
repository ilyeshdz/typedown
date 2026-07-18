package main

import "core:mem"
import "core:fmt"
import "lexer"
import "parser"

main :: proc() {
    source := `---
schema: "my-custom-schema"
	test: 10
test2: 3.14
	test3: "hello"
---`

    my_lexer := lexer.lexer_init(source)
    arena: mem.Dynamic_Arena
    mem.dynamic_arena_init(&arena)
    defer mem.dynamic_arena_destroy(&arena)
    arena_allocator := mem.dynamic_arena_allocator(&arena)

    my_parser := parser.parser_init(&my_lexer)
    document := parser.parser_parse(&my_parser, arena_allocator)

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
