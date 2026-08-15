'use strict';

const { execFileSync } = require('node:child_process');
const { resolve } = require('node:path');

function run(command, arguments_, options = {}) {
  execFileSync(command, arguments_, { stdio: 'inherit', ...options });
}

async function prepare(_pluginConfig, context) {
  const token = process.env.RELEASE_APP_TOKEN;
  const actionDirectory = process.env.CREATE_VERIFIED_COMMITS_ACTION;
  const branch = process.env.RELEASE_BRANCH ?? 'master';

  if (!token || !actionDirectory) {
    throw new Error('RELEASE_APP_TOKEN and CREATE_VERIFIED_COMMITS_ACTION are required.');
  }

  run(process.execPath, ['scripts/set-release-version.mjs', context.nextRelease.version]);
  run(process.execPath, ['scripts/build-release-assets.mjs']);

  const message = `chore(release): ${context.nextRelease.version} [skip ci]\n\n${context.nextRelease.notes}`;
  run(process.execPath, [resolve(actionDirectory, 'dist/index.js')], {
    env: {
      ...process.env,
      GITHUB_WORKSPACE: context.cwd ?? process.cwd(),
      INPUT_COMMIT_MESSAGE: message,
      INPUT_FAIL_ON_EMPTY: 'false',
      INPUT_FILES: 'package.json\nCargo.toml\npyproject.toml\ntree-sitter.json\nCHANGELOG.md',
      INPUT_REF: `refs/heads/${branch}`,
      INPUT_TOKEN: token,
    },
  });

  run('git', ['fetch', 'origin', branch]);
  run('git', ['reset', '--hard', `origin/${branch}`]);
}

module.exports = { prepare };
