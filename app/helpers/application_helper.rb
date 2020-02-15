module ApplicationHelper

  def default_meta_tags
    {
      site: 'HippoMarks',
      title: 'Your bookmark bar anywhere',
      reverse: true,
      separator: '|',
      description: 'A bookmark bar that you can access from anywhere to change your browser.There is no need to repeat export and import anymore.',
      keywords: 'hippomarks,bookmarks,hippohack',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('favicon.png') },
        { href: image_url('favicon.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: 'HippoMarks',
        title: 'Your bookmark bar anywhere',
        description: 'A bookmark bar that you can access from anywhere to change your browser.There is no need to repeat export and import anymore.', 
        type: 'website',
        url: request.original_url,
        image: image_url('og.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@hippohack',
      },
      fb: {
        app_id: ''
      }
    }
  end
  
end
