module DogsHelper
  def current_user_the_owner?(dog_owner_id)
    return false if current_user.nil?
    @current_user_the_owner ||= current_user.id == dog_owner_id
  end
end
