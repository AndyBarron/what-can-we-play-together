require 'module-alias/register'
BabiliPlugin = require 'babili-webpack-plugin'
ExtractTextPlugin = require 'extract-text-webpack-plugin'
HtmlWebpackPlugin = require 'html-webpack-plugin'
moduleAlias = require 'module-alias'
OptimizeCssAssetsWebpackPlugin = require 'optimize-css-assets-webpack-plugin'
path = require 'path'
webpack = require 'webpack'

exclude = new RegExp '^' + (path.resolve 'node_modules')
prod = process.env.NODE_ENV == 'production'

config = module.exports =
  entry: [
    'normalize.css'
    path.resolve 'src', 'node_modules', 'client', 'style.css'
    'babel-polyfill'
    path.resolve 'src', 'node_modules', 'client', 'index.coffee'
  ]
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
          fallback: 'style-loader' # when plugin is disabled i.e. during development
          use: ['css-loader']
      }
      {
        test: /\.coffee$/
        loader: 'babel-loader!coffee-loader'
        exclude: exclude
      }
      {
        test: /\.js$/
        loader: 'babel-loader'
        exclude: exclude
      }
      {
        test: /\.jsx$/
        loader: 'babel-loader'
        exclude: exclude
      }
    ]
  plugins: [
    new HtmlWebpackPlugin
      title: 'What can we play together?'
      template: 'src/node_modules/client/template.html.ejs'
    new ExtractTextPlugin
      filename: 'app.css?[hash:7]'
      disable: !prod
  ]
  devServer:
    historyApiFallback: true
    proxy:
      '/api/*':
        target: 'http://localhost:3000'
      '/openid/*':
        target: 'http://localhost:3000'

plugins = config.plugins

if prod
  plugins.unshift.apply plugins, [
    new webpack.DefinePlugin
      'process.env':
        'NODE_ENV': JSON.stringify 'production'
    new BabiliPlugin
    new OptimizeCssAssetsWebpackPlugin
      assetNameRegExp: /\.css(\?.*)?$/i
  ]
  config.devtool = 'source-map'
else
  plugins.unshift.apply plugins, [
    new webpack.NamedModulesPlugin
  ]
  config.devtool = 'eval-source-map'
