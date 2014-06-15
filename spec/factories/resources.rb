
FactoryGirl.define do

  # Decribe Foreman resources like: architectures, hosts_groups to mock API responses
  factory :architectures do

    id            1
    name          ["i386", "x86_64"].sample
    created_at    { Time.new - Time.new.day }
    updated_at    { Time.new - Time.new.min }

  end

end
