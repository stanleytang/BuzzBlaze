var Panels = {
    
    jQuery : $,
    
    settings : {
        columns : '.column',
        widgetSelector: '.widget',
        handleSelector: '.widget-head',
        contentSelector: '.widget-content',
        widgetDefault : {
            movable: true,
            removable: true,
            collapsible: true,
            editable: true,
            colorClasses : ['color-white', 'color-yellow', 'color-red', 'color-blue', 'color-orange', 'color-green']
        },
        widgetIndividual : {
            intro : {
                movable: false,
                removable: false,
                collapsible: false,
                editable: false
            }
        }
    },

    init : function () {
        this.attachStylesheet('css/panels.js.css');
        this.addWidgetControls();
        this.makeSortable();
    },

    init2 : function () {
        this.attachStylesheet('css/panels.js.css');
        this.addWidgetControls();
    },
    
    addWidgetControls : function () {
        var Panels = this,
            $ = this.jQuery,
            settings = this.settings;
            
        $(settings.widgetSelector, $(settings.columns)).each(function () {
            var thisWidgetSettings = Panels.getWidgetSettings(this.id);
            if (thisWidgetSettings.removable) {
                $('<a href="#" class="remove">CLOSE</a>').mousedown(function (e) {
                    e.stopPropagation();    
                }).click(function () {
                    if(confirm('This widget will be removed, ok?')) {
                        $(this).parents(settings.widgetSelector).animate({
                            opacity: 0    
                        },function () {
                            $(this).wrap('<div/>').parent().slideUp(function () {
                                $(this).remove();
                            });
                        });
                    }
                    return false;
                }).appendTo($(settings.handleSelector, this));
            }
            
            if (thisWidgetSettings.collapsible) {
                $('<a href="#" class="collapse">COLLAPSE</a>').mousedown(function (e) {
                    e.stopPropagation();    
                }).toggle(function () {
                    $(this).css({backgroundPosition: '-38px 0'})
                        .parents(settings.widgetSelector)
                            .find(settings.contentSelector).addClass('hidden');
                            $('.edit-box').hide();
                    return false;
                },function () {
                    $(this).css({backgroundPosition: '-52px 0'})
                        .parents(settings.widgetSelector)
                            .find(settings.contentSelector).removeClass('hidden');
                    return false;
                }).appendTo($(settings.handleSelector,this));
            }
            
            $(settings.handleSelector,this).append('<a href="#" class="refresh">Refresh</a>');
            
            if (thisWidgetSettings.editable) {
                $('<a href="#" class="edit">EDIT</a>').mousedown(function (e) {
                    e.stopPropagation();    
                }).toggle(function () {
                    $(this).css({backgroundPosition: '-80px 0', width: '55px'})
                        .parents(settings.widgetSelector)
                            .find('.edit-box').fadeIn().find('input').focus();
                    return false;
                },function () {
                    $(this).css({backgroundPosition: '', width: ''})
                        .parents(settings.widgetSelector)
                            .find('.edit-box').fadeOut();
                    return false;
                }).appendTo($(settings.handleSelector,this));
                $('<div class="edit-box" style="display:none;"/>')
                    .append('<h3>Edit Panel Settings</h3> <ul><li class="item"><label>Change title:</label><input value="' + $('h3',this).text() + '" /></li></ul>')
                    .append((function(){
                        var colorList = '<li class="item"><label>View</label> <span class="view"><a href="#" class="list-view">Full</a><a href="#" class="grid-view">Half</a></span></li><li class="item"><label>Color:</label><ul class="colors">';
                        $(thisWidgetSettings.colorClasses).each(function () {
                            colorList += '<li class="' + this + '"/>';
                        });
                        return colorList + '</ul>';
                    })())
                    .append('</ul>')
                    .insertAfter($(settings.handleSelector,this));
            }
        });
        
        $('.edit-box').each(function () {
            $('input',this).keyup(function () {
                if( $(this).parents('.widget').hasClass('w-small') == true ) {
                    $(this).parents(settings.widgetSelector).find('.widget-head h3').text( $(this).val().length>15 ? $(this).val().substr(0,15)+'...' : $(this).val() );
                }
                
                else {
                    $(this).parents(settings.widgetSelector).find('.widget-head h3').text( $(this).val().length>60 ? $(this).val().substr(0,58)+'...' : $(this).val() );
                }
                
                
            });
            $('ul.colors li',this).click(function () {
                
                var colorStylePattern = /\bcolor-[\w]{1,}\b/,
                    thisWidgetColorClass = $(this).parents(settings.widgetSelector).attr('class').match(colorStylePattern)
                if (thisWidgetColorClass) {
                    $(this).parents(settings.widgetSelector)
                        .removeClass(thisWidgetColorClass[0])
                        .addClass($(this).attr('class').match(colorStylePattern)[0]);
                }
                return false;
                
            });
        });
        
    },
    
    attachStylesheet : function (href) {
        var $ = this.jQuery;
        return $('<link href="' + href + '" rel="stylesheet" type="text/css" />').appendTo('head');
    },
    
    getWidgetSettings : function (id) {
        var $ = this.jQuery,
            settings = this.settings;
        return (id&&settings.widgetIndividual[id]) ? $.extend({},settings.widgetDefault,settings.widgetIndividual[id]) : settings.widgetDefault;
    },
    
    makeSortable : function () {
        var Panels = this,
            $ = this.jQuery,
            settings = this.settings,
            $sortableItems = (function () {
                var notSortable = '';
                $(settings.widgetSelector,$(settings.columns)).each(function (i) {
                    if (!Panels.getWidgetSettings(this.id).movable) {
                        if(!this.id) {
                            this.id = 'widget-no-id-' + i;
                        }
                        notSortable += '#' + this.id + ',';
                    }
                });
                return $('> li:not(' + notSortable + ')', settings.columns);
            })();
        
        $sortableItems.find(settings.handleSelector).css({
            cursor: 'move'
        }).mousedown(function (e) {
            $sortableItems.css({width:''});
            $(this).parent().css({
                width: $(this).parent().width() + 'px'
            });
        }).mouseup(function () {
            if(!$(this).parent().hasClass('dragging')) {
                $(this).parent().css({width:''});
            } else {
                $(settings.columns).sortable('disable');
            }
        });

        $(settings.columns).sortable({
            items: $sortableItems,
            connectWith: $(settings.columns),
            handle: settings.handleSelector,
            placeholder: 'widget-placeholder',
            forcePlaceholderSize: true,
            revert: 300,
            delay: 100,
            opacity: 0.8,
            containment: 'document',
            start: function (e,ui) {
                $(ui.helper).addClass('dragging');
                if( $(ui.helper).hasClass('w-small') == true ) {
                    $(ui.placeholder).addClass('p-small');
                }
            },
            stop: function (e,ui) {
                $(ui.item).css({width:''}).removeClass('dragging');
                $(settings.columns).sortable('enable');
            }
        });
    }
  
};
