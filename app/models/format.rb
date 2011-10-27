class Format < ActiveRecord::Base
  validates_presence_of :name

  def before_update
    if id
      format = Format.find(id)
      fo = Format.find_by_format_order(format_order)
      unless fo.blank?
        Format.update_all("format_order = #{format.format_order}", "id = #{fo.id}")
      end
    end
  end

end
