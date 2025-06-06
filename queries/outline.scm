; Outline queries for Bicep files
; These queries extract the main constructs for outline/symbol views

; Parameters
(parameter_declaration
  (identifier) @name
  (#set! "kind" "parameter")) @definition.parameter

; Variables  
(variable_declaration
  (identifier) @name
  (#set! "kind" "variable")) @definition.variable

; Resources
(resource_declaration
  (identifier) @name
  (string) @detail
  (#set! "kind" "resource")) @definition.resource

; Modules
(module_declaration
  (identifier) @name
  (string) @detail
  (#set! "kind" "module")) @definition.module

; Outputs
(output_declaration
  (identifier) @name
  (type) @detail
  (#set! "kind" "output")) @definition.output

; Type declarations
(type_declaration
  (identifier) @name
  (#set! "kind" "type")) @definition.type

; User-defined functions
(user_defined_function
  name: (identifier) @name
  returns: (type) @detail
  (#set! "kind" "function")) @definition.function

; Metadata
(metadata_declaration
  (identifier) @name
  (#set! "kind" "metadata")) @definition.metadata

; Test blocks
(test_block
  (identifier) @name
  (string) @detail
  (#set! "kind" "test")) @definition.test

; Assert statements
(assert_statement
  name: (identifier) @name
  (#set! "kind" "assert")) @definition.assert