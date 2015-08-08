#
# 配置
#

module.exports =

  es: 'http://localhost:9200'

  mongo:
    uri: null
    host: 'localhost'
    port: 27017
    database: 'wechat'
    user: null
    password: null
    poolSize: 5
    mongos: false

  limit: 50
