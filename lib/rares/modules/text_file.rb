module Rares
  module Modules
    module TextFile
      def file(path, &block)
        @current_file_path = "#{current_dir}/#{path}"
        @current_file_content = File.file?(current_file_path) ? File.readlines(current_file_path) : []

        if File.file?(@current_file_path)
          puts "Will update file #{@current_file_path}"
        else
          puts "Will create file #{@current_file_path}"
        end

        yield

        File.open(current_file_path, "w+") do |f|
          f.puts(@current_file_content)
        end
      end

      def indent(value)
        if block_given?
          current_value = @current_indent
          @current_indent = value
          yield
          @current_indent = current_value
        else
          @current_indent = value
        end
      end

      def put_after_line(content, line_matcher, offset=0)
        current_file_content.each_with_index do |row, ind|
          if this_row?(row, line_matcher)
            indent = row.count(' ') - row.lstrip.count(' ') + current_indent
            add_content!(content, ind + offset + 1, indent)
            return
          end
        end
      end

      def put_before_line(content, line_matcher, offset=0)
        current_file_content.each_with_index do |row, ind|
          if this_row?(row, line_matcher)
            indent = row.count(' ') - row.lstrip.count(' ') + current_indent
            add_content!(content, ind + offset - 1, indent)
            return
          end
        end
      end

      def replace_line(content, line_matcher, offset=0)
        current_file_content.each_with_index do |row, ind|
          if this_row?(row, line_matcher)
            indent = row.count(' ') - row.lstrip.count(' ')
            add_content!(content, ind + offset, indent, true)
            return
          end
        end
      end

      def put_to_beginning(content, offset = 0)
        add_content!(content, offset, 0)
      end

      def put_to_end(content, offset = 0)
        add_content!(content, @current_file_content.size + offset, 0)
      end

      def clean_file!
        @current_file_content = []
      end

      private

      def this_row?(row, line_matcher)
        (line_matcher.is_a?(String) && row.include?(line_matcher)) ||
            (line_matcher.is_a?(Regexp) && line_matcher.match(row))
      end

      def add_content!(content, position, indent, replace_row=false)
        new_content = []

        if @current_file_content.size > 0 && @current_file_content.size > position
          @current_file_content.each_with_index do |row, ind|
            if position == ind
              content.split("\n").map { |r| ' ' * indent + r  }.each do |inserted_row|
                new_content << inserted_row
              end

              next if replace_row
            end

            new_content << row
          end
        elsif @current_file_content.size > 0 && @current_file_content.size <= position
          new_content = @current_file_content
          content.split("\n").map { |r| ' ' * indent + r  }.each do |inserted_row|
            new_content << inserted_row
          end
        else
          content.split("\n").map { |r| ' ' * indent + r  }.each do |inserted_row|
            new_content << inserted_row
          end
        end

        @current_file_content = new_content
      end
    end
  end
end