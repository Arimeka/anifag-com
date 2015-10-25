tinymce.PluginManager.add('imageuploader', function(editor, url) {
    // Add a button that opens a window
    editor.addButton('imageuploader', {
        text: false,
        icon: 'upload',
        onclick: function() {
            $('#uploadImage').modal()
        }
    });

    // Adds a menu item to the tools menu
    editor.addMenuItem('imageuploader', {
        text: 'Upload image',
        icon: 'upload',
        context: 'insert',
        onclick: function() {
            $('#uploadImage').modal()
        }
    });
});

tinymce.addI18n('ru', {
    "Upload image": "Загрузить изображение"
});
