module Rares
  module Modules
    module Input
      def ask(message)
        puts message
        gets.strip
      end

      def yes?(message)
        loop do
          answer = ask("#{message} [yn]").downcase
          next if answer.size == 0
          return true if answer.include?('y')
          return false if answer.include?('n')
        end

      end

      def no?(message)
        !yes?(message)
      end
    end
  end
end