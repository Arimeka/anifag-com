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

Dropzone.options.galleryDropzone =
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


$('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
  $gallery = $('#gallery-upload')

  if $gallery
    $current = $(e.target)

    if $current.attr('aria-controls') == 'tab2'
      $gallery.removeClass 'hide'
    else
      $gallery.addClass 'hide'

galleryFiles = document.getElementById('gallery-files')
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



