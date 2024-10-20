class Medicine < ApplicationRecord
  belongs_to :branch
  validates :name, presence: true

  def self.update_expired_medicines
    where('expiry_date < ?', Date.today).update_all(expired: true)
  end
end
