const { accessSync, constants } = require('fs')
const { resolve } = require('path')
const { setInEnvWithBackwardCompatibility } = require('./utils/helpers')

setInEnvWithBackwardCompatibility('SHAKAPACKER_CONFIG')

const configFileExists = (filename) => {
  try {
    accessSync(resolve('config', filename), constants.R_OK)
    return true
  } catch (err) {
    return false
  }
}

const fallbackConfigPath = () => {
  if (configFileExists('shakapacker.yml')) return resolve('config', 'shakapacker.yml')
  if (configFileExists('webpacker.yml')) return resolve('config', 'webpacker.yml')
  
  // If neither of files exist, try to resolve to shakapacker.yml to get more relevant error
  return resolve('config', 'shakapacker.yml')
}

module.exports = process.env.SHAKAPACKER_CONFIG || resolve('config', fallbackConfigPath())
