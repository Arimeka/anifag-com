$ ->
  $('.js-banner:visible').each ->
    $banner = $(@)
    position  = $banner.attr('id')
    maxWidth  = $banner.data('width')
    maxHeight = $banner.data('height')

    $.ajax
      url: "/banners/#{position}"
      dataType: 'json'
      success: (data) ->
        if data? && data.content?
          $banner.html data.content
