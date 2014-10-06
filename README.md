Redmine Resources Management Plugin
============================
This plugin lets you manage your hardware resources

# Instalation
1. Go to your Redmine installation's plugins/ directory.
2. `git clone git@github.com:efigence/redmine_resources_management.git && cd ..`
3. `bundle exec rake redmine:plugins:migrate NAME=redmine_resources_management RAILS_ENV=production`
4. Restart server

# Usage
It is possible to add/updated/destroy/show devices. 
Every device has own Jurnal of Loans, you can rent your Device and set when must be returned.

# Notifications 
This plugin working with https://github.com/efigence/redmine_notifications to send notifications by smsapi and email.


# Requirements
Developed on Redmine 2.5.2

# License 

    Redmine resources management plugin
    Copyright (C) 2014  efigence S.A.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
