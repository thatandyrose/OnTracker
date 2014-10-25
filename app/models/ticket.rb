class Ticket < ActiveRecord::Base
  belongs_to :user

  default_scope { order(created_at: :desc) }
  scope :open, ->{ where(user_id:nil) }

  def is_open?
    user_id.nil?
  end

  def take_ownership! owner
    self.user = owner
    self.save!
  end
end
