cronJob      = require('cron').CronJob
random       = require('hubot').Response::random
request_json = require('request-json')
request      = require('request')
fs           = require('fs')
twit         = require('twit')
async        = require('async')

# for rakuten webservice
searchWordArray = ['猫 ぬいぐるみ','猫 雑貨','猫 キーホルダー','猫 インテリア', 'ねこ ぬいぐるみ']
sortArray       = ['-reviewAverage','-reviewCount','-itemPrice','+itemPrice','-updateTimestamp','standard']
affiliateId     = '0e2a74f8.b705f347.0e2a74f9.ce1173da'
applicationId   = 'bfc5bca21a7bac85a197a29ebeab80dd'

module.exports = (robot) ->

  keysForImage = {
    consumer_key:        process.env.HUBOT_TWITTER_KEY
    consumer_secret:     process.env.HUBOT_TWITTER_SECRET
    access_token:        process.env.HUBOT_TWITTER_TOKEN
    access_token_secret: process.env.HUBOT_TWITTER_TOKEN_SECRET
  }
  @clientForImage = new twit(keysForImage)

  do_tweet = ->
    async.series({
      search: (callback) ->
        rakutenUrl = 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?format=json'
#        rakutenUrl += '&affiliateId=' + affiliateId + '&applicationId=' + applicationId
        rakutenUrl += '&applicationId=' + applicationId
        searchWord = random searchWordArray
        rakutenUrl += '&keyword=' + encodeURIComponent(searchWord)
        rakutenUrl += '&sort=' + encodeURIComponent(random sortArray)
        console.log("search: #{rakutenUrl}")
        rakuten_client = request_json.createClient(rakutenUrl)
        rakuten_client.get('', (err, res, body) ->
          value       = random [0..body.hits-1]
          console.log("value: #{value}")
          item_price  = "お買い得！" + body.Items[value].Item.itemPrice + "円"
          catch_copy  = body.Items[value].Item.catchcopy.substring(0, 30)
          afl_url     = body.Items[value].Item.itemUrl
          image_url_1 = body.Items[value].Item.mediumImageUrls[0].imageUrl
          image_url_2 = if body.Items[value].Item.mediumImageUrls[1] then body.Items[value].Item.mediumImageUrls[1].imageUrl else ''
          request.get(image_url_1)
            .on('response', (res) ->
            ).pipe(fs.createWriteStream('./images/rakuten_saved_1.jpg'))
          if image_url_2
            request.get(image_url_2)
              .on('response', (res) ->
              ).pipe(fs.createWriteStream('./images/rakuten_saved_2.jpg'))
          tweet = """
            【#{searchWord} グッズ】
            #{item_price}
            #{catch_copy}...
            #{afl_url}
            \#rakuten
          """
          callback(null, tweet)
        )
      post: (callback) ->
        setTimeout(
          () ->
            callback(null, 'post')
          , 10000
        )
    }, (err, result) ->
      b64img_1 = fs.readFileSync('./images/rakuten_saved_1.jpg', { encoding: 'base64' })
      b64img_2 = fs.readFileSync('./images/rakuten_saved_2.jpg', { encoding: 'base64' })
      @clientForImage.post('media/upload', { media_data: b64img_1 }, (err, data, res) ->
        mediaIdStr1 = data.media_id_string
        @clientForImage.post('media/upload', { media_data: b64img_2 }, (err, data, res) ->
          mediaIdStr2 = data.media_id_string
          params = { status: result.search, media_ids: [mediaIdStr1, mediaIdStr2] }
          @clientForImage.post('statuses/update', params, (e, d, r) ->
          )
        )
      )
    )

  cronjob = new cronJob(
    cronTime: '0 10,50 * * * *'
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      do_tweet()
  )

  cronjob.start()
