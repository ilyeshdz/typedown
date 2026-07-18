package parser

import lexer_package "../lexer"
import "core:fmt"

Parser :: struct {
	lexer:        ^lexer_package.Lexer,
	current:      lexer_package.Token,
	previous:     lexer_package.Token,
	current_key:  string,
	indent_stack: [dynamic]int,
}

parser_init :: proc(lexer: ^lexer_package.Lexer) -> Parser {
	return Parser {
		lexer,
		lexer_package.lexer_next_token(lexer),
		lexer_package.Token{},
		"",
		[dynamic]int{},
	}
}

parser_parse :: proc(p: ^Parser, allocator := context.allocator) -> (document: YamlDocument) {
	context.allocator = allocator

	document = YamlDocument{new(MappingNode)}
	mapping := MappingNode{}

	parser_expect(p, .StreamStart)
	parse_mapping(p, &mapping)

	document.root = &mapping

	return
}

parse_mapping :: proc(p: ^Parser, mapping: ^MappingNode) {
	for {
		skip_newlines(p)
		if p.current.kind == .Dedent || p.current.kind == .Eof || p.current.kind == .StreamEnd {
			return
		}

		parser_expect(p, .Identifier)
		key := new(YamlNode)
		key^ = YamlNode{.Scalar, ScalarNode{p.previous.text, .String}}
		parser_expect(p, .Colon)

		value := parse_value(p)

		append(&mapping.pairs, MappingPair{key, value})
	}
}

parse_value :: proc(p: ^Parser) -> (node: ^YamlNode) {
	skip_newlines(p)

	node = new(YamlNode)

	if p.current.kind == .Indent {
		parser_advance(p)
		nested_mapping := MappingNode{}
		parse_mapping(p, &nested_mapping)
		parser_expect(p, .Dedent)
		node^ = YamlNode{.Mapping, MappingNode{nested_mapping.pairs}}
		return
	}

	parser_expect(p, .Identifier, .String, .Float, .Integer)
	scalar_type := ScalarType.String
	if p.previous.kind == .Integer {
		scalar_type = ScalarType.Integer
	} else if p.previous.kind == .Float {
		scalar_type = ScalarType.Float
	}
	node^ = YamlNode{.Scalar, ScalarNode{p.previous.text, scalar_type}}
	return
}


// The helpers functions

skip_newlines :: proc(p: ^Parser) {
	for p.current.kind == .Newline {
		parser_advance(p)
	}
}

parser_advance :: proc(p: ^Parser) {
	p.previous = p.current
	p.current = lexer_package.lexer_next_token(p.lexer)
}

parser_match :: proc(p: ^Parser, kind: lexer_package.Token_Kind) -> bool {
	if p.current.kind == kind {
		return true
	}

	return false
}

parser_expect :: proc(p: ^Parser, kinds: ..lexer_package.Token_Kind) {
	for k in kinds {
		if parser_match(p, k) {
			parser_advance(p)
			return
		}
	}
	fmt.println("expected", kinds, "but got", p.current.kind)
	panic("")
}
