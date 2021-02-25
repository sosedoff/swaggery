require "json"

module Swaggery
  module Schema
    def enumify(options, type)
      result = (options || []).map do |value|
        convert_type(value.strip, type)
      end

      result.any? ? result : nil
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
        fail "invalid data for schema in #{path}"
      end
    end

    def example_from_file(path)
      data = JSON.load(File.read(path))

      case data
      when Hash
        data
      when Array
        data[0]
      else
        fail "invalid data for example in #{path}"
      end
    end

    def response_content_from_file(path)
      {
        schema:  schema_from_file(path),
        example: example_from_file(path)
      }
    end
  end
end