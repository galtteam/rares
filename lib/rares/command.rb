require 'open-uri'
require 'zip'

module Rares
  class Command
    attr_reader :options

    DEFAULT_HOST = 'http://rampagerecipes.com'

    def initialize(options)
      @options = options
    end

    def run
      if options[:remote_id]
        id = options[:remote_id]
        directory = File.join Dir.pwd, "tmp", "rares", id
        FileUtils.rm_rf File.join Dir.pwd, "tmp", "rares"
        FileUtils.mkdir_p(directory)

        download_and_extract_recipe!(options[:remote_host] || DEFAULT_HOST, id, directory)

        Rares::Main.new(directory, Dir.pwd).perform
      elsif options[:local_path]
        puts "Using local folder #{options[:local_path]}"
        Rares::Main.new(options[:local_path], Dir.pwd).perform
      else
        puts "Should provide remote id or local path"
      end
    end

    private

    def download_and_extract_recipe!(host, id, directory)
      file_url = "#{host}/files/#{id}.zip"
      puts "Fetching #{file_url}"

      begin
        content = open(file_url)
      rescue Exception
        puts "Could not nownload the file"
        puts "1. File can be missing on server. Go to the web interface and create a new version"
        puts "2. You may try to upgrade the client. Run `gem update`"
        puts "3. Check your network connection"
        return
      end

      ::Zip::File.open_buffer(content) do |zip|
        zip.each do |entry|
          entry.extract(File.join(directory, entry.name))
        end
      end
    end
  end
end