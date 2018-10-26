import path from 'path';
import MiniCssExtractPlugin from 'mini-css-extract-plugin';
import { VueLoaderPlugin } from 'vue-loader';
import UglifyJsPlugin from 'uglifyjs-webpack-plugin';
// PostCss
import postCssPresetEnv from 'postcss-preset-env';
import autoPrefixer from 'autoprefixer';
import postCssImport from 'postcss-import';
import cssNano from 'cssnano';

const inDev = process.env.NODE_ENV === 'development';
console.info('webpack env:', process.env.NODE_ENV);

// PostCss loader conf
const postCssLoader = {
  loader: 'postcss-loader',
  options: {
    ident: 'postcss',
    plugins: loader => [
      postCssPresetEnv({
        browsers: 'last 4 versions',
      }),
      postCssImport({ root: loader.resourcePath }),
      autoPrefixer,
      ...(inDev ? [] : [cssNano]),
    ],
  },
};

/* WEBPACK CONF */
// Production conf
const webpackConf = {
  entry: './public/js/index.js',
  output: {
    path: path.resolve(__dirname, 'public/build'),
    filename: 'main.js',
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: 'main.css',
    }),
    new VueLoaderPlugin(),
  ],
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
        },
      },
      {
        test: /\.scss$/,
        use: [
          'style-loader',
          MiniCssExtractPlugin.loader,
          'css-loader',
          postCssLoader,
          'sass-loader',
        ],
      },
      {
        test: /\.vue$/,
        use: {
          loader: 'vue-loader',
          options: {
            loaders: {
              js: 'babel-loader',
            },
          },
        },
      },
    ],
  },
  optimization: {
    minimizer: [new UglifyJsPlugin()],
  },
};

// Development overrides
if (inDev) {
  webpackConf.devtool = 'source-maps';
  postCssLoader.options.sourceMap = true;
  delete webpackConf.optimization;

  // Override sass rule conf
  webpackConf.module.rules[1] = {
    test: /\.scss$/,
    use: [
      'style-loader',
      {
        loader: 'css-loader',
        options: {
          sourceMap: true,
        },
      },
      postCssLoader,
      {
        loader: 'sass-loader',
        options: {
          sourceMap: true,
        },
      },
    ],
  };
}

export default webpackConf;
