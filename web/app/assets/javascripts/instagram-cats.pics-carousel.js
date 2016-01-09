var get_instagram_pics = function() {
  // for instagram
  var tagsArray = ['ねこ','猫','kitty','instacat','ネコ','neko','cat','lovecats','cats','ilovecat']
  var instagramUrl = 'https://api.instagram.com/v1/tags/';
  var tag = shuffle_array(tagsArray)[0];
  instagramUrl += encodeURIComponent(tag) + '/media/recent?client_id=9ad0d13ba1bc4af68fd60217ad853471&max_tag_id=980964481902499453'
  var deferred = $.ajax({
    url     : instagramUrl,
    type    : 'GET',
    dataType: 'jsonp',
  });
  return deferred.promise();
};

var set_instagram_pics = function() {
  get_instagram_pics()
    .then(function(pics) {
      $.each(pics.data, function(index, pic) {
        var item = String();
        item += "<div class='item'>";
        item += "<a href='" + pic.link + "' data-lightbox-gallery='gallery2' target='_blank'>";
        item += "<img src='" + pic.images.standard_resolution.url + "' class='img-responsive img-round' alt='img'></a>";
        item += "<p class='text-black'><B>" + pic.caption.text + "</B></p>";
        item += "<a href='" + pic.link + "' class='btn btn-skin btn-lg btn-scroll text-white'><B>もっと見る</B></a>";
        item += "</div>";
        $('#instagram-owl-works').append(item);
      });
    })
    .then(function() {
      $('#instagram-owl-works').owlCarousel({
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
