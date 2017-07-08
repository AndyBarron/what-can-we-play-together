'use strict';
const BabiliPlugin = require('babili-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const OptimizeCssAssetsWebpackPlugin = require('optimize-css-assets-webpack-plugin');
const path = require('path');
const webpack = require('webpack');

const exclude = new RegExp('^' + path.resolve('node_modules'));
const prod = process.env.NODE_ENV === 'production';

const config = module.exports = {
  entry: [
    'normalize.css',
    path.resolve('src', 'node_modules', 'client', 'style.css'),
    'babel-polyfill',
    path.resolve('src', 'node_modules', 'client', 'index.jsx'),
  ],
  output: {
    path: path.resolve('dist'),
    filename: 'app.js?[hash:7]',
    publicPath: '/',
  },
  resolve: {
    extensions: ['*', '.js', '.jsx'],
  },
  module: {
    rules: [
      // { test: /\.css$/, use: ['style-loader', 'css-loader'] },
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader', // when plugin is disabled i.e. during development
          use: ['css-loader'],
        }),
      },
      { test: /\.js$/, loader: 'babel-loader', exclude },
      { test: /\.jsx$/, loader: 'babel-loader', exclude },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'What can we play together?'
    }),
    new ExtractTextPlugin({
      filename: 'app.css?[hash:7]',
      disable: !prod,
    }),
  ],
  devServer: {
    historyApiFallback: true,
    proxy: {
      '/api/*': {
        target: 'http://localhost:3000',
      },
      '/openid/*': {
        target: 'http://localhost:3000',
      },
    },
  },
};

const plugins = config.plugins;

if (prod) {
  plugins.unshift.apply(plugins, [
    new webpack.DefinePlugin({
      'process.env':{
        'NODE_ENV': JSON.stringify('production'),
      },
    }),
    new BabiliPlugin(),
    new OptimizeCssAssetsWebpackPlugin({
      assetNameRegExp: /\.css(\?.*)?$/i,
    }),
  ]);
  config.devtool = 'source-map';
} else {
  plugins.unshift.apply(plugins, [
    new webpack.NamedModulesPlugin(),
  ]);
  config.devtool = 'eval-source-map';
}
