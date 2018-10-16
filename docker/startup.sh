babelBin="node_modules/babel-cli/bin/babel-node.js"
webpackBin="node_modules/webpack/bin/webpack.js";

function dev() { # Start webpack development
	npm rebuild node-sass # Make sure correct env binary
	NODE_ENV=development $babelBin $webpackBin --mode development --config webpack.config.js --watch &
	NODE_ENV=development $babelBin app.js
	tail -f /dev/null # Keep running for debugging
}

function prod() { # Start webpack production
	npm rebuild node-sass # Make sure correct env binary
	NODE_ENV=production $babelBin $webpackBin --mode production --config webpack.config.js &&
	NODE_ENV=production $babelBin app.js
	tail -f /dev/null # Keep running for debugging
}
