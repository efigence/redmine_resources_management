# encoding: utf-8
require 'redmine_resources_management'

Redmine::Plugin.register :redmine_resources_management do
  name 'Redmine Resources Management plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  menu :top_menu, :devices, { :controller => 'devices', :action => 'index' }, :caption => :label_resources_management,
    :if => proc {
      User.current.admin? ||
      !(User.current.groups.pluck(:id).map(&:to_s) & (Setting.plugin_redmine_resources_management['groups'] || [])).blank?
    }
  settings :default => {'empty' => true}, :partial => 'settings/resources_management'
end