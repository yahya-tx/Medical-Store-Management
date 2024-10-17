class Branch < ApplicationRecord
    belongs_to :user
    has_many :medicines, dependent: :destroy
    has_many :audit_logs, dependent: :destroy
    has_many :records, dependent: :destroy
    has_many :stock_transfers, dependent: :destroy
    has_many :users, dependent: :destroy
    validates :name, presence: true
    validates :location, presence: true
end

