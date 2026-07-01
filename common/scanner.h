#ifndef TREE_SITTER_BICEP_SCANNER_H_
#define TREE_SITTER_BICEP_SCANNER_H_

#include "tree_sitter/alloc.h"
#include "tree_sitter/parser.h"

#include <wctype.h>

typedef enum {
    EXTERNAL_ASTERISK,
    IMPORT_LINE_BREAK,
    MULTILINE_STRING_CONTENT,
} TokenType;

typedef struct {
    uint8_t quote_before_end_count;
} Scanner;

static inline void advance(TSLexer *lexer) { lexer->advance(lexer, false); }

static inline void skip(TSLexer *lexer) { lexer->advance(lexer, true); }

static Scanner *scanner_create() { return (Scanner *)ts_calloc(1, sizeof(Scanner)); }

static void scanner_destroy(Scanner *scanner) { ts_free(scanner); }

static unsigned scanner_serialize(Scanner *scanner, char *buffer) {
    buffer[0] = (char)scanner->quote_before_end_count;
    return 1;
}

static void scanner_deserialize(Scanner *scanner, const char *buffer, unsigned length) {
    scanner->quote_before_end_count = 0;
    if (length == 1) {
        scanner->quote_before_end_count = (uint8_t)buffer[0];
    }
}

static bool scanner_scan(Scanner *scanner, TSLexer *lexer, const bool *valid_symbols) {
    if (valid_symbols[EXTERNAL_ASTERISK]) {
        while (iswspace(lexer->lookahead)) {
            skip(lexer);
        }
        if (lexer->lookahead == '*') {
            advance(lexer);
            lexer->mark_end(lexer);
            lexer->result_symbol = EXTERNAL_ASTERISK;
            return true;
        }
    }

    if (valid_symbols[IMPORT_LINE_BREAK]) {
        while (lexer->lookahead == ' ' || lexer->lookahead == '\t' || lexer->lookahead == '\v' || lexer->lookahead == '\f') {
            skip(lexer);
        }

        if (lexer->lookahead == '\r' || lexer->lookahead == '\n') {
            do {
                if (lexer->lookahead == '\r') {
                    advance(lexer);
                    if (lexer->lookahead == '\n') {
                        advance(lexer);
                    }
                } else {
                    advance(lexer);
                }
            } while (lexer->lookahead == '\r' || lexer->lookahead == '\n');

            while (lexer->lookahead == ' ' || lexer->lookahead == '\t' || lexer->lookahead == '\v' || lexer->lookahead == '\f') {
                skip(lexer);
            }

            if (lexer->lookahead == '}' || lexer->lookahead == 0) {
                return false;
            }

            lexer->result_symbol = IMPORT_LINE_BREAK;
            return true;
        }
    }

    if (valid_symbols[MULTILINE_STRING_CONTENT]) {
        bool advanced_once = false;
        while (!lexer->eof(lexer)) {
            if (lexer->lookahead == '\'') {
                if (scanner->quote_before_end_count > 0) {
                    while (scanner->quote_before_end_count > 0) {
                        advance(lexer);
                        scanner->quote_before_end_count--;
                    }

                    lexer->result_symbol = MULTILINE_STRING_CONTENT;
                    return true;
                }

                lexer->mark_end(lexer);
                advance(lexer);
                if (lexer->lookahead == '\'') {
                    advance(lexer);
                    if (lexer->lookahead == '\'') {
                        advance(lexer);

                        // How many quotes to advance on the next external scanner invocation
                        while (lexer->lookahead == '\'') {
                            scanner->quote_before_end_count++;
                            advance(lexer);
                        }

                        lexer->result_symbol = MULTILINE_STRING_CONTENT;
                        return advanced_once;
                    }
                }
            }
            if (lexer->lookahead == '$') {
                lexer->mark_end(lexer);
                advance(lexer);
                if (lexer->lookahead == '{') {
                    // ${ starts an interpolation, return content before it
                    lexer->result_symbol = MULTILINE_STRING_CONTENT;
                    return advanced_once;
                }
                // Standalone $, continue scanning content
                advanced_once = true;
                continue;
            }
            advance(lexer);
            advanced_once = true;
        }
    }

    return false;
}

#endif // TREE_SITTER_BICEP_SCANNER_H_
