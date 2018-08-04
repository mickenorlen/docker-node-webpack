import webpack from 'webpack';

console.log('env', process.env.NODE_ENV);

export default  {
  entry: './public/js/index.js',
  output: {
    path: '/src/app/public/build/',
    filename: 'bundle.js'
  },
};
