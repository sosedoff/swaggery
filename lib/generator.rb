require "./types"
require "./schema"

module Swaggery
  class Generator
    include Types
    include Schema

    def initialize(options = {})
      @options = options
      @lines   = File.readlines(options[:file]).map(&:strip)
    end

    def generate
      entry = nil
      entries = []
      section = nil

      doc = {
        openapi: "3.0.0",
        info: {
          license: LICENSES["apache2"],
        },
        servers: [],
        paths: {}
      }

      while line = @lines.shift do
        # Skip empty lines or comments
        next if line.empty? || line.start_with?("#")

        # Determine the first section
        if !section
          if line.split(" ").first == "INFO"
            section = "info"
            next
          end

          fail "invalid section: #{line}"
        end

        # Handle section attributes
        if section == "info"
          next if info_attribute(line, doc)
          section = "paths"
        end

        if request_definition?(line)
          # Complete the previous entry
          entries << entry if entry

          # Start a new entry
          request = line.split(" ", 3)
          method  = request.shift.downcase
          path    = request.shift
          summary = (request.shift || "").strip.sub(/^\|/, "").strip
          tags    = []

          if summary.empty?
            summary = path
          end

          summary.gsub!(/(![\w\d\-\_]+)/) do
            tags << $1[1..-1]
            ""
          end

          entry = {
            method:     method,
            path:       path,
            summary:    summary,
            parameters: [],
            responses:  {},
            tags:       tags
          }
        end

        # Parse comment
        if line.start_with?("-")
          entry[:description] ||= ""
          entry[:description] += "\n\n" if entry[:description]
          entry[:description] += line[1..-1].strip
        end

        # Parse input
        if line.start_with?(">")
          _, loc, name, type, *rest = line.split(" ")

          name, default = name.split("=")
          required = name.start_with?("*")
          type, options = type.split("=")

          if default
            default = convert_type(default, type)
          end

          entry[:parameters] << {
            in:          loc,
            name:        name.sub(/^\*/, ""),
            required:    required,
            description: rest.join(" ").sub(/^\|/, "").strip,
            schema: {
              type: type,
              default: default,
              enum: enumify(options&.split(","), type)
            }.compact
          }.compact
        end

        # Parse output
        if line.start_with?("<")
          _, status, content_type, file, *rest = *line.split(" ")

          description = rest.join(" ").strip
          if description.empty?
            description = status_code(status)
          end

          content = {}
          content[CONTENT_TYPES[content_type]] = {
            schema: schema_from_file(File.join(@options[:examples_path], file))
          }

          entry[:responses] ||= {}
          entry[:responses][status] = {
            description: description.strip.sub(/^\|/, "").strip,
            content: content
          }
        end
      end

      # Complete final entry
      entries << entry if entry

      entries.each do |entry|
        path   = entry[:path]
        method = entry[:method]

        doc[:paths][path] ||= {}
        doc[:paths][path][method] = {
          summary:     entry[:summary],
          description: entry[:description],
          parameters:  entry[:parameters],
          responses:   entry[:responses],
          tags:        entry[:tags]
        }.compact
      end

      JSON.pretty_generate(doc)
    end

    private

    def request_definition?(line)
      %w(GET POST PUT PATCH DELETE).include?(line.split(" ").first)
    end

    def info_attribute(line, doc)
      key, value = line.split(" ", 2)

      case key
      when "title"
        doc[:info][:title] = value
      when "version"
        doc[:info][:version] = value
      when "license"
        doc[:info][:license] = LICENSES[value]
      when "description"
        doc[:info][:description] = value
      when "server"
        name, description = value.split(" ")
        doc[:servers] << { url: name, description: description }
      else
        nil
      end
    end
  end
end