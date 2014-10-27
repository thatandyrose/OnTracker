module ApplicationHelper
  def statues_for_select
    (Status.default_status_keys + Status.pluck(:key))
    .uniq
    .map{ |key| [key.to_s.titleize, key] }
  end

  def ticket_open_label(ticket)
    
    content_tag(:span, class: "label label-#{ticket.is_open? ? 'success' : 'danger'}") do
      "#{ticket.is_open? ? 'open' : 'closed'}"
    end

  end

  def ticket_status_label(ticket)
    
    content_tag(:span, class: 'label label-primary') do
      ticket.status.try(:label)
    end

  end
end
