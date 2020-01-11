process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

// >>> drop_console
// const UglifyJsPlugin = require('uglifyjs-webpack-plugin')

// const minimize = {
//   minimizer: [
//     new UglifyJsPlugin({
//       uglifyOptions: {
//         compress: { drop_console: true }
//       }
//     })
//   ],
// }

// environment.config.set('optimization', minimize)

const TerserPlugin = require('terser-webpack-plugin');

const minimize = {
  minimizer: [
    new TerserPlugin({
      // sourceMap: true, // Must be set to true if using source-maps in production
      terserOptions: {
        compress: {
          drop_console: true,
        },
      },
    }),
  ],
}

environment.config.set('optimization', minimize)

// console.log({environment})
// console.log('environment.config.optimization', environment.config.optimization)
// <<< drop_console

module.exports = environment.toWebpackConfig()
