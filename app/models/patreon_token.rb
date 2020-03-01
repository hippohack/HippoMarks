class PatreonToken < ApplicationRecord

  def self.tokens
    order(updated_at: :desc).limit(1)[0]
  end

end
