module GroupsHelper
  def display_store_owners(store)
    store.store_owners.map { |so| so.user.display_name }.join(", ")
  end
end
