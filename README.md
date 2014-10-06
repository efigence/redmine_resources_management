Redmine Resources Management Plugin
============================
This plugin lets you manage your hardware resources.
This plugin work with other plugins, see source code for more informations.

# Instalation
1. Go to your Redmine installation's plugins/ directory.
2. `git clone git@github.com:efigence/redmine_resources_management.git && cd ..`
3. `bundle exec rake redmine:plugins:migrate NAME=redmine_resources_management RAILS_ENV=production`
4. Restart server
5. Before start using make sure that you have [Redmine Notifications Plugin](https://github.com/efigence/redmine_notifications)

# Usage
Create your own Devices list and manage it. 
Every device has own journal of loans, you can rent your device and set when must be returned, moreover you can set reminder by email or phone with what time ealier you want sent. For more info see paragraph Notifications


# Notifications 
This plugin working with  [Redmine Notifications Plugin](https://github.com/efigence/redmine_notifications) to send notifications by smsapi and email.


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
