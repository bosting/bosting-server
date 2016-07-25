class ApacheVariation < ApplicationRecord
  APACHE_VERSIONS = {
      1 => '1.3',
      2 => '2.0',
      3 => '2.2',
      4 => '2.4'
  }

  PHP_VERSIONS = {
      1 => '5.0',
      2 => '5.1',
      3 => '5.2',
      4 => '5.3',
      5 => '5.4',
      6 => '5.5',
      7 => '5.6',
      8 => '5.7',
      9 => '7.0'
  }

  validates :name, :ip, :apache_version_id, :php_version_id, presence: true
end
