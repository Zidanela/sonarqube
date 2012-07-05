#
# Sonar, entreprise quality control tool.
# Copyright (C) 2008-2012 SonarSource
# mailto:contact AT sonarsource DOT com
#
# Sonar is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Sonar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with Sonar; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02
#
module PropertiesHelper

  def property_value(key, type, value)
    if type==PropertyType::TYPE_INTEGER
      text_field_tag key, value, :size => 10

    elsif type==PropertyType::TYPE_BOOLEAN
      check_box_tag key, "true", value=='true'

    elsif type==PropertyType::TYPE_FLOAT
      text_field_tag key, value, :size => 10

    elsif type==PropertyType::TYPE_STRING
      text_field_tag key, value, :size => 10

    elsif type==PropertyType::TYPE_METRIC
      select_tag key, options_grouped_by_domain(Metric.all.select{|m| m.display?}.sort_by(&:short_name), value, :include_empty => true)

    elsif type==PropertyType::TYPE_FILTER
      user_filters = options_key(value, ::Filter.find(:all, :conditions => ['user_id=?', current_user.id]).sort_by(&:id))
      shared_filters = options_key(value, ::Filter.find(:all, :conditions => ['(user_id<>? or user_id is null) and shared=?', current_user.id, true]).sort_by(&:id))

      filters_combo = select_tag key, option_group('My Filters', user_filters) + option_group('Shared Filters', shared_filters)
      filter_link = link_to message('widget.filter.edit'), {:controller => :filters, :action => :manage}, :class => 'link-action'

      "#{filters_combo} #{filter_link}"

    elsif type==PropertyType::TYPE_TEXT
      text_area_tag key, value, :size => '40x6'

    elsif type==PropertyType::TYPE_PASSWORD
      password_field_tag key, value, :size => 10

    else
      hidden_field_tag key
    end
  end

  def options_id(value, values)
    values.collect { |f| "<option value='#{f.id}'" + (value.to_s == f.id.to_s ? " selected='selected'" : "") + ">#{h(f.name)}</option>" }.to_s
  end

  def options_key(value, values)
    values.collect { |f| "<option value='#{h(f.key)}'" + (value.to_s == f.key ? " selected='selected'" : "") + ">#{h(f.name)}</option>" }.to_s
  end

  def option_group(name, options)
    options.empty? ? '' : "<optgroup label=\"#{h(name)}\">" + options + "</optgroup>"
  end

end
