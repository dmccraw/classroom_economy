# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store_manager do
    store_id nil
    user_id nil
    manage_level 1
    before(:save) do |store_manager|
      unless store_id
        store_manager.store_id = FactoryGirl.create(:store).id
      end
      unless user_id
        user_id = FactoryGirl.create(:user).id
      end
    end
  end
end
