module DeviseMacroses
  def mapping_user
    before { request.env["devise.mapping"] = Devise.mappings[:user] }
    after  { request.env["devise.mapping"] = nil }
  end
end
