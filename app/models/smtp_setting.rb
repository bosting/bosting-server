# frozen_string_literal: true

class SmtpSetting < ApplicationRecord
  validates :name, :value, presence: true
end
