# Rares

Rares is a client for the RampageRecipes server.

Currently each mainstream programming language has its own package manager. And developers can create an unique solutions and wrap them to packages, libraries, gems, whatever.

Usually this is a small solution which can be configured for solving some unique issues. And usually those libraries solve some technical issues: compress image, integration with any search engine, some third-party API clients and so on.

However it's kind of rare case when package contains a business logic. This is because each business case are unique and it's imposible to write some unique solution. It will have a lot of configurations. Its code will be to complex. It will have a lot of redundant code.

So, what is a RampageRecipe. Just imagine, that you have a good written article about how to solve you issue and you can intall this solution from article in few clicks. This is what recipes do.

Recipes are written in specific format, which allows you update and add it to you code in few minutes. The RampageRecipes server provides you a web interface for rapid recipes editing.

### Pros:
 1. Comparing to other configurators you will see what exactly the recipe will change.
 2. You can modify recipe in few clicks and append it to your own needs
### Cons:
 1. Because of using eval you need to check the code written by other person

Please visit an [official repository](http://rampagerecipes.com) to find some usefull recipes.

## Installation

    $ gem install rares

## Usage

Download and apply recipe from [official repository](http://rampagerecipes.com)

    $ rares -r <unique_hash>

Download and apply recipe from your own repository

    $ rares -r <unique_hash> -s http://youdomain.com

Apply recipe from local folder

    $ rares -l /home/user/recipes/install_rails

## Writing recipes

* recipe root/
  * doc/
    * 01_install_rails.md
    * 02_install_new_gems.md
  * fixtures/
    * any_folder/
      * file0.txt
    * file1.txt
  * recipe/
    * 01_install_rails.rb
    * 02_install_new_gems.rb

The `recipe` folder contains the performed steps. It's recommended to split your recipe to some logical steps, because users will be able to turn on/off them on frontend.

The `doc` folder should have documents for each recipe file with the same name as files from the recipe folder. Should use the markdown language

The `fixtures` folder contains files wich will be copied as is

## Recipe DSL

### Check git status

It's usefull to have commited changes before running the recipe. You can force it with the next command:

```ruby
ensure_changes_commited!
```
### Working with shell

You can ask user to enter any data:

```ruby
ruby_version = ask("Please enter the desired ruby version")
pust "ok" if yes?("You sure")
pust "ok" unless no?("You sure")
```

You can run any shell command

```ruby
result = run "echo 'hello' > hello_world.txt"
```

Also you can copy the fixture file. It will create the same file and reproduce the fixture path in current directory

```ruby
copy_fixture "config/locales/ch.yml"
```

### Patching existing file or creatind a new one.

First you should define which file you want to change with

```ruby
file 'routes.rb' do
  # do some things
end
```

Then inside file block you can manipulate with file. The first argument is alway an inserted content. The second one is a line matcher, which can be string or regext. Please note that the line matcher should match only a single line.

```ruby
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

file '.ruby-version' do
  clean_file!
  put_to_beginning "2.5.3"
end
```

Each method also can receive the offset. But try to avoid this. Example below will show how to add new line before the last_ ne.

```ruby
file 'test.txt' do
  put_to_end "Hello", -1
end
```



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/c3gdlk/rares. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rares project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/c3gdlk/rares/blob/master/CODE_OF_CONDUCT.md).
