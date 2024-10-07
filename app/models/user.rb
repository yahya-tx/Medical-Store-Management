class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  validates :phone_number, presence: true, uniqueness: true

  validates :email, uniqueness: true, allow_blank: true
  belongs_to :branch, optional: true
  has_many :audit_logs
  has_many :stock_transfers
  has_many :records
  has_many :notifications

  
  enum :role, [ :super_admin, :branch_admin, :cashier, :customer ]
 
end
