class OauthService
  attr_reader :auth_data

  def initialize(auth_data)
    raise ArgumentError if auth_data.nil?
    @auth_data = auth_data.kind_of?(Hash) ?
      OmniAuth::AuthHash.new(auth_data) :
      auth_data
  end

  def find_or_create_user
    user = authentication.try(:user)
    if user.nil?
      user = create_user
      create_authentication(user)
    end
    user
  end

  def create_user
    User.create! do |user|
      user.email = auth_data.info.email
      user.password = Devise.friendly_token[0,20]
      user.confirmed_at = Time.now
      #user.name = auth.info.name   # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
    end
  end

  def create_authentication(user)
    Authentication.create! do |a|
      a.user = user
      a.provider = auth_data.provider
      a.uid = auth_data.uid.to_s
    end
  end

  def need_to_bind?
    authentication.blank? && User.exists?(email: auth_data.info.email)
  end

  def binding_user
    User.find_by_email!(auth_data.info.email)
  end

  def authentication
    @authentication ||= Authentication.find_by(
      provider: auth_data.provider,
      uid: auth_data.uid.to_s
    )
  end
end
