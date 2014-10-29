class Status < ActiveRecord::Base
  
  validates_presence_of :key, message: 'Key or label required.'

  before_validation :try_key
  before_create :try_label

  def self.closed_status_keys
    ['cancelled', 'completed']
  end

  def self.default_status_keys
    [
      'waiting_for_staff_response',
      'waiting_for_customer_response',
      'on_hold',
      'cancelled',
      'completed'
    ]
  end

  private

  def try_key
    self.key ||= self.label.urlify.gsub('-','_') if self.label.present?
  end

  def try_label
    self.label ||= self.key.to_s.titleize if self.key.present?
  end
end
