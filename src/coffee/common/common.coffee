###
すべてのページで共通して実行される処理を記述します
外部から呼び出し可能なメソッドはexportsへ追記します
###
APP_NAME.common = APP_NAME.namespace("common")
APP_NAME.common.common = (->
  config = APP_NAME.common.config
  util = APP_NAME.util.utility
  exports = {}
  ###
  自動実行
  ###
  $ ->
    

  exports
)()
