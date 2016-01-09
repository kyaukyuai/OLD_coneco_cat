var get_rakuten_pics = function() {
  // for rakuten webservice
  var searchWordArray = ['猫 ぬいぐるみ','猫 雑貨','猫 キーホルダー','猫 インテリア', 'ねこ ぬいぐるみ'];
  var sortArray       = ['-reviewAverage','-reviewCount','-itemPrice','+itemPrice','-updateTimestamp','standard'];
  var affiliateId     = '0e2a74f8.b705f347.0e2a74f9.ce1173da';
  var applicationId   = 'bfc5bca21a7bac85a197a29ebeab80dd';
  var rakutenUrl = 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?format=json';
  //rakutenUrl += '&affiliateId=' + affiliateId + '&applicationId=' + applicationId;
  rakutenUrl += '&applicationId=' + applicationId;
  var searchWord = shuffle_array(searchWordArray)[0];
  rakutenUrl += '&keyword=' + encodeURIComponent(searchWord);
  rakutenUrl += '&sort=' + encodeURIComponent(shuffle_array(sortArray)[0]);
  var deferred = $.ajax({
    url     : rakutenUrl,
    type    : 'GET',
    dataType: 'jsonp',
  });
  return deferred.promise();
};

var set_rakuten_pics = function() {
  get_rakuten_pics()
    .then(function(pics) {
      $.each(pics.Items, function(index, pic) {
        var item = String();
        var imageUrl = pic.Item.mediumImageUrls[0].imageUrl.replace(/128x128/g, '512x512');
        item += "<div class='item'>";
        item += "<a href='" + pic.Item.itemUrl + "' data-lightbox-gallery='gallery1' target='_blank'>";
        item += "<img src='" + imageUrl + "' class='img-responsive img-round' alt='img'>";
        item += "</a>";
        item += "<p class='text-black'><B>" + pic.Item.itemName + "</B></p>";
        item += "<p class='text-black'><I>" + pic.Item.itemPrice.toLocaleString() + " 円</I></p>";
        item += "<a href='" + pic.Item.itemUrl + "' class='btn btn-skin btn-lg btn-scroll text-white'><B>もっと見る</B></a>";
        item += "</div>";
        $('#rakuten-owl-works').append(item);
      });
    })
    .then(function() {
      $('#rakuten-owl-works').owlCarousel({
        items : 4,
        itemsDesktop : [1199,5],
        itemsDesktopSmall : [980,5],
        itemsTablet: [768,5],
        itemsTabletSmall: [550,2],
        itemsMobile : [480,2],
        autoPlay: 3000,
      });
    });
};
