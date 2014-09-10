APP_NAME.common = APP_NAME.namespace("common")
APP_NAME.common.config = (->
  exports = {}
  exports.SITE_TITLE = '';
  exports.DEBUG = true;
  _domain = ''
  _preview = ''
  _local = ''

  
  # DOMAIN --------------------------------------------------
  exports.LOCAL = (->
    href = location.href
    if (href.match('local.'))
      return true;
    else
      if (href.match('http'))
        return false
      else
        return true
  )()

  exports.PREVIEW = do ->
    href = location.href
    if (href.match(_preview + ''))
      #getPreview()
      return true;
    else
        return false

  exports.PROTOCOL = (->
    'https://'
  )()
  exports.STG = (->
    return if location.href.match(/stg\./) then true else false
  )()

  exports.RELEASE = (->
    if exports.LOCAL || exports.PREVIEW || exports.STG
      return false
    return (if location.href.match(_domain) then true else false)
  )()

  exports.PROTOCOL = (->
    if exports.STG || exports.RELEASE
      return 'https://'
    else
      return 'http://'
  )()

  exports.DOMAIN = (->
    if exports.PREVIEW then return _preview + '.tyo-id.jp/';
    if exports.LOCAL then return 'local.' + _local
    stg = if exports.STG then 'stg.' else ''
    return stg + _domain + '/';
  )()

  exports.URL = (->
    return exports.PROTOCOL + exports.DOMAIN;
  )()

  # DEVICE --------------------------------------------------
  exports.DEVICE_TYPE = 'PC'
  exports.DEVICE_TYPE_PC = 'PC'
  exports.DEVICE_TYPE_SP = 'SP'

  # FB API ID --------------------------------------------------
  exports.FB_API_ID = do () -> return if exports.RELEASE || exports.STG then '' else '';

  # IE --------------------------------------------------
  exports.isIE = (->
    _ccon = `/*@cc_on!@*/false`;
    return _ccon
  )()

  exports.isIE8 = (->
    _ccon = false;
    `/*@cc_on
      @if (@_jscript_version <= 5.8) 
      _ccon = true;
    @end
    @*/`
    return _ccon;
  )()

  exports.isIE9 =  (->
    _ccon = false;
    `/*@cc_on
      @if (@_jscript_version == 9) 
      _ccon = true;
    @end
    @*/`
    return _ccon;
  )()

  # SHARE --------------------------------------------------
  exports.SHARE_TEXT = '';

  # Facebook ----------
  exports.FACEBOOK = 'http://www.facebook.com/sharer.php?u=';
  exports.FACEBOOK_FEEDDIALOG = 'http://www.facebook.com/dialog/feed?app_id=' + exports.FB_API_ID + '&redirect_uri=' + exports.PROTOCOL + exports.DOMAIN + 'assets/javascripts/close.html&display=popup';

  # Twitter ----------
  exports.getTwitterShare = () -> 
    return 'https://twitter.com/intent/tweet?&text=' + encodeURIComponent(exports.SHARE_TEXT) + ' ' + encodeURIComponent(exports.URL.replace(/\/$/, ''));

  exports.getTwitterShareWithText = (text) ->
    return 'https://twitter.com/intent/tweet?&text=' + encodeURIComponent(text);

  # LINE ----------
  exports.LINE = 'https://line.naver.jp/R/msg/text/?' + encodeURIComponent(exports.SHARE_TEXT);

  # Share用新規windowサイズ
  exports.SHARE_WINDOW_STATUS = 'width=580,height=380,scrollbars=no';
  exports.SHARE_WINDOW_STATUS_FEEDDIALOG = 'width=720,height=380,scrollbars=no';

  # GA TRACK --------------------------------------------------
  # Track Type
  exports.GATRACK_TYPE =
    'SHARE': 'share'

  return exports
)()