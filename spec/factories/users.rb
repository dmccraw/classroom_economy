FactoryGirl.define do
  factory :user do
    first_name             { FactoryGirl.generate(:first_name) }
    last_name              { FactoryGirl.generate(:last_name) }
    user_type              User::USER_TYPE_TEACHER
    email                  { FactoryGirl.generate(:email_address) }
    password               "password"
    password_confirmation  "password"

    factory :student do
      user_type             User::USER_TYPE_STUDENT
    end

    factory :admin do
      user_type             User::USER_TYPE_ADMIN
    end
  end
end