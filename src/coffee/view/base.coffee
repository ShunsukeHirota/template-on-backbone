APP_NAME.View.BaseView = Backbone.View.extend(
  common: APP_NAME.common.common
  config: APP_NAME.common.config
  util: APP_NAME.util.utility
  isMobileDevice: APP_NAME.common.config.DEVICE_TYPE == APP_NAME.common.config.DEVICE_TYPE_SP

  initialize: ->

  cancelEvent: (event) ->
    if event then event.preventDefault();
    return false;

  refreshElement: (elements, $selector) ->
    i = undefined
    for i of elements
      this[elements[i]] = $(i, $selector)
  
)