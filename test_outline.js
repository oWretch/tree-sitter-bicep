const fs = require('fs');
const path = require('path');

// Test that outline.scm exists and has the expected structure
function testOutlineQuery() {
  const outlineQueryPath = path.join(__dirname, 'queries', 'outline.scm');
  
  if (!fs.existsSync(outlineQueryPath)) {
    throw new Error('outline.scm file does not exist');
  }
  
  const outlineQuery = fs.readFileSync(outlineQueryPath, 'utf8');
  
  // Check that the query contains the expected constructs
  const expectedConstructs = [
    'parameter_declaration',
    'variable_declaration',
    'resource_declaration',
    'module_declaration',
    'output_declaration',
    'type_declaration',
    'user_defined_function',
    'metadata_declaration',
    'test_block',
    'assert_statement'
  ];
  
  for (const construct of expectedConstructs) {
    if (!outlineQuery.includes(construct)) {
      throw new Error(`outline.scm is missing ${construct} rule`);
    }
  }
  
  // Check that the query uses @name captures for identifiers
  if (!outlineQuery.includes('@name')) {
    throw new Error('outline.scm is missing @name captures');
  }
  
  // Check that the query defines kind properties
  if (!outlineQuery.includes('"kind"')) {
    throw new Error('outline.scm is missing kind properties');
  }
  
  console.log('✓ outline.scm validation passed');
  console.log(`✓ Found all ${expectedConstructs.length} expected constructs`);
  
  return true;
}

try {
  testOutlineQuery();
  console.log('All outline tests passed!');
} catch (error) {
  console.error('Test failed:', error.message);
  process.exit(1);
}