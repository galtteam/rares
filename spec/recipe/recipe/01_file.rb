file 'routes.rb' do
  api = <<~API
    namespace :api do
      namespace :v1 do
        resources :users
      end
    end
  API

  beginning = <<~BEG
    # this is the router file
  BEG

  put_to_beginning beginning
  put_to_end "puts Dir.pwd"

  replace_line "root 'welcome'", /root/

  indent 2 do
    put_after_line "resources :users", "draw do"
  end

  put_before_line api, "root"
end

file 'package.json' do
  indent 2 do
    put_after_line "\"second\",", "angular", 1
  end
end