FactoryBot.define do
  factory :user do
    nickname { 'テスト太郎' }
    sequence :email do |n|
      "test#{n}@example.com"
    end
    password { 'password' }
    password_confirmation { 'password' }
  end
end
