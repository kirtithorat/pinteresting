# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :oauth_member do
    uid "MyString"
    provider "MyString"
    member nil
  end
end
