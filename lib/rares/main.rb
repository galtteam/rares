require 'fileutils'

require_relative 'modules/text_file'
require_relative 'modules/input'
require_relative 'modules/shell'

require_relative 'exceptions/exit'

module Rares
  class Main
    include Rares::Modules::TextFile
    include Rares::Modules::Input
    include Rares::Modules::Shell

    attr_reader :recipe_folder, :current_dir, :current_file_path, :current_file_content, :current_indent

    def initialize(recipe_folder, project_dir)
      @recipe_folder = recipe_folder
      @current_dir = project_dir
      @current_file = nil
      @current_indent = 0
    end

    def perform
      files = Dir["#{recipe_folder}/recipe/**/*.rb"].sort

      puts "Could not found any recipe file" if files.size == 0
      files.each do |path|
        puts "Processing step: #{path}"

        begin
          eval_file(path)
        rescue Rares::Exceptions::Exit => e
          puts "Exiting... Reason: #{e.message}"
        end
      end
    end

    private

    def eval_file(path)
      eval File.new(path).read
    end
  end
end