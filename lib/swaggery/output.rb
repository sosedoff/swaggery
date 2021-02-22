require "json"
require "yaml"

module Output
  def print_output(doc, format, target)
    result = format_output(doc, format)

    case target
    when String
      STDERR.puts("writing output to #{target}")
      File.write(target, result)
    else
      STDOUT.puts(result)
    end
  end

  def format_output(doc, format)
    case format.downcase
    when "json"
      JSON.pretty_generate(doc)
    when "yaml", "yml"
      # Seems like YAML output needs to have stringified keys?
      YAML.dump(doc)
    else
      fail "Invalid format"
    end
  end
end