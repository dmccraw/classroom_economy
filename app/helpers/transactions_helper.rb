module TransactionsHelper
  def accounts_for_select(accounts, add_all_class = false, self_account_id = nil)
    store_accounts = []
    user_accounts = []
    accounts.each do |account|
      if account.user?
        user_accounts << account
      elsif account.store?
        store_accounts << account
      end
    end

    result = ""
    result += "<optgroup label='Students'>".html_safe if user_accounts.any?
    user_accounts.each do |store_account|
      unless store_account.id == self_account_id
        result += "<option value='#{store_account.id}'>#{store_account.display_name}</option>"
      end
    end
    result += "</optgroup>".html_safe if user_accounts.any?
    result += "<optgroup label='Stores'>".html_safe if store_accounts.any?
    store_accounts.each do |store_account|
      unless store_account.id == self_account_id
        result += "<option value='#{store_account.id}'>#{store_account.display_name}</option>"
      end
    end
    result += "</optgroup>".html_safe if user_accounts.any?

    result += "<option value='-1'>Entire Class</option>" if add_all_class
    result.html_safe
  end
end