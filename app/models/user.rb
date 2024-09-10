class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :branch, optional: true
  has_many :audit_logs
  has_many :stock_transfers
  has_many :records

  enum :role, [ :super_admin, :branch_admin, :cashier, :customer ]
 
end
