class Branch < ApplicationRecord
    belongs_to :user
    has_many :medicines
    has_many :audit_logs
    has_many :records
    has_many :stock_transfers
    has_many :users
end

