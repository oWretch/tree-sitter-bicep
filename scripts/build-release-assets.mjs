import { existsSync } from 'node:fs';
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { execFileSync } from 'node:child_process';

const packageName = JSON.parse(await readFile('package.json', 'utf8')).name;
const trackedFiles = execFileSync('git', ['ls-files'], { encoding: 'utf8' });
const files = `${trackedFiles}${existsSync('CHANGELOG.md') ? 'CHANGELOG.md\n' : ''}`;
const temporaryDirectory = await mkdtemp(join(tmpdir(), 'tree-sitter-release-'));
const fileList = join(temporaryDirectory, 'files');

try {
  await writeFile(fileList, files);
  execFileSync('npx', ['--no-install', 'tree-sitter', 'build', '--wasm'], { stdio: 'inherit' });
  execFileSync('tar', ['-czf', `${packageName}.tar.gz`, '-T', fileList], { stdio: 'inherit' });
} finally {
  await rm(temporaryDirectory, { force: true, recursive: true });
}
