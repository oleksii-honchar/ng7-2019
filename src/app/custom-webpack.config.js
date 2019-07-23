const WebpackShellPlugin = require('./src/libs/WebpackShellPlugin')

const $pkg = require('./package.json')

module.exports = {
  // Use as a custom webpack builder in angular.json
  // https://webpack.js.org/configuration/output/#output-library
  output: {
    library: 'ng8Test'
  },
  plugins: [
    new WebpackShellPlugin({
      onBuildStart: [`echo "Building app [${$pkg.name}] bundle..."`],
      onBuildEnd: [
        `if [ "${process.env.SSR}" = "true" ]; then sleep 3s && echo "touching app-svc to restart..." && touch ../app-svc/src/index.js; fi`,
      ],
    }),
  ],
};
