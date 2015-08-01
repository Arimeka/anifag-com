# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require cpb_fwslider
#= require photoswipe


openPhotoSwipe = (items, options) ->
  pswpElement = $('.pswp')[0]

  gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options);
  gallery.init();

if $('#cbp-fwslider').length > 0
  $('#cbp-fwslider a').on 'click', (e) ->
    e.preventDefault()
    $image = $(@)
    index = $('#cbp-fwslider a').index($image)

    items = $('#cbp-fwslider li').map () ->
              data = $(@).data()
              { src: data.src, w: data.width, h: data.height }

    options = { index: index }

    openPhotoSwipe(items, options)

  $( '#cbp-fwslider' ).cbpFWSlider()
