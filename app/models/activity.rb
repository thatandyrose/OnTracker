class Activity < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  belongs_to :ticket
  belongs_to :comment

  validates_presence_of :activity_type
  validates_presence_of :ticket
  validates_presence_of :user_name

  default_scope { order(created_at: :asc) }

  def is_comment?
    self.comment_id.present?
  end

  def activity_type_message
    if !self.is_comment?
      
      case self.activity_type
      
      when 'create'
        "created a new ticket"

      when 'own'
        "took ownership of the ticket"

      when 'status_change'
        "changed the ticket status to #{self.ticket.status.label}"        

      when 'close'
        "closed the ticket"

      when 'open'
        "opened the ticket"
      end

    else

      "created a comment"

    end
  end

  def message
    "#{self.user_name} #{activity_type_message} #{time_ago_in_words(self.created_at)} ago"
  end
end
