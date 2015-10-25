# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

addImage = (data) ->
  $list = $('ul#gallery-files')
  html = "<li data-id='#{data.id}'>
          <div class='form-group'>
            <input type='hidden' value='#{data.id}' name='article[gallery_files_attributes][#{data.rand}][id]' id='article_gallery_files_attributes_0_id'>
            <img class='img-thumbnail img-responsive' src='#{data.image}' alt=''>
          </div>
          <div class='form-group'>
            <input placeholder='Название файла' maxlength='255' size='0' class='form-control' type='text' value='' name='article[gallery_files_attributes][#{data.rand}][title]' id='article_gallery_files_attributes_0_title'>
          </div>
          <div class='form-group'>
            <textarea rows='5' maxlength='255' class='form-control' name='article[gallery_files_attributes][#{data.rand}][description]' id='article_gallery_files_attributes_0_description'></textarea>
            <div class='checkbox'>
              <label class='checkbox'>
                <input name='article[gallery_files_attributes][#{data.rand}][_destroy]' type='hidden' value='0'><input skip_check='true' type='checkbox' value='1' name='article[gallery_files_attributes][#{data.rand}][_destroy]' id='article_gallery_files_attributes_0__destroy'>
                <i class='fa fa-trash-o'></i>
              </label>
            </div>
          </div>
        </li>"

  $list.prepend(html)

dropZoneOpts =
  init: ->
    @on 'success', (file, response) ->
      addImage(response)
  maxFilesize: 4
  acceptedFiles: 'image/*'
  dictDefaultMessage: 'Перетащите файлы сюда для загрузки'
  dictFallbackMessage: "Ваш браузер не поддерживает технологию drag'n'drop"
  dictFallbackText: 'Воспользуйтесь кнопкой загрузки ниже'
  dictInvalidFileType: 'Неправильный тип файла'
  dictFileTooBig: 'Файл слишком большой. Размер файла {{filesize}} МБ превышает максимально допустимый {{maxFilesize}} МБ'

Dropzone.options.galleryDropzone = dropZoneOpts

galleryFiles = document.getElementById('gallery-files')
if galleryFiles
  sortable = Sortable.create(
                          galleryFiles,
                          {
                            onSort: (e) ->
                              $list = $(e.to)
                              map = {}
                              sortPath = $list.data('sort-path')

                              $list.find('li').each (index) ->
                                el = {}
                                el['placement_index'] = index
                                map[$(@).data('id')] = el

                              $.ajax
                                url: sortPath
                                method: 'PUT'
                                data: {'map': map}
                          }
                        )

$imageUploadModal = $('#uploadImage')
if $imageUploadModal && tinymce
  prepareContentImage = (data) ->
    "<div class=\"media\" id=\"#{data.id}\">
      <div class=\"pull-left\"><img class=\"media-object\" src=\"#{data.image}\" alt=\"\" width=\"250\" height=\"250\"></div>
      <div class=\"media-body\">
        <form class=\"edit_content_image\" id=\"edit_content_image_#{data.id}\" action=\"/backend/content/images/#{data.id}\" accept-charset=\"UTF-8\" data-remote=\"true\" method=\"post\">
          <input name=\"utf8\" type=\"hidden\" value=\"✓\">
          <input type=\"hidden\" name=\"_method\" value=\"patch\">
          <div class=\"form-group\">
            <input class=\"form-control\" type=\"text\" value=\"#{data.title}\" name=\"content_image[title]\" id=\"content_image_title\">
          </div>
          <div class=\"form-group\">
            <textarea rows=\"5\" maxlength=\"255\" class=\"form-control\" name=\"content_image[description]\" id=\"content_image_description\">
              #{data.description}
            </textarea>
          </div>
          <a class=\"btn btn-success insert-image\" data-url=\"#{data.url}\" data-title=\"#{data.title}\" data-description=\"#{data.description}\" href=\"#\">Вставить</a>
          <input type=\"submit\" name=\"commit\" value=\"Сохранить\" data-disable-with=\"Пожалуйста подождите...\" class=\"btn btn-primary\">
          <a class=\"pull-right btn btn-danger delete-image\" data-confirm=\"Вы уверены?\" data-remote=\"true\" rel=\"nofollow\" data-method=\"delete\" href=\"/backend/content/images/#{data.id}\">Удалить</a>
        </form>
      </div>
    </div>"

  addOneContentImage = (list, data) ->
    list.prepend(prepareContentImage(data))

  addAllContentImages = (list, data) ->
    result = ""
    $.each data, (index, value) ->
      html = prepareContentImage(value)
      result += html
    list.append(result)

  imageDropzoneOpts = dropZoneOpts

  imageDropzoneOpts.init = ->
    @on 'success', (file, response) ->
      $list = $imageUploadModal.find('#images .col-sm-12')
      addOneContentImage($list, response)
      @removeFile(file)

  Dropzone.options.imageDropzone = imageDropzoneOpts

  $imageList = $imageUploadModal.find('#images')
  $imageList.on 'click', '.insert-image', (e) ->
    e.preventDefault()
    data = $(@).data()
    tinymce.execCommand('mceInsertContent', false, "<img class=\"img-responsive\" src=\"#{data.url}\" alt=\"#{data.title}\">")

  $imageList.on 'ajax:success', '.delete-image', (e, data, status, xhr) ->
    $imageList.find(".media##{data.id}").remove()


  $imagesBlock = $imageList.find('.col-sm-12')
  $linkMore = $imageUploadModal.find('#more a')
  $linkMore.click (e) ->
    e.preventDefault()

    $link = $(@)
    $linkBlock = $link.closest('#more')
    $spinner = $linkBlock.find('.spinner')

    url = $link.attr('href')
    offset = $imagesBlock.find('.media').length
    $.ajax
      url: url,
      dataType: 'json',
      data: {offset: offset},
      beforeSend: ->
          $link.addClass('hide')
          $spinner.removeClass('hide')
    .done (data) ->
      $spinner.addClass('hide')
      $link.removeClass('hide')
      addAllContentImages $imagesBlock, data

