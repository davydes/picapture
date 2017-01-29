# Это файл загружается после инициализации приложения
# см. config/application.rb
#
# Поменяем кое что в базовом контроллере Devise

DeviseController.class_eval do
  layout :select_layout

  # Накрываем метод, который отдает префикс для вьюшек
  # TODO: нам могут понадобиться отдельные вьюшки для режима полчения токена
  def _prefixes #:nodoc:
    @_prefixes ||= if self.class.scoped_views? && request && devise_mapping
      ["#{devise_mapping.scoped_path}/#{controller_name}"] + super
    else
      super
    end

    # Добавлено только это
    # таким образом мы можем сделать отдельные вьюхи devise для token_mode
    if token_mode?
      @_prefixes.unshift "#{devise_mapping.scoped_path}/token_mode/#{controller_name}"
    end

    @_prefixes
  end

  def select_layout
    if token_mode? then
      'token_mode'
    else
      'application'
    end
  end
end
