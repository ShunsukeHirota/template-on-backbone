APP_NAME.util = APP_NAME.namespace("util")
APP_NAME.util.utility = (->
  exports = {}
  _config = APP_NAME.common.config;
  
  # ------------------------------------------------------------
  # Helper
  # ------------------------------------------------------------
  exports.trimText = (text, len, rep = '...') ->
    addr = text;
    if addr.length > len 
      addr = addr.slice(0, len) + rep
    return addr;

  exports.flatHeight = (list, callback) ->
    maxHeight = 0
    maxHeight = Math.max($(tag).height(), maxHeight) for tag in list
    $(tag).height(maxHeight) for tag in list
    if callback then callback()

  exports.getOriginalImageSize = ($image, callback) ->
    img = new Image()
    img.onload = ->
      actual =
        width: img.width
        height: img.height
      img.onload = null
      img = undefined
      callback actual
    img.src = $image.attr('src')# + '?=' new Date().getTime()

  exports.imageComplete = ($imgs, callback) ->
    $imgs.each((i) ->
      _t = @;
      t = $(@)
      if @.complete or t.height() != 0
        callback.apply(_t);
      else
        t.bind('load', ->
          t.unbind();
          callback.apply(_t)
        )
    )


  ###
  @param {String} imgs
  テキストと画像の要素を入れ替える ※スマフォ用
  ###
  exports.swapImageText = (imgs) ->
    imgs.each((i) ->
      txt = $(@).next()
      if txt.hasClass('section-text')
       txt.after($(@));
    )

  exports.setImageWidth = (imgs) ->
    imgs.each((i) ->
      t = $(@)
      _resize = ->
        w = t.width()
        h = t.height()
        t.unbind('load')
        if w <= h
          t.css(
            'margin-left': 'auto'
            'margin-right': 'auto'
            'display': 'block'
          );
          t.width('55%')
      if @.complete
        _resize();
      else
        t.bind('load', _resize)
    )

  ###
  たて型画像の真偽を取得
  @return {Boolean}
  ###
  exports.isVerticalImage = ($image, callback) ->
    _resize = ->
      w = $image.width();
      h = $image.height();
      if w <= h
        return true
      else 
        return false;
    if !$image.get(0) then return;
    if $image.get(0).complete
      if callback?
        callback.apply(@, [_resize()]);
    else
      $image.load(=>
        if callback?
          callback.apply(@, [_resize()]);
      )

  ###
  javascript用時刻フォーマットの桁数に合わせる
  @param {String} time
  @return {Number}
  ###

  exports.getTimeForJsFormat = (time) ->
    if !time then return;
    if time.length >= 13 
      return parseInt(time, 10)
    else
      return parseInt(time + '000', 10);
  
  exports.formatDateFromTime = (time) ->
    result = new Date(exports.getTimeForJsFormat(time));
    return result.getFullYear() + '年' + (result.getMonth() + 1) + '月' + result.getDate() + '日';

  ###
  表示用にフォーマットされたベリーを取得
  
  ###
  exports.berryFormat = ($berry_count, $trueValue=false) ->
    if $trueValue || $berry_count < 10000000
      oku = Math.floor(Math.abs($berry_count) / 10000);
      man = Math.floor(Math.abs($berry_count) % 10000);
      result = '';
      if oku then result = oku + '億';
      if man then result += man + '万';
      if result=="" || !$trueValue && $berry_count < 0 then result = '0';
      if $trueValue && $berry_count < 0 then result = '-' + result;
      return result;
    else
      return '999億9999万';
    
  ###
  @param {String} uri
  @return {String} ハッシュの#を抜いた文字列
  ###
  exports.getModeFromURI = (uri) ->
    result = uri.split("#")
    return result[1]  if result and result.length and result[1]
    ""

  exports.getSegments = ->
    result = []
    _.each(location.pathname.split('/'), (t, i) ->
      if t then result[result.length] = t;
    )
    return result

  exports.getQuerystringByURI = (option) ->
    delimiter = undefined
    if not option or not option.hasOwnProperty("delimiter")
      delimiter = "&"
    else
      delimiter = option.delimiter
    slice_point = window.location.href.indexOf("?")
    if slice_point < 0
      return null
    url_params = window.location.href.slice(slice_point + 1).split(delimiter)
    query_strings = {}
    for i of url_params
      query_string = url_params[i].split("=")
      query_strings[query_string[0]] = query_string[1]
    query_strings

  ###
  Clone Node を取得する(IE用)
  ###
  exports.getClone = (original, elmString) ->
    result = document.createElement(elmString or "div")
    cln = original.clone().get(0)
    result.innerHTML = cln.innerHTML
    result.id = ""
    result.className = cln.className
    return $ result

  exports.getTimestamp = ->
    return ''
    return '?' + new Date().getTime()

  exports.evaluate = (val) ->
    `var result = eval("(" + val + ")")`
    return result;

  ###
  Overlay, Alertなど、フローティング処理時にページを切る処理
  ###
  exports.__TEMP_TOP = 0;
  exports.__TEMP_ACTIVITY = 0;
  exports.pageFix = (target) ->
    exports.__TEMP_TOP = $(window).scrollTop();
    activity = $('#activity-area');
    target = target || $('#page');
    if activity and activity.length
      exports.__TEMP_ACTIVITY = activity.height();
    setTimeout(->
      target.css(
        'top': -(exports.__TEMP_TOP - exports.__TEMP_ACTIVITY)
      )
      target.addClass('page-fixed')
    , 20);

  exports.pageUnfix = (target) ->
    target = target || $('#page');
    setTimeout(->
      target.removeClass('page-fixed')
      if exports.__TEMP_TOP
        if target.hasClass('no-static')
          target.css(
            'top': exports.__TEMP_ACTIVITY
          )
        else
          target.css(
            'position': 'static'#'relative'
            'top': exports.__TEMP_ACTIVITY
          )
        window.scrollTo(0, exports.__TEMP_TOP);
      exports.__TEMP_TOP = 0;
      exports.__TEMP_ACTIVITY = 0;
    , 400);

  exports.updateNumbers = (from, to, callback) ->
    if callback then callback(to);
    return;
    diff = Math.abs(to - from);
    dir = if diff >= 0 then 1 else -1;
    num = 0;
    interval_ = setInterval(->
      callback(from + num * dir);
      num += 8;
      if num > diff
        clearInterval(interval_);
        interval_ = null;
        callback(to);
    , 24);

  ###
  スクロール量を取得
  ###
  exports.getScrolls = ->
    scroll = {};
    scroll.x = (if (window.pageXOffset isnt `undefined`) then window.pageXOffset else (document.documentElement or document.body.parentNode or document.body).scrollLeft)
    scroll.y = (if (window.pageYOffset isnt `undefined`) then window.pageYOffset else (document.documentElement or document.body.parentNode or document.body).scrollTop)
    return scroll;


  # ------------------------------------------------------------
  #    * Cookie
  # * ------------------------------------------------------------

  ###
  Cookieの取得
  @param key {String}
  @return {String} value
  ###
  exports.getCookie = (key) ->
    tmp1 = undefined
    tmp2 = undefined
    len = undefined
    xx1 = undefined
    xx2 = undefined
    xx3 = undefined
    xx1 = xx2 = 0
    tmp1 = " " + document.cookie + ";"
    len = tmp1.length
    while xx1 < len
      xx2 = tmp1.indexOf(";", xx1)
      tmp2 = tmp1.substring(xx1 + 1, xx2)
      xx3 = tmp2.indexOf("=")
      return (unescape(tmp2.substring(xx3 + 1, xx2 - xx1 - 1)))  if tmp2.substring(0, xx3) is key
      xx1 = xx2 + 1
    ""


  ###
  Cookieの設定
  @param key {String}
  @param value {String, Number}
  @param once {Boolean} ブラウザを閉じた時に無効にするかの真偽
  @param path {String} パス指定をするときに使用する。初期値は無指定（カレントディレクトリ）
  @param domain_ {String} ドメインを保存するwebサーバ
  ###
  exports.setCookie = (key, val, once, path, domain_) ->
    tmp = undefined
    tmp = key + "=" + escape(val) + "; "
    tmp += "expires=Tue, 31-Dec-2030 23:59:59; " unless once;
    tmp += "path=" + path + "; "  if path
    tmp += "domain=" + domain_ + "; "  if domain_
    document.cookie = tmp


  ###
  keyを指定してCookieを削除
  @param key {String}
  @param path {String} パス指定をするときに使用する。初期値は無指定（カレントディレクトリ）
  ###
  exports.clearCookie = (key, path, domain_) ->
    tmp = undefined
    _date = new Date()
    _date.setTime 0
    tmp = key + "=" + "; "
    tmp += "expires=" + _date.toGMTString()
    tmp += "path=" + path + "; "  if path
    tmp += "domain=" + domain_ + "; "  if domain_
    document.cookie = tmp

  ###
  GA TRACKS
  ###
  exports.gaTrackEvent = (trackType, label) ->
    if (_gaq)
      _gaq.push(['_trackEvent', _config.DEVICE_TYPE + ': ' + trackType, 'click', label, 1]);

  return exports
)()