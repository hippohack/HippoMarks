require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  # it 'ブックマークの保存' do
  #   bookmark = 
  # end

  describe "#hogehoge" do
    context "Factoryを作成した場合" do
      it "テストデータが作成される" do 
        model = FactoryGirl.create(:bookmark)

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
      parent_id: 2
    }
  }

  let(:bookmark) { Bookmark.new(params) }
  let(:params) { { account_id: 2, parent_id: 2, item_type: '' } }
  subject { bookmark }

  it 'is not be valid without item_type' do
    # bookmark = Bookmark.new(item_type: '')
    is_expected.not_to be_valid
  end

  it '10 - 1 は 9 になること' do
    expect(10 - 1).to eq 9
  end

  context 'ほげ' do
    before do
      @params.merge!(item_type: 'folder')
    end
    it 'ふが' do
      bookmark = Bookmark.new(hoge.merge(item_type: 'folder'))
      # bookmark = Bookmark.new(@params.merge(parent_id: 1))
      expect(bookmark.account_id).to be > 0
      expect(bookmark.parent_id).to be > 0
      expect(bookmark.item_type).to eq 'folder'
    end
  end

  describe '足し算' do
    it '1 + 1 は 2 になること' do
      expect(1 + 1).to eq 2
    end
  end
end


