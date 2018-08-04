webpackPath="node_modules/webpack/bin/webpack.js";
function dev() { # Start webpack development
	NODE_ENV=development babel-node $webpackPath --mode development --config webpack.config.js;
	tail -f /dev/null;
}

function prod() { # Start webpack production
	NODE_ENV=production babel-node $webpackPath --mode production --config webpack.config.js;
	tail -f /dev/null;
}

function help() { # Show list of functions
    grep "^function" "./scripts/webpack.bash" | cut -d ' ' -f2- | sed 's/{ //g'
}
