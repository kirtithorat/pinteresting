FactoryGirl.define do

  factory :member do
    email "john@gmail.com"
    password "12345678"
    firstname "John"
    lastname  "Doe"
    location "United States"
  end

  factory :board do
    name "Food Board"
    description "Get delicious food pics!"
    category "Food"
    association :member, factory: :member #, strategy: :build
    # If the factory name is the same as the association name, the factory name 
    # can be left out and it can be declared as shown below
    # association :member
    # association :member can also be shorten as below
    # member
  end

  factory :pin do
    description "Flan"
   # image File.new(File.join(Rails.root, 'spec', 'support', 'google.png'))
    image File.new("#{Rails.root}/spec/support/google.png")
    board
  end

end
