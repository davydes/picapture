module ApplicationHelper
  def auth_provider_to_css(provider)
    case provider.to_s
      when 'vkontakte'
        return 'vk';
      when 'google_oauth2'
        return 'google-plus';
      else
        return provider.to_s
    end
  end

  def page_title
    title = content_for?(:title) ? yield(:title) : I18n.t(:sitename)
    title = '[DEVELOP] ' + title if Rails.env.development?
    title = '[STAGING] ' + title if Rails.env.staging?
    title
  end
end
