// import webpack from 'webpack';
import WebpackNotifierPlugin from 'webpack-notifier';
import path from 'path';
import MiniCssExtractPlugin from 'mini-css-extract-plugin';
import { VueLoaderPlugin } from 'vue-loader';

console.info('webpack env:', process.env.NODE_ENV);

// Production conf
const webpackConf = {
  entry: './public/js/index.js',
  output: {
    path: path.resolve(__dirname, 'public/build'),
    filename: 'main.js',
  },
  plugins: [
    new WebpackNotifierPlugin(),
    new MiniCssExtractPlugin({
      // Options similar to the same options in webpackOptions.output
      // both options are optional
      filename: 'main.css',
      // chunkFilename: "[id].css"
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
          // fallback to yarn dstyle-loader in development
          MiniCssExtractPlugin.loader,
          'css-loader',
          'sass-loader',
        ],
      },
      {
        test: /\.vue$/,
        use: 'vue-loader',
      },
    ],
  },
};


// Development overrides
if (process.env.NODE_ENV === 'development') {
  webpackConf.devtool = 'source-maps';

  // Override sass rule conf
  webpackConf.module.rules[1] = {
    test: /\.scss$/,
    use: [{
      loader: 'style-loader',
    }, {
      loader: 'css-loader',
      options: {
        sourceMap: true,
      },
    }, {
      loader: 'sass-loader',
      options: {
        sourceMap: true,
      },
    }],
  };
}

export default webpackConf;
