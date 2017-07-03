# What can we play together?

## Dev setup
* Create a new file `.env` in the root directory. (It will be ignore by Git.)
* Copy the contents of `example.env` into `.env`, changing the dummy values to
  real ones.
* In production, *only* the process environment will be read -- `.env` will be
  ignored (but it won't be checked into Git anyway).

## Dev notes
* `nodemon.json` is for server code
* `webpack.config.js` is for client code
