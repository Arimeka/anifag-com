# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

generateSrc = (src, string) ->
  if src.match(/\?/)
    result = src + '&' + string
  else
    result = src + '?' + string

generateVideoJSTag = (object, src) ->
  if src.match(/(youtube)|(youtu.be)/)
    $parent = object.parent()
    object.remove()

    $parent.append("
      <video controls='controls' preload='auto' width='auto' height='auto'
        class='vidbox video-js vjs-default-skin'
        data-setup='{&quot;controls&quot;: true, &quot;techOrder&quot;: [&quot;youtube&quot;], &quot;src&quot;: &quot;#{generateSrc(src, 'rel=0&amp;amp;controls=0&quot;')} }'>
      </video>'
    ")
  else
    object.addClass('embed-responsive-item')

$('article.content .body object, article.content .body iframe, .main-video object, .main-video iframe').each ->
  $object = $(this)
  src = $object.find('embed').attr('src') || $object.attr('src')
  $object.wrap('<div class="embed-responsive embed-responsive-16by9"></div>')

  generateVideoJSTag($object, src)
