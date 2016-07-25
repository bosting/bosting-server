class SmtpSetting < ApplicationRecord
  validates :name, :value, presence: true
end
