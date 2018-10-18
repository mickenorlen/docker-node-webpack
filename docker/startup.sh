babelBin="node_modules/babel-cli/bin/babel-node.js"
webpackBin="node_modules/webpack/bin/webpack.js";


if [ ! -d "./node_modules" ] || [ -z "$(ls ./node_modules)" ];
	then yarn install;
else
	npm rebuild node-sass # Make sure correct env binary
fi

echo "starting env: $APP_ENV"

if [[ $APP_ENV == 'production' ]]; then
	NODE_ENV=production $babelBin $webpackBin --mode production --config webpack.config.js &
	NODE_ENV=production $babelBin app.js

else #Development
	NODE_ENV=development $babelBin $webpackBin --mode development --config webpack.config.js --watch &
	NODE_ENV=development $babelBin app.js
fi

tail -f /dev/null # Keep running for debugging
