require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'is not be valid without item_type' do
    bookmark = Bookmark.new(item_type: '')
    expect(bookmark).not_to be_valid
  end
end


