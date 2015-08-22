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
                    SELECT * FROM
                      dblink('dbname=anifag_old',
                                    'SELECT * FROM tags')
                    AS tags_old(id integer,
                                name varchar(255));
                  SQL
    ActiveRecord::Base.connection.execute(convert_tag)

    restore_sequence = "SELECT setval('tags_id_seq', (SELECT MAX(id) FROM tags));"
    ActiveRecord::Base.connection.execute(restore_sequence)

    ActiveRecord::Base.connection.execute('TRUNCATE TABLE taggings;')
    convert_taggings = <<-SQL
                          INSERT INTO taggings
                          SELECT * FROM
                            dblink('dbname=anifag_old',
                                          'SELECT * FROM taggings')
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

    Article.find_each do |article|
      description = if article.title =~ /Weekly Vocaloid Ranking/
                      date = article.title[/Weekly Vocaloid Ranking \((.+)\)/, 1]
                      "Рейтинг вокалоидов за период #{date}"
                    else
                      sanitize(article.content, tags: []).gsub("\r", '').gsub("\n", '').truncate_words(1, separator: '.', omission: '.')
                    end
      article.seo_description = description
      article.seo_keywords = article.tag_list if article.seo_keywords.blank?
      article.save
    end
  end
end
