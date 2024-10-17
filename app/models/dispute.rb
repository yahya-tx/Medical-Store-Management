class Dispute < ApplicationRecord
    belongs_to :customer, class_name: 'User'

    has_one_attached :attachment
  
    validates :reason, presence: true
    validates :attachment, presence: true
    enum :status, [ :pending, :approved, :denied]

end
