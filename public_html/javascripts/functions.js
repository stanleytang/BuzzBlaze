function mycarousel_initCallback(carousel) {
    $("#slider .slider-navigation a").live('mouseover',function(){
      var x = parseInt($(this).text());
      carousel.scroll(x);
    });

    $('#slider .slider-navigation').live('mouseout',function(){
        carousel.options.auto = 5;
      carousel.startAuto();
  });

   $('#slider .slider-navigation').live('mouseover',function(){
        carousel.options.auto = 0;
      carousel.stopAuto();
  });
};

function mycarousel_itemVisibleInCallback(carousel, li, pos, state) {
  $("#slider .slider-navigation a").removeClass('active');
  $("#slider .slider-navigation a").eq(pos-1).addClass('active');
};

function feed_carousel(carousel, state) {

  page = Math.floor(carousel.last / carousel.options.visible);
  if (page < 1) {
    page = 1;
  }

  curl = carousel.container.attr('data-href') + '/' + page + '?count=' + carousel.options.visible

  $.ajax({
    url: curl,
    success: function(data) {

      if ('' == data) {
        return false;
      }

      items = data.split('</li>');

      ix = 0;
      $.each(items,
      function(i, v) {
        if ("\n" != v) {
          carousel.add(carousel.first + i, v + '</li>');
          ix++;
        }
      });

      if (ix < carousel.options.visible) {
        carousel.reset();
      }
    }
  });

}

function update_view(cel, disp) {
  $.ajax({
    url: '/feeds',
    type: 'POST',
    dataType: 'json',
    data: {
      _method: 'UFEED_DISPLAY',
      ufeed_id: cel.attr('id').replace('uf_', ''),
      ufeed_display: disp
    }
  });

  return true;
}

function update_activity(event, href, title) {
  var ua = $('#user_activities');
  if(ua.hasClass('mine')) {
    ua.find('ul').prepend(
      '<li class="' + event + '"><a href="' + href + '">' + title + '</a></li>'
    );
  }
}

function update_count(part, operand) {
  var up = $('#user_profile');

  if(up.hasClass('mine')) {
    var c = parseInt($('#n_' + part).text());

    var v = c + 1;
    if(null != operand) {
      v = c - 1;
    }

    $('#n_' + part).text(v);
  }
}

function like_entry(e) {

  cel = $(e);
  $.ajax({
    url: cel.attr('href'),
    type: 'GET',
    dataType: 'json',
    data: {
      _method: 'LIKE_ENTRY'
    },
    success: function(data) {
      cel.removeClass('like_entry').addClass('unlike_entry');
      cel.addClass('ico-starred');

      update_activity('like', cel.attr('href'), cel.parent().find('span').text());
      update_count('likes');
    }
  });

}
