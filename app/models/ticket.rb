class Ticket < ActiveRecord::Base
  belongs_to :user

  default_scope { order(created_at: :desc) }
  scope :open, ->{ where(user_id:nil) }

  include FriendlyId
  friendly_id :generate_reference, use: :slugged

  def generate_reference
    sr = SecureRandom
    chrs = 3.times.map{ sr.urlsafe_base64(2) }
    hxs = 2.times.map{ sr.hex(1) }
    "#{chrs[0]}-#{hxs[0]}-#{chrs[1]}-#{hxs[1]}-#{chrs[2]}"
  end

  def reference
    self.slug
  end

  def is_open?
    user_id.nil?
  end

  def take_ownership! owner
    self.user = owner
    self.save!
  end
end
