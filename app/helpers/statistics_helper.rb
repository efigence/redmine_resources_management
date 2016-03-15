require 'string_case_pl'
require 'string_cmp_pl'

module StatisticsHelper
  def sorted_by(devices_hash)
    case params[:sort_by]
    when 'name'
      devices_hash.sort_by { |k, v| k[:name].downcase }
    when 'top'
      devices_hash.sort_by { |k, v| k[:top][:firstname] }
    else
      devices_hash.sort_by { |k, v| k[:count].to_i * (-1) }
    end
  end
end
