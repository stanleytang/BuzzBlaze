jQuery(function($) {

   $('#navigation a[href^="#"]').live('click',function() {
      var item = $(this).attr('href');
      $(item).slideToggle('fast');
      $(this).toggleClass('link-act');
      return false;
   });

   $('.btn-go').live('mouseover', function() {
      $(this).addClass('btn-go-h');
   });
   $('.btn-go').live('mouseout', function() {
       $(this).removeClass('btn-go-h');
   });

   $('.blink').live('focus',function() {
      if( $(this).val() == $(this).attr('title') ) {
          $(this).val('');
      };
  });
   $('.blink').live('blur',function() {
      if( $(this).val() == '' ) {
          $(this).val( $(this).attr('title') );
      }
   });

  $('.w-big').find('.carousel').jcarousel({
    visible: 4,
    scroll: 4,
    itemLoadCallback: {
      onBeforeAnimation: function(carousel, state) {
        feed_carousel(carousel, state);
      }
    }
  });

  $('.w-small').find('.carousel').jcarousel({
    vertical: true,
    visible: 7,
    scroll: 7,
    itemLoadCallback: {
      onBeforeAnimation: function(carousel, state) {
        feed_carousel(carousel, state);
      }
    }
  });

   $('.carousel li').live('mouseover',function() {
       if( $.browser.msie && $.browser.version.substr(0,1) == 6 ) {
           $(this).find('.socials').show();
           $(this).find('.zoom').show();
       }
       else {
           $(this).find('.socials').stop(true, true).fadeIn();
           $(this).find('.zoom').stop(true, true).fadeIn();
       }
   });
   $('.carousel li').live('mouseout',function() {

       if( $.browser.msie && $.browser.version.substr(0,1) == 6 ) {
           $(this).find('.socials').hide();
           $(this).find('.zoom').hide();
       }
       else {
           $(this).find('.socials').stop(true, true).fadeOut();
           $(this).find('.zoom').stop(true, true).fadeOut();
       }
   });

   $('.widget').each(function() {
      if( $(this).hasClass('w-small') ) {
          $(this).find('.grid-view').addClass('active');
      }
      else {
          $(this).find('.list-view').addClass('active');
      }
   });

   $('.widget').live('mouseover', function() {
      $(this).find('.edit').stop(true, true).show();
      $(this).find('.add-feed').stop(true, true).fadeIn();
   });
   $('.widget').live('mouseout', function() {
      $(this).find('.edit').stop(true, true).fadeOut();
      $(this).find('.add-feed').stop(true, true).fadeOut();
   });

   $('.view a').each(function() {
      var tx = $(this).text();
      $(this).append('<span class="tooltip"></span>').find('.tooltip').html(tx);
   });

   $('.view a').live('mouseover', function() {
      $(this).find('.tooltip').show();
   });
   $('.view a').live('mouseout', function() {
        $(this).find('.tooltip').hide();
  });

  function clonecarousel(selector) {
  var new_carousel = $(selector).clone();
    $(selector).hide().after(new_carousel);
    return $(selector).next();
  }

  $('.view a').live('click', function() {
    $(this).siblings().removeClass('active');
    $(this).addClass('active');;
    return false;
  });

  $('.list-view').live('click', function() {
    if( $(this).parents('.widget:eq(0)').hasClass('w-small')) {
      $(this).parents('.widget:eq(0)').removeClass('w-small').addClass('w-big');
      $(this).parents('.widget:eq(0)').find('.carousel li').attr('style', '');
      $(this).parents('.widget:eq(0)').find('.carousel ul').attr('style', '');
      var carousel = clonecarousel($(this).parents('.w-big:eq(0)').find('.carousel'));
      $(carousel).jcarousel({
        scroll: 4,
        visible: 4,
        vertical: false,
        itemLoadCallback: {
          onBeforeAnimation: function(carousel, state) {
            feed_carousel(carousel, state);
          }
        }
      });

      $(this).parents('.widget:eq(0)').find('.carousel:eq(0)').remove();
      update_view($(this).parent().parent().parent().parent(), 0);
    }

   return false;
  });


  $('.grid-view').live('click',function() {
    if( $(this).parents('.widget:eq(0)').hasClass('w-big')) {
      $(this).parents('.widget:eq(0)').removeClass('w-big').addClass('w-small');
      $(this).parents('.widget:eq(0)').find('.carousel li').attr('style', '');
      $(this).parents('.widget:eq(0)').find('.carousel ul').attr('style', '');
      $(this).parents('.widget:eq(0)').find('.widget-head h3').text( $(this).parents('.widget:eq(0)').find('.widget-head h3').text().length>15 ? $(this).parents('.widget:eq(0)').find('.widget-head h3').text().substr(0,15)+'...' : $(this).parents('.widget:eq(0)').find('.widget-head h3').text() );
      var carousel = clonecarousel($(this).parents('.w-small:eq(0)').find('.carousel'));
      $(carousel).jcarousel({
        scroll: 7,
        visible: 7,
        vertical: true,
        itemLoadCallback: {
          onBeforeAnimation: function(carousel, state) {
            feed_carousel(carousel, state);
          }
        }
      });
      $(this).parents('.widget:eq(0)').find('.carousel:eq(0)').remove();
      $(this).parents('.widget:eq(0)').find('.carousel li').hover(function() {
        $(this).find('.ico-star').show();
      }, function() {
        $(this).find('.ico-star').hide();
      });

      update_view($(this).parent().parent().parent().parent(), 1);
    }

    return false;
  });

  $('.widget-content').append('<span class="ie-widget"></span>');

  $('.w-small li').live('mouseover',function() {
     $(this).find('.ico-star').show();
  });
  $('.w-small li').live('mouseout',function() {
     $(this).find('.ico-star').hide();
  });

  $('#profile .widget-head').each(function() {
     $(this).find('.remove').remove();
     $(this).find('.edit').remove();

     if(typeof mine != 'undefined' && true != mine) {
       $(this).append('<a href="#" class="add-feed notext">Add feed</a>');
     }
  });

  $('.carousel').each(function() {
     $(this).find('li:last').addClass('last');
  });

  $('.l-follow').live('click', function() {
     if('/register' != $(this).attr('href')) {
       $(this).addClass('following');
     }
     return false;
  });

  if($.browser.msie && $.browser.version.substr(0,1) == 6 ) {
    $('.edit-box ul').css({
      height: "auto"
    });
    $('.item-scroller .jcarousel-next').each(function() {
      $(this).text('more');
    });
    $('.item-scroller .jcarousel-prev').each(function() {
      $(this).text('less');
    });
  }

  $(document).click(function(e) {
    if ($(e.target).parents('#login').length) {
    } else {
      $('#login .login-dd').slideUp(function() {
        $('#login .btn').removeClass('btn-active');
      });
    };
  });

  $('#login .btn').click(function() {
    $(this).next().slideToggle();
    $(this).toggleClass('btn-active');
    return false;
  });

  if ($('#slider').length) {
    $("#slider ul").jcarousel({
      auto: 5,
      animation: 150,
      scroll: 1,
      wrap: 'both',
      initCallback: mycarousel_initCallback,
      itemVisibleInCallback: mycarousel_itemVisibleInCallback,
      buttonNextHTML: null,
      buttonPrevHTML: null
    });
  };

  var cursor_inside_selectbox = false;
  var isBlocked = false;
  $('.dynamic-list li').live('mouseover', function(e) {
    if (isBlocked) {
      return;
    };
    if ($(e.target).is('select') || $(e.target).is('option')) {
      cursor_inside_selectbox = true;
    };
    $('.friends-list li, .results-list li, .manage-feeds-list li').removeClass('active');
    $(this).addClass('active');
  });

  $('.dynamic-list li').live('mouseout',function(e) {
    if (!cursor_inside_selectbox) {
      $(this).removeClass('active');
    };
  });
  $('.page-selector').live('change', function() {
    $.ajax({
      url: '/dashboard',
      type: 'POST',
      dataType: 'html',
      data: {
        _method: 'UPDATE_UFEED',
        ufeed_id: $(this).attr('data-ufeed'),
        page_id: $(this).attr('data-page'),
        new_page_id: $(this).val()
      },
      success: function(data) {
        $('#messages').html(data).show();
      }
    });

    isBlocked = true;
    setTimeout(function() {
      isBlocked = false;
    }, 500);
  });

  $('.ginput_container .input-file input').live('change',function() {
    $(this).prev().html($(this).val());
  });

  $('#field-username').live('keyup',function() {
    $('#user-address span').text($(this).val());
  });

  /**
  $('.pagination .btn').live('click', function() {
    var $this = $(this);
    $this.addClass('active loader');
    $('.dynamic-list').append('<div class="loading" />').find('.loading').animate({opacity: 0.8},500);
    setTimeout( function() {
      $this.removeClass('active loader');
      $('.dynamic-list').find('.loading').animate({opacity: 0}, 300, function() {
        $(this).remove();
      });
    }, 1000);
    return false;
  });
  */

  $('.tutorial .close').click(function() {
    $(this).parents('.tutorial').fadeOut(600);
    return false;
  });

  /**
  $('#menu a').live('click', function() {
    $('#menu a').removeClass('active');
    $(this).addClass('active');
    var url = $(this).attr('href') + ' #content-inner';
    var ajax_content = $('<div class="ajax_content">').css('opacity',0).load(url);
    $('#content-inner').append('<div class="loading" />').find('.loading').animate({opacity: 0.8},800,function() {
      $('#content-inner').remove();
      $('#menu').after(ajax_content);
      ajax_content.animate({opacity: 1},300);
    });

    return false;
  });
  */

  //Login Submit Button Effects
  $("#login .login-dd .submit, #sign-up .submit ").hover(function(){ $(this).toggleClass('submit-hover'); }).mousedown(function(){ $(this).addClass('submit-click')}).mouseup(function(){ $(this).addClass('submit-click'); });

  //Beta Access Submit Button Hover
  $("#sign-up .beta_access .submit-btn").hover(function(){
    $(this).toggleClass('submit-btn-hover');
  });

  //Beta Access Thanks Message
  $('#sign-up .beta_access .submit-btn').click(function(){

    $.ajax({
      url: '/',
      type: 'POST',
      dataType: 'html',
      data: {
        email: $("#email").val()
      }
    });

    $('.form-holder').fadeOut();
    $('.beta_access').append('<div class="loading" />').find('.loading').animate({opacity: 0.8},500);
    setTimeout( function() {
      $('.beta_access').find('.loading').animate({opacity: 0}, 300, function() {
        $(this).remove();
      });
      $('#sign-up h3.thanks-msg').fadeIn();
    }, 1500);
    return false;
   });

  //Article Like Button
  $('.article .social-links .like').click(function(){
    $(this).toggleClass('unlike');
    return false;
   })

  $('#popular_entries').find('.carousel').jcarousel({
    visible: 5,
    scroll: 5,
    animation: 'medium',
    easing: 'linear',
    wrap: 'circular',
    itemLoadCallback: {
      onBeforeAnimation: function(carousel, state) {

        $.ajax({
          url: '/popular/' + carousel.first + '?count=' + carousel.options.visible,
          success: function(data) {

            if ('' == data) {
              return false;
            }

            items = data.split('</li>');

            ix = 0;

            $.each(items, function(i, v) {
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
    }
  });

  $('.ufeed_subscribe').click(function(e) {
      $(this).hide();
      $('#feedsubscribe').show();
  });

  $('#feedsubscribe').submit(function(e) {
    e.preventDefault();

    cel = $(this);
    $.ajax({
      url: '/dashboard',
      type: 'POST',
      dataType: 'json',
      data: {
        _method: 'SUBSCRIBE_UFEED',
        feedurl: $('#feedurl').val(),
        page: $('#page option:selected').val()
      },
      success: function(data) {
        cel.parent().parent().html('Subscribed!');
      }
    });
  });

  $('.unfollow_user').click(function(e) {
    e.preventDefault();

    var cel = $(this);
    $.ajax({
      url: cel.attr('href'),
      type: 'POST',
      dataType: 'json',
      data: {
        _method: 'UNFOLLOW'
      },
      success: function(data) {
        cel.removeClass('unfollow_user').addClass('follow_user');
        cel.text('Follow');

        if(cel.hasClass('following')) {
          cel.removeClass('following').addClass('l-follow');
        }

        update_count('following', '-');
      }
    });
  });

  $('.follow_user').click(function(e) {
    e.preventDefault();

    var cel = $(this);
    $.ajax({
      url: cel.attr('href'),
      type: 'POST',
      dataType: 'json',
      data: {
        _method: 'FOLLOW'
      },
      success: function(data) {
        cel.removeClass('follow_user').addClass('unfollow_user');
        cel.text('Unfollow');

        if(cel.hasClass('l-follow')) {
          cel.addClass('following');
        }

        update_count('following');
      }
    });
  });

  $('.rm_page').click(function(e) {
    e.preventDefault();

    var page_editor = $(this).parent();
    $.ajax({
      url: '/dashboard',
      type: 'POST',
      dataType: 'html',
      data: {
        page_id:  page_editor.attr('id').replace('page_', ''),
        _method: 'DELETE_PAGE'
      },
      success: function(data) {
        page_editor.fadeOut();
        $('#messages').html(data).show();
      }
    });
  });

  $('#delete_page').click(function(e) {
    e.preventDefault();

    if(!confirm('Are you sure to delete this page?')) {
      return false;
    }

    $.ajax({
      url: '/dashboard',
      type: 'POST',
      dataType: 'html',
      data: {
        page_id: page_id,
        _method: 'DELETE_PAGE'
      },
      success: function(data) {
        $('#messages').html(data).show();

        setTimeout(function() {
          window.location = "/dashboard";
        }, 1000);
      }
    });
  });

  $('.rm_ufeed').click(function(e) {
    e.preventDefault();

    if(confirm('Are you sure want to delete this feed?')) {

      uf = $(this);

      $.ajax({
        url: '/dashboard',
        type: 'POST',
        dataType: 'html',
        data: {
          ufeed_id: uf.attr('data-ufeed'),
          page_id: uf.attr('data-page'),
          _method: 'DELETE_UFEED'
        },
        success: function(data) {
          uf.parent().fadeOut();

          $('#messages').html(data).show();
        }
    });

    }
  });

  $('.ufeed_display').change(function() {

    var cel = $(this);

    $.ajax({
      url: '/feeds',
      type: 'POST',
      dataType: 'json',
      data: {
        _method: 'UFEED_DISPLAY',
        ufeed_id: cel.parent().parent().attr('id').replace('uf_', ''),
        ufeed_display: cel.val()
      }
    });
  });

  $('.like_entry').click(function(e) {
    e.preventDefault();

    var cel = $(this);
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
  });

  $('.unlike_entry').click(function(e) {
    e.preventDefault();

    var cel = $(this);
    $.ajax({
      url: cel.attr('href'),
      type: 'GET',
      dataType: 'json',
      data: {
        _method: 'UNLIKE_ENTRY'
      },
      success: function(data) {
        cel.removeClass('unlike_entry').addClass('like_entry');
        cel.removeClass('ico-starred').addClass('ico-star');

        update_count('likes', '-');
      }
    });
  });

  $('#add_userpage').click(function(e) {
    e.preventDefault();

    $(this).hide();
    $('form#userpage').show();
  });

  $('#update_status').click(function(e) {
    e.preventDefault();

    $('#statusupdate').toggle();
  });

  $('#statusupdate').submit(function(e) {
    e.preventDefault();

    var aself = $(this);
    $.ajax({
      url: '/dashboard',
      type: 'POST',
      dataType: 'json',
      data: {
        _method: 'UPDATE_STATUS',
        status: $('#status').val()
      },
      success: function(data) {
        $('#user_status').text(data.status);
        aself.hide();
      }
    });
  });

  $('.resend_confirm_email').click(function(e) {
    e.preventDefault();

    var aself = $(this);
    $.ajax({
      url: '/dashboard',
      type: 'POST',
      dataType: 'json',
      data: {
        _method: 'RESEND_CONFIRM_EMAIL'
      },
      beforeSend: function(r) {
        aself.text('Please wait...');
      },
      success: function(data) {
        aself.text(data.msg);
      }
    });
  });

  $('.delete_account').click(function(e) {
    e.preventDefault();

    $('#delete_account_box').slideToggle();
  });

  $('.rm_page').click(function(e) {
    e.preventDefault();

    var page_editor = $(this).parent();
    $.ajax({
      url: '/dashboard',
      type: 'POST',
      dataType: 'html',
      data: {
        page_id:  page_editor.attr('id').replace('page_', ''),
        _method: 'DELETE_PAGE'
      },
      success: function(data) {
        page_editor.fadeOut();
        $('#messages').html(data).show();
      }
    });
  });

  $(".datepicker").datepicker({
    changeMonth: true,
    changeYear: true,
    yearRange: '1950:2005',
    dateFormat: 'yy-mm-dd'
  });

  $("a.feed_entry").live('click', function() {
    $.fancybox({
      'titleShow': false,
      'href': this.href + '?_method=READ_ENTRY',
      'autoScale': false,
      'height': 600,
      'width': 990,
      'transitionIn': 'none',
      'transitionOut': 'none',
      'type': 'iframe',
      'onComplete': function() {
        $('body').css('overflow', 'hidden');
      },
      'onClosed': function() {
        $('body').css('overflow', 'auto');
      }
    });

    return false;
  });

  $('a.add-feed').live('click', function(e) {
    if(0 == $('#addthis-overlay').length) {
      $('<div id="addthis-overlay"></div>').appendTo($('body'));
    }

    feedurl = $(this).attr('data-feedurl');
    if(undefined == feedurl) {
      feedurl = $(this).parent().parent().attr('data-feedurl');
    }

    $('#addthis-overlay').html('<form id="addthis-form" action="/dashboard" method="post">'
        + '<input type="hidden" name="_method" value="ADD_UFEED" />'
        + '<input type="hidden" name="useraction" value="add-feed" />'
        + '<input type="hidden" name="feedurl" value="' + feedurl + '" id="addthis-feedurl" />'
        + '<select id="addthis-pageid" name="page"></select>'
        + '<input type="submit" name="add" id="addthis-add" value="Add" /></form>');

    $.each(user_pages, function(i, e) {
      $('#addthis-pageid').append('<option value="' + e.ID + '">' + e.title + '</option>');
    });

    $.fancybox({
      height: 320,
      width: 200,
      href: '#addthis-overlay',
      type: 'inline'
    });

    var adc = $(this);

    $('#addthis-form').submit(function(e) {
      e.preventDefault();

      $.ajax({
        url: $(this).attr('action'),
        type: 'post',
        data: $(this).serialize(),
        success: function(data) {
          $('#messages').html(data).show();
          adc.remove();
        }
      });

      $.fancybox.close();
    });

    return false;
  });

  if($('.link-dd').hasClass('active')) {
    $('#dd-accounts').show();
  }

  $('.bdgen').live('change', function() {
    bdval = $("#bd-year").val() + '-' + $("#bd-month").val() + '-' + $("#bd-day").val();
    $("#birthdate").val(bdval);
  });

  // user register
  $('#field-username').live('keyup',function() {
    $('#user-address span').text($(this).val());
  });

  //Sign up form validating
  $('#sign-up-box input[type="text"], #sign-up-box input[type="password"]')
    .focus(function() {
      $(this).next('.control-bar').removeClass('valid invalid').text($(this).attr('title')).fadeIn(400);
    })
  .blur(function() {
    $(this).next('.control-bar').hide();
    validateField($(this));
  });

  function remote_validation(field, data) {
    $.ajax({
      url: '/validate',
      type: 'post',
      data: data,
      success: function(data) {
        oldStatus = ('valid' == data.status) ? 'invalid' : 'valid';

        controlbar = field.next();

        if (field.is('#recaptcha_response_field')) {
          controlbar = $('#captchabox').find('.control-bar');
        }

        controlbar.removeClass(oldStatus).addClass(data.status).text(data.message).show();
      }
    });	
  }

  function validateField(field) {
    //FULLNAME
    if (field.is('.field-fullname')) {

      remote_validation(field, {full_name: field.val()});

    }

    //USERNAME
    if (field.is('.field-username')) {

      remote_validation(field, {username: field.val()});

    }

    //EMAIL 
    if (field.is('.field-email')) {

      remote_validation(field, {email: field.val()});

    } 

    //PASSWORD
    if (field.is('.field-password')) {

      remote_validation(field, {password: field.val()});

    }

    //CONFIRM PASSWORD
    if (field.is('.field-confirm-password')) {

      remote_validation(field, {
        password_confirm: field.val(),
      password: $('#sign-up-box input[type="password"][name="password"]').val()
      });

    }

    /**
    if (field.is('#recaptcha_response_field')) {
      remote_validation(field, {
        recaptcha_challenge_field: $('#recaptcha_challenge_field').val(),
        recaptcha_response_field: field.val()
      });	
    }
    */

  };

});
