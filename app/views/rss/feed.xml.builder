xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss version: '2.0' do
  xml.channel do
    xml.title 'Anime Fag'
    xml.link root_url
    xml.description 'Новости аниме и манги.'
    xml.language 'ru'
    xml.copyright 'Anime Fag'
    xml.pubDate Time.now.to_s(:rfc822)

    xml.image do |i|
      i.url URI.join(root_url, image_path('logo.png'))
      i.title 'Anime Fag'
      i.link root_url
    end

    @posts.each do |f|
      xml.item do
        xml.title f.title
        xml.description f.seo_description
        xml.link article_url(f)
        xml.guid "articles/#{f.id}"
        xml.pubDate f.published_at.in_time_zone("Europe/Moscow").to_s(:rfc822)
        if f.main_image.present? && f.main_image.file?
          xml.enclosure url: f.main_image.url, type: f.main_image.file_content_type
        end
      end
    end

  end
end
