module Swaggery
  class Options
    def initialize
      @options = {}

      @optparser = OptionParser.new do |opts|
        opts.on("--file=path", "Spec file") do |val|
          @options[:file] = val
        end

        opts.on("--output=name") do |val|
          @options[:output] = val
        end

        opts.on("--output-format=name") do |val|
          @options[:output_format] = val
        end

        opts.on("--api-version=version" "Set API version") do |val|
          @options[:spec_version] = val
        end

        opts.on("--api-license=name", "Set API license") do|val|
          @options[:spec_license] = val
        end

        opts.on("--api-server=server", "Set API server") do |val|
          @options[:server] = val
        end

        opts.on("--examples=path", "Path to examples") do |val|
          @options[:examples_path] = val
        end
      end

      @options[:output_format] ||= "json"
    end

    def parse
      @optparser.parse!
      @options
    end
  end
end