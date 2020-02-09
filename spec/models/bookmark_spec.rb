require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  
  describe '#save_bookmark?' do
    context 'nameとurlが存在する' do
      it 'true返す' do
        bookmark = Bookmark.create(name: 'site name', url: 'https://www.site_name.test')

        true if bookmark.name.present? && bookmark.url.present?
      end
    end

    context 'namaなし' do
      it 'return false' do
      end
    end

    context 'urlなし' do
      it 'return false' do
      end
    end
  end


  let!(:bookmark) { Bookmark.new(params) }
  let!(:params) {
    { account_id: 2, name: "hoge", url: 'https://www.hoge.fuga' }
  }

  describe "#hogehoge" do
    it 'ブックマークの保存' do
      FactoryBot.define do
        factory :bookmark do
          name { "John" }
          url { "https://hoge.doe.test" }
        end
      end
      
      # subject { bookmark }
    
      p bookmark
    end
  end

  describe "#hogehoge" do
    context "Factoryを作成した場合" do
      it "テストデータが作成される" do 
        model = build(:bookmark)

        p model
      end
    end
  end

  before do
    @params = { account_id: 1 }
  end

  let(:hoge) {
    {
      account_id: 2,
    }
  }

  it 'is not be valid without item_type' do
    # bookmark = Bookmark.new(item_type: '')
    is_expected.not_to be_valid
  end

  it '10 - 1 は 9 になること' do
    expect(10 - 1).to eq 9
  end

  context 'ほげ' do
    before do
      @params.merge!(name: 'hoge')
    end
    it 'ふが' do
      bookmark = Bookmark.new(hoge.merge(url: 'folder'))
      # bookmark = Bookmark.new(@params.merge(parent_id: 1))
      expect(bookmark.account_id).to be > 0
    end
  end

  describe '足し算' do
    it '1 + 1 は 2 になること' do
      expect(1 + 1).to eq 2
    end
  end
end

RSpec.describe '四則演算' do
  it '1 + 1 は 2 になること' do
    expect(1 + 1).to eq 2
  end
end

