module ActiveRecord
  module Slugify
    module ClassMethods
      def slugify(attribute, slug_attribute = :slug, callback = :before_validation)
        send(callback) do |object|
          if object.respond_to?(slug_attribute) && object.respond_to?(attribute)
            object.send("#{slug_attribute}=", object.send(attribute).to_s.parameterize)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :extend, ActiveRecord::Slugify::ClassMethods