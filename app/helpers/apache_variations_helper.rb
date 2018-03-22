# frozen_string_literal: true

module ApacheVariationsHelper
  def apache_version_name(apache_variation)
    ApacheVariation::APACHE_VERSIONS[apache_variation.apache_version_id]
  end

  def php_version_name(apache_variation)
    ApacheVariation::PHP_VERSIONS[apache_variation.php_version_id]
  end
end
