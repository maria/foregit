
FactoryGirl.define do

  # Decribe a resource of type :architecture downloaded from a Foreman instance.
  factory :resources do

    initialize_with do
      new.class.construct_from_response(attributes)
    end

    trait :id do
      sequence(:id) { |n| n}
    end

    trait :name do
      name ["i386", "x86_64"].sample
    end

    trait :timestamps do
      created_at    "2014-05-31T18:54:58Z"
      updated_at    "2014-05-31T18:54:58Z"
    end
  end

  factory :architectures, traits: [:id, :name, :timestamps]
end
