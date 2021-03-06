$(function() {
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
       scroll: 4
   });
   
   $('.w-small').find('.carousel').jcarousel({
      vertical: true,
      visible: 7,
      scroll: 7
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
      $(this).find('.edit').stop(true, true).fadeIn(); 
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
                vertical: false
            });
            $(this).parents('.widget:eq(0)').find('.carousel:eq(0)').remove();
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
                vertical: true
            });
            $(this).parents('.widget:eq(0)').find('.carousel:eq(0)').remove();
            $(this).parents('.widget:eq(0)').find('.carousel li').hover(function() {
               $(this).find('.ico-star').show(); 
            }, function() {
               $(this).find('.ico-star').hide();
            });
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
      $(this).append('<a href="#" class="add-feed notext">Add feed</a>'); 
   });
   
   $('.carousel').each(function() {
      $(this).find('li:last').addClass('last'); 
   });
   
   $('.l-follow').live('click', function() {
      $(this).addClass('following'); 
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
	
	$('.tutorial .close').click(function() {
		$(this).parents('.tutorial').fadeOut(600);
		return false;
	});
	
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
	
	//Login Submit Button Effects
	$("#login .login-dd .submit, #sign-up .submit ").hover(function(){ $(this).toggleClass('submit-hover'); }).mousedown(function(){ $(this).addClass('submit-click')}).mouseup(function(){ $(this).addClass('submit-click'); });
	
	//Beta Access Submit Button Hover
	$("#sign-up .beta_access .submit-btn").hover(function(){ 
		$(this).toggleClass('submit-btn-hover');
	});
	
	//Beta Access Thanks Message
	$('#sign-up .beta_access .submit-btn').click(function(){ 
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
	 
	//Show error bar on Login buttton click
	$('.btn-login').click(function() {
		$('.error-bar').fadeIn();
		return false;
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
					
	function validateField(field) {
		//FULLNAME
		if (field.is('.field-fullname')) {
			if (field.val() != 0) {
				field.next().removeClass('invalid').addClass('valid').text('Ok! ').show();
			} else {
				field.next().removeClass('valid').addClass('invalid').text('Please enter full name!').show();
			};
		};
		//USERNAME
		if (field.is('.field-username')) {
			if (field.val() != 0) {
				field.next().removeClass('invalid').addClass('valid').text('Username available! ').show();
			} else {
				field.next().removeClass('valid').addClass('invalid').text('Sorry, already been taken!').show();
			};
		};
		//EMAIL 
		if (field.is('.field-email')) {
			if (isValidEmailAddress(field.val())) {
				field.next().removeClass('invalid').addClass('valid').text('Ok!').show();
			} else {
				field.next().removeClass('valid').addClass('invalid').text('Email has already been taken').show();
			};
		}; 
		//PASSWORD
		if (field.is('.field-password')) {
			if (field.val().length > 5) {
				field.next().removeClass('invalid').addClass('valid').text('Ok!').show();
			} else {
				field.next().removeClass('valid').addClass('invalid').text('Too short').show();
			};
		};
		//CONFIRM PASSWORD
		if (field.is('.field-confirm-password')) {
			if (field.val() == $('.field-password').val() && field.val() != '') {
				field.next().removeClass('invalid').addClass('valid').text('Ok!').show();
			} else {
				field.next().removeClass('valid').addClass('invalid').text('Passwords do not match').show();
			};
		}
		;
	};
	function isValidEmailAddress(emailAddress) {
		var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
		return pattern.test(emailAddress);
	};

		
	if ($('.btn-signup').length) {
		
			

	};



$("#sign_up").submit(function(){
dataString=$("#sign_up").serializeArray();
 $.ajax({
		type		: "POST",
		cache	: false,
		url		: "login.php",
		data		: dataString,
		success: function(data) {
			$.fancybox(data);
		}
	});
	return false;  
 });


	$('.popup .btn-finish').live('click', function() {
		$('#fancybox-close').click();
		$('#sign-up-box input[type="text"], #sign-up-box input[type="password"]').each(function() {
			validateField($(this));
		});
		return false;
	});

});

 // Cancel form submition, return false

 

 





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
