namespace :content do
  desc 'Конвертирование верхних изображений из контента в заглавные'
  task :convert_main_images do
  #   s3 = Fog::Storage.new(
  #                         provider: 'AWS',
  #                         region: 'eu-central-1',
  #                         aws_access_key_id: 'key',
  #                         aws_secret_access_key: 'secret'
  #                       )
    Article.includes(:main_image).find_each do |post|
      unless post.main_image.present?
        content = Nokogiri::HTML(post.content)
        img = content.at_css('img')
        src = img['src']
        if img.parent.name == 'a'
          img = img.parent
          src = img['href']
        end
        src.gsub!('../', '')
        uri = URI.parse(src)
        unless uri.host
          if uri.path[0] != '/'
            uri.path = '/' + uri.path
          end
          uri.host = 'localhost'
          uri.port = '3000'
          uri.scheme = 'http'
        end

        post.build_main_image
        begin
          post.main_image.file = URI.parse(uri.to_s)
        rescue OpenURI::HTTPError
          s = uri.to_s.gsub('https://lh1.googleusercontent.com', 'http://1.bp.blogspot.com')
                      .gsub('https://lh2.googleusercontent.com', 'http://2.bp.blogspot.com')
                      .gsub('https://lh3.googleusercontent.com', 'http://3.bp.blogspot.com')
                      .gsub('https://lh4.googleusercontent.com', 'http://4.bp.blogspot.com')
                      .gsub('https://lh5.googleusercontent.com', 'http://5.bp.blogspot.com')
          begin
            post.main_image.file = URI.parse(s)
          rescue OpenURI::HTTPError
            next
          end
        end
        img.remove
        post.content = content.at_css('body').children.to_html
        post.save
      end
    end
  end

  desc 'Конвертирование изображений из контента в галереи'
  task :convert_galleries do
    Article.includes(gallery_files: :article).gallery.find_each do |post|
      unless post.gallery_files.present?
        content = Nokogiri::HTML(post.content)
        imgs = content.css('img')
        imgs.each do |img|
          src = img['src']
          if img.parent.name == 'a'
            img = img.parent
            src = img['href']
          end
          src.gsub!('../', '')
          uri = URI.parse(src)
          unless uri.host
            if uri.path[0] != '/'
              uri.path = '/' + uri.path
            end
            uri.host = 'localhost'
            uri.port = '3000'
            uri.scheme = 'http'
          end

          gallery_file = post.gallery_files.build
          begin
            gallery_file.file = URI.parse(uri.to_s)
          rescue OpenURI::HTTPError
            s = uri.to_s.gsub('https://lh1.googleusercontent.com', 'http://1.bp.blogspot.com')
                        .gsub('https://lh2.googleusercontent.com', 'http://2.bp.blogspot.com')
                        .gsub('https://lh3.googleusercontent.com', 'http://3.bp.blogspot.com')
                        .gsub('https://lh4.googleusercontent.com', 'http://4.bp.blogspot.com')
                        .gsub('https://lh5.googleusercontent.com', 'http://5.bp.blogspot.com')
            begin
              gallery_file.file = URI.parse(s)
            rescue OpenURI::HTTPError
              next
            end
          end
          if gallery_file.save
            img.remove
          end
        end
        post.content = content.at_css('body').children.to_html
        post.save
      end
    end
  end
end
