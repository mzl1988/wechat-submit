#
# 工作主程序
#

fs = require 'fs'

moment = require 'moment'
sage = require 'sage'
config = require 'config'
_ = require 'underscore'

log = require __base + '/common/helpers/log'
Article = require __base + '/common/models/article'

es = sage config.es
est = es.index('wechat').type('articles')

delay = 0
maxTime = 0
maxTimeFilePath = __base + '/config/article'

module.exports = ->
  fs.readFileAsync maxTimeFilePath
  .then (result) -> maxTime = result
  .catch -> maxTime = 0
  .then interval

interval = ->
  Article.find()
  .lean()
  .where('created_at').gt maxTime
  .select 'wechat_name wechat_id title is_original content_url digest content content_text cover datetime sequence_number created_at word_cloud'
  .sort 'created_at'
  .limit config.limit
  .execAsync()
  .then (results) ->
    unless results.length
      delay = 30
      log "No data. Sleeing #{delay} seconds."
      return

    delay = 0
    maxTime = moment(_.last(results).created_at).valueOf()
    log "Got #{results.length} posts. Max id is #{maxTime}."

    est.postAsync results
    .then -> log "Indexed success"
  .then ->
    fs.writeFileAsync maxTimeFilePath, maxTime
  .catch console.error
  .delay 1000 * delay
  .then interval
