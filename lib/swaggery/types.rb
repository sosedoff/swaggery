module Swaggery
  module Types
    LICENSES = {
      "mit" => {
        name: "MIT",
        url: "htts://google.com"
      },
      "apache2" => {
        name: "Apache 2.0",
        url: "https://www.apache.org/licenses/LICENSE-2.0.html"
      }
    }

    CONTENT_TYPES = {
      "text" => "text/plain",
      "json" => "application/json"
    }

    NATIVE_TYPES = {
      NilClass   => "null",
      String     => "string",
      Integer    => "integer",
      TrueClass  => "boolean",
      FalseClass => "boolean",
      Float      => "number",
      Array      => "array",
      Hash       => "object"
    }

    def type_from_value(val)
      NATIVE_TYPES[val.class] || (fail "unknown type for: #{val.inspect}")
    end

    def convert_type(val, type)
      case type
      when "string"
        val.to_s
      when "integer"
        val.to_i
      when "float"
        val.to_f
      when "boolean"
        val.downcase == "true"
      end
    end

    def status_code(val)
      case val.to_i
      when 200..299
        "Success"
      when 300..399
        "Redirect"
      when 400..499
        "Error"
      when 500..599
        "Server Error"
      end
    end
  end
end