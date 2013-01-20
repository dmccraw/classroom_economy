module ApplicationHelper
  def display_balance(balance)
    display = "<span #{balance < 0 ? "class=negative" : ""}>#{number_to_currency(balance)}</span>".html_safe
    display
  end
end
