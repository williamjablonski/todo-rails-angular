FactoryGirl.define do
  factory :bug do
	summary "My Summary"
	description "My description"
	priority "HIGH"
	user
  end
end
