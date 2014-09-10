###
{{APP_TITLE}}

Licensed under the MIT License
http://www.opensource.org/licenses/mit-license.php
###
APP_NAME = APP_NAME or {}
APP_NAME.namespace = (ns_string) ->
  parts = ns_string.split(".")
  parent = this
  i = undefined
  i = 0
  while i < parts.length
    parent[parts[i]] = {}  if typeof parent[parts[i]] is "undefined"
    parent = parent[parts[i]]
    i += 1
  parent

APP_NAME.Model = {}
APP_NAME.Collection = {}
APP_NAME.View = {}
APP_NAME.Controller = {}
window.template = (id) ->
  _.template $("#" + id).html()

if typeof Object.create isnt "function"
  Object.create = (o) ->
    F = ->
    F:: = o
    new F()
Math.guid = ->
  "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxx".replace(/[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = (if c is "x" then r else (r & 0x3 | 0x8))
    v.toString 16
  ).toUpperCase()