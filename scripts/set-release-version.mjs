import { readFile, writeFile } from 'node:fs/promises';

const version = process.argv[2];

if (!/^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$/.test(version ?? '')) {
  throw new Error('Expected a semantic version argument.');
}

async function updateJson(file, update) {
  const document = JSON.parse(await readFile(file, 'utf8'));
  update(document);
  await writeFile(file, `${JSON.stringify(document, null, 2)}\n`);
}

async function updateTomlVersion(file) {
  const source = await readFile(file, 'utf8');
  const matches = source.match(/^version = "[^"]+"$/gm) ?? [];

  if (matches.length !== 1) {
    throw new Error(`${file} must contain exactly one top-level version declaration.`);
  }

  await writeFile(file, source.replace(matches[0], `version = "${version}"`));
}

await updateJson('package.json', document => {
  document.version = version;
});
await updateTomlVersion('Cargo.toml');
await updateTomlVersion('pyproject.toml');
await updateJson('tree-sitter.json', document => {
  document.metadata.version = version;
});
