const { isBoolean, setInEnvWithBackwardCompatibility } = require('./utils/helpers')
const config = require('./config')

const fetch = (key) => {
  setInEnvWithBackwardCompatibility(key)
  const value = process.env[key]
  return isBoolean(value) ? JSON.parse(value) : value
}

const devServerConfig = config.dev_server

if (devServerConfig) {
  const envPrefix = (config.dev_server.env_prefix || 'WEBPACKER_DEV_SERVER').replace(/^WEBPACKER_/, 'SHAKAPACKER_')

  // for backward compatibility
  // envPrefix = envPrefix.replace(/^WEBPACKER_/, 'SHAKAPACKER_')

  Object.keys(devServerConfig).forEach((key) => {
    const envValue = fetch(`${envPrefix}_${key.toUpperCase()}`)
    if (envValue !== undefined) {
      devServerConfig[key] = envValue
    }
  })
}

module.exports = devServerConfig || {}
