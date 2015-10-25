# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$moreBlock = $('body.home .more')
if $moreBlock
  $button = $moreBlock.find('#load-more')
  $spinner = $moreBlock.find('.spinner')
  $feedBlock = $('.posts-feed')

  $button.click (e) ->
    e.preventDefault()

    url = $button.attr('href')
    offset = $feedBlock.find('article').length

    $.ajax
      url: url,
      dataType: 'json',
      data: {offset: offset},
      beforeSend: ->
          $button.addClass('hide')
          $spinner.removeClass('hide')
    .done (data) ->
      $spinner.addClass('hide')
      $button.removeClass('hide')
      result = ''
      $.each data, (index, value) ->
        html = HoganTemplates['articles/feed_article'].render(value)
        result += html
      $feedBlock.append(result)
