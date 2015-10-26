namespace :sql do
  desc 'Конвертирование старой базы в новую'
  task convert: :environment do
    include ActionView::Helpers::SanitizeHelper

    create_extension = 'CREATE EXTENSION IF NOT EXISTS dblink;'
    ActiveRecord::Base.connection.execute(create_extension)

    ActiveRecord::Base.connection.execute('TRUNCATE TABLE articles;')
    convert_articles = <<-SQL
                          INSERT INTO articles (
                            id,
                            title,
                            content,
                            category_id,
                            is_published,
                            is_video,
                            is_gallery,
                            source,
                            seo_slug,
                            seo_keywords,
                            seo_description,
                            published_at,
                            created_at,
                            updated_at
                          )
                          SELECT
                            id                            AS id,
                            title                         AS title,
                            content                       AS content,
                            NULL                          AS category_id,
                            TRUE                          AS is_published,
                            FALSE                         AS is_video,
                            FALSE                         AS is_gallery,
                            concat(source, '')            AS source,
                            permalink                     AS seo_slug,
                            ''                            AS seo_keywords,
                            ''                            AS seo_description,
                            created_at                    AS published_at,
                            created_at                    AS created_at,
                            updated_at                    AS updated_at
                          FROM
                            dblink('dbname=anifag_old',
                                    'SELECT id, title, content, source, permalink, created_at, updated_at FROM articles')
                          AS articles_old(id integer,
                                          title varchar(255),
                                          content text,
                                          source varchar(255),
                                          permalink varchar(255),
                                          created_at timestamp without time zone,
                                          updated_at timestamp without time zone)
                        SQL
    ActiveRecord::Base.connection.execute(convert_articles)

    restore_sequence = "SELECT setval('articles_id_seq', (SELECT MAX(id) FROM articles));"
    ActiveRecord::Base.connection.execute(restore_sequence)

    ActiveRecord::Base.connection.execute('TRUNCATE TABLE tags;')
    convert_tag = <<-SQL
                    INSERT INTO tags
                    SELECT id, name FROM
                      dblink('dbname=anifag_old',
                                    'SELECT id, name FROM tags')
                    AS tags_old(id integer,
                                name varchar(255));
                  SQL
    ActiveRecord::Base.connection.execute(convert_tag)

    restore_sequence = "SELECT setval('tags_id_seq', (SELECT MAX(id) FROM tags));"
    ActiveRecord::Base.connection.execute(restore_sequence)

    ActiveRecord::Base.connection.execute('TRUNCATE TABLE taggings;')
    convert_taggings = <<-SQL
                          INSERT INTO taggings
                          SELECT
                            id, tag_id, taggable_id, taggable_type, tagger_id, tagger_type, context, created_at
                          FROM dblink('dbname=anifag_old',
                                          'SELECT id, tag_id, taggable_id, taggable_type, tagger_id, tagger_type, context, created_at FROM taggings')
                          AS taggings_old(id integer,
                                          tag_id integer,
                                          taggable_id integer,
                                          taggable_type varchar(255),
                                          tagger_id integer,
                                          tagger_type varchar(255),
                                          context varchar(128),
                                          created_at timestamp without time zone);
                        SQL
    ActiveRecord::Base.connection.execute(convert_taggings)

    restore_sequence = "SELECT setval('taggings_id_seq', (SELECT MAX(id) FROM taggings));"
    ActiveRecord::Base.connection.execute(restore_sequence)

    ActiveRecord::Base.connection.execute('TRUNCATE TABLE categories;')
    convert_categories = <<-SQL
                            INSERT INTO categories
                            SELECT
                              id          AS id,
                              title       AS name,
                              created_at  AS created_at,
                              updated_at  AS updated_at
                            FROM
                              dblink('dbname=anifag_old',
                                            'SELECT id, title, created_at, updated_at FROM categories')
                            AS categories_old(id integer,
                                              title varchar(255),
                                              created_at timestamp without time zone,
                                              updated_at timestamp without time zone);
                          SQL
    ActiveRecord::Base.connection.execute(convert_categories)

    restore_sequence = "SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories));"
    ActiveRecord::Base.connection.execute(restore_sequence)

    ActiveRecord::Base.connection.execute('TRUNCATE TABLE category_articles;')
    convert_category_articles = <<-SQL
                                  INSERT INTO category_articles (
                                    id, article_id, category_id, created_at, updated_at
                                  )
                                  SELECT id, article_id, category_id, created_at, updated_at
                                  FROM dblink('dbname=anifag_old',
                                                  'SELECT id, article_id, category_id, created_at, updated_at FROM cat_associations')
                                  AS category_articles_old(id integer,
                                                          article_id integer,
                                                          category_id integer,
                                                          created_at timestamp without time zone,
                                                          updated_at timestamp without time zone);
                                SQL
    ActiveRecord::Base.connection.execute(convert_category_articles)

    restore_sequence = "SELECT setval('category_articles_id_seq', (SELECT MAX(id) FROM category_articles));"
    ActiveRecord::Base.connection.execute(restore_sequence)

    Category.find_by(name: 'новости').destroy

    Category.find_each do |category|
      category.name = category.name.mb_chars.capitalize.to_s
      category.save
    end

    Article.update_all("seo_description = replace(seo_description, ' ', ' ')")
    Article.update_all("content = replace(content, ' ', ' ')")
    Article.update_all("content = replace(content, 'style=\"text-align: justify;\"', '')")

    Article.update_all("content = replace(content, 'http://1.bp.blogspot.com', 'https://lh1.googleusercontent.com')")
    Article.update_all("content = replace(content, 'http://2.bp.blogspot.com', 'https://lh2.googleusercontent.com')")
    Article.update_all("content = replace(content, 'http://3.bp.blogspot.com', 'https://lh3.googleusercontent.com')")
    Article.update_all("content = replace(content, 'http://4.bp.blogspot.com', 'https://lh4.googleusercontent.com')")
    Article.update_all("content = replace(content, 'http://5.bp.blogspot.com', 'https://lh5.googleusercontent.com')")

    Article.where("title LIKE '%игурка%'").update_all(is_gallery: true)

    Article.find_each do |article|
      description = if article.title =~ /Weekly Vocaloid Ranking/
                      date = article.title[/Weekly Vocaloid Ranking \((.+)\)/, 1]
                      "Рейтинг вокалоидов за период #{date}"
                    else
                      sanitize(article.content, tags: []).gsub("\r", '').gsub("\n", '').truncate_words(1, separator: '.', omission: '.')
                    end
      article.seo_description = description
      article.seo_keywords = article.tag_list if article.seo_keywords.blank?
      article.category = article.categories.first
      article.save
    end

    Article.where("source != ''").find_each do |article|
      uri = URI.parse(article.source)
      name =  case uri.host
              when 'www.animenewsnetwork.com'
                'ANN'
              when 'www.moetron.com'
                'Moetron'
              when 'www.play-asia.com'
                'play-asia.com'
              end
      article.source_name = name
      article.save
    end
  end
end
