
FactoryGirl.define do

  # Decribe Foreman resources like: architectures, hosts_groups to mock API responses
  factory :resources do

    trait :id do
      sequence(:id) { |n| n}
    end

    trait :name do
      name ["i386", "x86_64"].sample
    end

    trait :timestamps do
      created_at    { 1.day.ago }
      updated_at    { 1.hour.ago }
    end
  end

  factory :architectures, traits: [:id, :name, :timestamps]
end
