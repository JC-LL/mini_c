require "optparse"

module MiniC
  class Runner
    def self.run *arguments
      new.run(arguments)
    end

    def run arguments
      compiler=Compiler.new
      compiler.options = args = parse_options(arguments)
      begin
        if filename=args[:c_file]
          ok=compiler.compile(filename)
        else
          raise "need a mini-c file : minic [options] <file.c>"
        end
        return ok
      rescue Exception => e
        puts e unless compiler.options[:mute]
        return false
      end
    end

    def header
      puts "Minic --  (#{VERSION})- (c) JC Le Lann 2024"
    end

    private
    def parse_options(arguments)

      parser = OptionParser.new

      no_arguments=arguments.empty?

      options = {}

      parser.on("-h", "--help", "Show help message") do
        puts parser
        exit(true)
      end


      parser.on("-v", "--version", "Show version number") do
        puts VERSION
        exit(true)
      end

      parser.parse!(arguments)

      header unless options[:mute]

      options[:c_file]=arguments.shift #the remaining c file

      if no_arguments
        puts parser
      end

      options
    end
  end
end
