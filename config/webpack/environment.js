const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

environment.loaders.append('vue', vue)

environment.loaders.set('typescript', {
  test: /\.ts[x]?$/,
  use: [
    {
      loader: "ts-loader",
      options: {
        appendTsSuffixTo: [/\.vue$/] 
      }
    }
  ]
})

module.exports = environment
