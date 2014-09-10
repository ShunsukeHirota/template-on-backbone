APP_NAME.common = APP_NAME.namespace("common")
APP_NAME.common.configsp = (->
  config = APP_NAME.common.config;
  exports = {}
  config.DEVICE_TYPE = 'SP'

  return exports
)()