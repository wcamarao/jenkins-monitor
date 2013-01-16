def get_json url
  sym_keys JSON.parse open(url).read
end

def config
  sym_keys YAML::load File.open 'config.yml'
end

def sym_keys hash
  return hash unless hash.is_a? Hash
  hash.inject({}) do |sym_hash, (key, value)|
    sym_hash[key.to_sym] =
    if value.is_a? Hash; sym_keys value
    elsif value.is_a? Array; value.map { |v| sym_keys v }
    else; value; end
    sym_hash
  end
end
