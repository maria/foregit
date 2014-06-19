# Stub models in order to create factories for Foreman resources.
class Resources
end

class Architectures
    attr_writer :id, :name, :created_at, :updated_at
    attr_reader :id, :name, :created_at, :updated_at
end
