module Swaggery
  module Parser
    include Types

    SECTION_INFO  = "info"
    SECTION_PATHS = "paths"

    def parse_license_attribute(line)
      return LICENSES[line] if LICENSES.key?(line)

      name, url = line.to_s.split(" ", 2).map(&:strip)

      if name.to_s.empty?
        syntax_error("License name is expected", line)
      end

      {
        name: name,
        url:  url
      }
    end

    def parse_server_attribute(line)
      name, description = line.split(" ", 2).map(&:strip)

      if name.to_s.empty?
        syntax_error("Server URL attribute is expected", line)
      end

      if description.to_s.empty?
        syntax_error("Server description attribute is expected", line)
      end

      {
        url:         name,
        description: description
      }
    end

    def syntax_error(msg, data)
      raise(SyntaxError, "#{msg}: #{data.inspect}")
    end
  end
end