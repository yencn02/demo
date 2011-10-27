module Admin::VideoFormatsHelper
  def options_for_association_conditions(association)
    if association.name == :video
      ["is_demo = 0"]
    else
      super
    end
  end
end
