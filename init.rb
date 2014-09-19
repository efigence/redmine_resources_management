# encoding: utf-8
require 'redmine_resources_management'

Redmine::Plugin.register :redmine_resources_management do
  name 'Redmine Resources Management plugin'
  author 'Marcin Świątkiewicz'
  description 'This is a plugin for Redmine which lets you manage your devices'
  version '0.0.1'
  url 'https://github.com/efigence/redmine_resources_management'
  author_url 'http://efigence.com'

  menu :top_menu, :devices, { :controller => 'devices', :action => 'index' }, :caption => :label_resources_management,
    :if => proc {
      User.current.admin? ||
      !(User.current.groups.pluck(:id).map(&:to_s) & (Setting.plugin_redmine_resources_management['groups'] || [])).blank?
    }
  settings :default => {
    'per_page' => 10
    }, 
    :partial => 'settings/resources_management'
end