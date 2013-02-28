module ApplicationHelper
  def display_balance(balance)
   "<span #{balance.to_f < 0 ? "class=negative" : ""}>#{number_to_currency(balance)}</span>".html_safe
  end

  def first_of_next_month
    I18n.l(Time.now.next_month.beginning_of_month, format: :date)
  end
end
