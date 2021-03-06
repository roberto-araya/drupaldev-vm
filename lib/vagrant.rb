require 'yaml'

# Recursively walk an tree and run provided block on each value found.
def walk(obj, &function)
    if obj.is_a?(Array)
      obj.map { |value| walk(value, &function) }
    elsif obj.is_a?(Hash)
      obj.each_pair { |key, value| obj[key] = walk(value, &function) }
    else
      obj = yield(obj)
    end
  end

# Resolve jinja variables in hash.
def resolve_jinja_variables(vconfig)
    walk(vconfig) do |value|
      while value.is_a?(String) && value.match(/{{ .* }}/)
        value = value.gsub(/{{ (.*?) }}/) { vconfig[Regexp.last_match(1)] }
      end
      value
    end
  end

# Return the combined configuration content all files provided.
def load_config(files)
    vconfig = {}
    files.each do |config_file|
      if File.exist?(config_file)
        optional_config = YAML.load_file(config_file)
        vconfig.merge!(optional_config) if optional_config
      end
    end
    resolve_jinja_variables(vconfig)
  end