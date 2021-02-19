require "json"

module Swaggery
  module Schema
    def enumify(options, type)
      (options || []).map do |value|
        convert_type(value.strip, type)
      end
    end

    def object_schema(obj)
      {
        type: "object",
        properties: obj.keys.each_with_object({}) do |k, h|
          h[k] = {
            type: type_from_value(obj[k]),
            example: obj[k]
          }
        end
      }
    end

    def array_schema(items)
      {
        type: "array",
        items: object_schema(items[0])
      }
    end

    def schema_from_file(path)
      data = JSON.load(File.read(path))

      case data
      when Hash
        object_schema(data)
      when Array
        array_schema(data)
      else
        fail "invalid data for schema"
      end
    end
  end
end