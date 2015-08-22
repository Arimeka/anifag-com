# === Tagging
  datumTokenizer = (d) -> d.title

  # bootstrap-tokenfield for tags
  for tag_tokenizer in $('.tags-tokenizer').removeClass('.tags-tokenizer')
    do (tag_tokenizer) ->
      $tag_tokenizer = $(tag_tokenizer)
      taggable = $tag_tokenizer.data('taggable')

      tags = new Bloodhound(
        datumTokenizer: datumTokenizer
        queryTokenizer: (d) -> d
        remote: {
          url: "/backend/tags/#{taggable}.json?q=%QUERY",
          wildcard: '%QUERY'
        }
      )
      tags.clear(); tags.clearPrefetchCache(); tags.clearRemoteCache()
      tags.initialize()

      $tag_tokenizer.tokenfield(
        showAutocompleteOnFocus: true
        typeahead: {source: tags.ttAdapter(), displayKey: 'name'},
        onlyLowerCase: true
      )
# === ///Tagging
