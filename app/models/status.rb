class Status < ActiveRecord::Base
  
  validates_presence_of :key, message: 'Key or label required.'

  before_validation :try_key
  before_create :try_label

  private

  def try_key
    self.key ||= self.label.urlify.gsub('-','_') if self.label.present?
  end

  def try_label
    self.label ||= self.key.to_s.titleize if self.key.present?
  end
end
