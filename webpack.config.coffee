require 'module-alias/register'
BabiliPlugin = require 'babili-webpack-plugin'
ExtractTextPlugin = require 'extract-text-webpack-plugin'
HtmlWebpackPlugin = require 'html-webpack-plugin'
moduleAlias = require 'module-alias'
OptimizeCssPlugin = require 'optimize-css-assets-webpack-plugin'
path = require 'path'
webpack = require 'webpack'

EXCLUDE = new RegExp '^' + (path.resolve 'node_modules')
PROD = process.env.NODE_ENV is 'production'
DEV = not PROD

config = module.exports =
  entry: [
    'babel-polyfill'
    'react-hot-loader/patch' unless PROD
    'normalize.css'
    path.resolve 'src', 'node_modules', 'client', 'style.css'
    path.resolve 'src', 'node_modules', 'client', 'index.coffee'
  ].filter (x) => x
  output:
    path: path.resolve 'dist'
    filename: 'app.js?[hash:7]'
    publicPath: '/'
  resolve:
    extensions: ['*', '.js', '.jsx', '.coffee']
  module:
    rules: [
      {
        test: /\.css$/
        use: ExtractTextPlugin.extract
          fallback: ['style-loader'] # when plugin is disabled i.e. during dev
          use: ['css-loader']
      }
      {
        test: /\.coffee$/
        loader: ['react-hot-loader/webpack', 'babel-loader', 'coffee-loader']
        exclude: EXCLUDE
      }
      {
        test: /\.js$/
        loader: ['react-hot-loader/webpack', 'babel-loader']
        exclude: EXCLUDE
      }
      {
        test: /\.jsx$/
        loader: ['react-hot-loader/webpack', 'babel-loader']
        exclude: EXCLUDE
      }
    ]
  plugins: [
    new HtmlWebpackPlugin
      title: 'What can we play together?'
      template: 'src/node_modules/client/template.html.ejs'
    new ExtractTextPlugin
      filename: 'app.css?[hash:7]'
      disable: DEV
  ]
  devServer:
    historyApiFallback: true
    proxy:
      '/api/*':
        target: 'http://localhost:3000'
      '/openid/*':
        target: 'http://localhost:3000'

plugins = config.plugins

if PROD
  plugins.unshift.apply plugins, [
    new webpack.DefinePlugin
      'process.env':
        'NODE_ENV': JSON.stringify 'production'
    new BabiliPlugin
    new OptimizeCssPlugin
      assetNameRegExp: /\.css(\?.*)?$/i
  ]
  config.devtool = 'source-map'
else
  plugins.unshift.apply plugins, [
    new webpack.NamedModulesPlugin
  ]
  config.devtool = 'eval-source-map'
