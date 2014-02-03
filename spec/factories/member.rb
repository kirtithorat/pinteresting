FactoryGirl.define do

  factory :member do
    email "john@gmail.com"
    password "12345678"
    firstname "John"
    lastname  "Doe"
    location "United States"   
  end

  factory :board do
  #  association :member, factory: :member, strategy: :build
    name "Food Board"
    description "Get delicious food pics!"
    category "Food"
  #  member
  end

end
