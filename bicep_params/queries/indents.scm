[
  (array)
  (object)
] @indent.begin

"}" @indent.end

[
  "{"
  "}"
] @indent.branch

[
  "["
  "]"
] @indent.branch

[
  "("
  ")"
] @indent.branch

[
  (ERROR)
  (comment)
  (directive_statement)
  (region_directive)
  (endregion_directive)
] @indent.auto
