# frozen_string_literal: true

crumb :root do
  link 'Главная', root_path
end

crumb :hosting_server do |hosting_server|
  if hosting_server.persisted?
    the_link = edit_hosting_server_path(hosting_server)
  end
  link hosting_server.name || t('actions.hosting_server.create'), the_link
  parent :root
end

crumb :apache_variations do |hosting_server|
  link t('headers.apache_variations'), hosting_server_apache_variations_path(hosting_server)
  parent hosting_server
end

crumb :apache_variation do |hosting_server, apache_variation|
  link apache_variation.name || t('actions.apache_variation.create')
  parent :apache_variations, hosting_server
end

crumb :smtp_settings do |hosting_server|
  link t('headers.smtp_settings'), hosting_server_smtp_settings_path(hosting_server)
  parent hosting_server
end

crumb :smtp_setting do |hosting_server, smtp_setting|
  link smtp_setting.name || t('actions.smtp_setting.create')
  parent :smtp_settings, hosting_server
end
