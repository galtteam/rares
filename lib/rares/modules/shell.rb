module Rares
  module Modules
    module Shell
      def ensure_changes_commited!
        unless `git status`.include?("nothing to commit")
          raise Rares::Exceptions::Exit, "Commit your changes first"
        end
      end

      def copy_fixture(file_path, options={})
        fixture_path = "#{recipe_folder}/fixtures/#{file_path}"
        result_path  = "#{current_dir}/#{file_path}"

        return if File.file?(result_path) && !(options[:force] == true) && no?("The #{result_path} already exists. Override?")

        FileUtils.mkdir_p result_path.split("/")[0..-2].join("/")

        if File.file?(result_path)
          puts "Overrided #{file_path}"
        else
          puts "Created #{file_path}"
        end

        FileUtils.cp_r fixture_path, result_path, remove_destination: true
      end

      def run(command)
        command_with_cd = "cd #{current_dir} && #{command}"
        puts "Will execute: #{command_with_cd}"
        result = `#{command_with_cd}`
        puts result

        result
      end
    end
  end
end