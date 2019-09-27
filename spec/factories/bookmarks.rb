FactoryGirl.define do
  factory :url do
    account_id { 1 }
    name { 'hoge' }
    url {'http://www.hoge.com'}
  end

  factory :bookmark do
    url

    item_type 'url'
    account_id  '1'

    # factory :bookmark_with_url do
    #   ignore do
    #     name 'hoge'
    #     url 'http://www.hoge.com'
    #   end

    #   after(:create) do |bookmark, evaluator|
    #     create_list(:url, evaluator.name, bookmark: bookmark)
    #   end
    # end
  end
end