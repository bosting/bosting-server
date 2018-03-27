# frozen_string_literal: true

class ApacheVariation < ApplicationRecord
  APACHE_VERSIONS = {
    1 => '1.3',
    2 => '2.0',
    3 => '2.2',
    4 => '2.4'
  }.freeze

  PHP_VERSIONS = {
    1 => '5.0',
    2 => '5.1',
    3 => '5.2',
    4 => '5.3',
    5 => '5.4',
    6 => '5.5',
    7 => '5.6',
    8 => '7.0',
    9 => '7.1',
    10 => '7.2'
  }.freeze

  validates :name, :ip, :apache_version_id, :php_version_id, presence: true
end
