class AuditLog < ApplicationRecord
  belongs_to :branch
  belongs_to :user
end
