
FactoryGirl.define do

  factory :settings do

    api_url         'http://api.foreman'
    api_version      2
    consumer_key    'key'
    consumer_secret 'secret'
    timeout          2
    api_user        'admin'
    resources       'architectures'
    repo_path       '/home/user/foregit/'
    repo_branch     'master'
    repo_remote     'git@github.com:myusername/foregit.git'
    git_username    'myusername'
    git_useremail   'myusername@mail.org'
    ignored_foreman_fields ['created_at', 'updated_at']

  end

end
