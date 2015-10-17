# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require fotorama
#= require photoswipe

$fotorama = $('.fotorama')
currentFotorama = undefined

openPhotoSwipe = (items, options) ->
  pswpElement = $('.pswp')[0]
  gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options)
  gallery.init()

  gallery.listen 'destroy', () ->
    currentFotorama.show gallery.getCurrentIndex() unless currentFotorama == undefined


photoswipeParseHash = (sParam) ->
  hash = window.location.hash.substring(1)
  sURLVariables = hash.split('&')
  sParameterName = undefined
  i = undefined
  i = 0
  while i < sURLVariables.length
    sParameterName = sURLVariables[i].split('=')
    if sParameterName[0] == sParam
      return if sParameterName[1] == undefined then true else sParameterName[1]
    i++

if $fotorama.length > 0
  pid = photoswipeParseHash('pid')
  gid = photoswipeParseHash('gid')

  if gid && pid
    optionshotoSwipe = {
        index: parseInt(pid, 10) - 1
    }

    openPhotoSwipe(window.galleryImages, optionshotoSwipe)

  $fotorama.on 'fotorama:ready', (e, fotorama) ->
    currentIndex = fotorama.activeIndex
    currentFotorama = fotorama

    $fotorama.on 'fotorama:showend', (e, fotorama, extra) ->
      currentIndex = fotorama.activeIndex

    $fotorama.on 'click', '.js-fullscreen', (e) ->
      e.preventDefault()

      optionshotoSwipe = {
        index: currentIndex
      }

      openPhotoSwipe(window.galleryImages, optionshotoSwipe)


