#include "../../common/scanner.h"

void *tree_sitter_bicep_params_external_scanner_create() { return scanner_create(); }

void tree_sitter_bicep_params_external_scanner_destroy(void *payload) { scanner_destroy(payload); }

unsigned tree_sitter_bicep_params_external_scanner_serialize(void *payload, char *buffer) {
    return scanner_serialize(payload, buffer);
}

void tree_sitter_bicep_params_external_scanner_deserialize(void *payload, const char *buffer, unsigned length) {
    scanner_deserialize(payload, buffer, length);
}

bool tree_sitter_bicep_params_external_scanner_scan(void *payload, TSLexer *lexer, const bool *valid_symbols) {
    return scanner_scan(payload, lexer, valid_symbols);
}
