namespace :banners do
  desc 'Создание плейсментов для баннеров'
  task :create_placements do
    BannerPlacement.create([
      {
        title: 'Главная боковой блок сверху',
        selector: 'home-aside-banner-top'
      },
      {
        title: 'Галереи боковой блок сверху',
        selector: 'galleries-aside-banner-top'
      },
      {
        title: 'Видео боковой блок сверху',
        selector: 'videos-aside-banner-top'
      },
      {
        title: 'Публикации боковой блок сверху',
        selector: 'articles-aside-banner-top'
      },
      {
        title: 'Новость боковой блок сверху',
        selector: 'article-aside-banner-top'
      },
      {
        title: 'Главная в ленте снизу',
        selector: 'home-feed-footer-banner'
      },
      {
        title: 'Галереи в ленте снизу',
        selector: 'galleries-feed-footer-banner'
      },
      {
        title: 'Видео в ленте снизу',
        selector: 'videos-feed-footer-banner'
      },
      {
        title: 'Публикации в ленте снизу',
        selector: 'articles-feed-footer-banner'
      },
      {
        title: 'Новость в ленте снизу',
        selector: 'article-body-footer-banner'
      }
      ])
  end
end
