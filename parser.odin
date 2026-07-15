package main;

import "core:fmt"

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
