const assert = require("node:assert");
const { test } = require("node:test");

const Parser = require("tree-sitter");

test("can load Bicep grammar", () => {
  const parser = new Parser();
  assert.doesNotThrow(() => parser.setLanguage(require(".").bicep));
});

test("can load Bicep Params grammar", () => {
  const parser = new Parser();
  assert.doesNotThrow(() => parser.setLanguage(require(".").bicep_params));
});
