module ActiveRecord
  class Base
    class << self
      include Geokit::Geocoders

      def validates_format_of_zipcode(*attr_names)
        validates_each(attr_names, {}) do |record, attr_name, value|
          if value && !value.blank?
            poll = true
            if record.id
              old_record = record.class.find record.id
              poll = false if old_record.zipcode == record.zipcode
            end
            if poll
              loc = MultiGeocoder.geocode(value)
              record.errors.add_to_base("Zipcode does not exist.") unless loc.success
            end
          end
        end
      end

      def validates_format_of_url(*attr_names)
        require 'uri/http'

        configuration = { :on => :save, :schemes => %w(http https) }
        configuration.update(attr_names.extract_options!)

        allowed_schemes = [*configuration[:schemes]].map(&:to_s)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          begin
            uri = URI.parse(value)

            if !allowed_schemes.include?(uri.scheme)
              raise(URI::InvalidURIError)
            end

            if [:scheme, :host].any? { |i| uri.send(i).blank? }
              raise(URI::InvalidURIError)
            end

          rescue URI::InvalidURIError => e
            record.errors.add(attr_name, :invalid, :default => configuration[:message], :value => value)
            next
          end
        end
      end

    end
  end
end