FactoryGirl.define do
  factory :user do
    first_name               "first"
    last_name               "last"
    user_type             User::USER_TYPE_TEACHER
    email                  "user@example.com"
    password               "password"
    password_confirmation  "password"
  end
end