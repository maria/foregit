# Stub models in order to create factories for Foreman resources.
class Resources
end

class Architectures
    attr_writer :id, :name, :created_at, :updated_at
    attr_reader :id, :name, :created_at, :updated_at
end

class Settings
    attr_writer :api_url, :name, :created_at, :updated_at,
                :api_version, :consumer_key, :consumer_secret,
                :timeout, :api_user, :resources, :repo_path, :repo_branch,
                :repo_remote, :git_username, :git_useremail, :ignored_foreman_fields

    attr_reader :api_url, :name, :created_at, :updated_at,
                :api_version, :consumer_key, :consumer_secret,
                :timeout, :api_user, :resources, :repo_path, :repo_branch,
                :repo_remote, :git_username, :git_useremail, :ignored_foreman_fields

end
