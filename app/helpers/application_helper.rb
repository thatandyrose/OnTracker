module ApplicationHelper
  def statues_for_select
    defaults = [
      :waiting_for_staff_response,
      :waiting_for_customer_response,
      :on_hold,
      :cancelled,
      :completed
    ]

    (defaults + Status.pluck(:key)).uniq.map{ |key| [key.to_s.titleize, key] }
  end
end
