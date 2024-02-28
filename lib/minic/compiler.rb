require_relative "parser"

module MiniC
  class Compiler
    def compile filename
      parser=Parser.new
      parser.parse filename
    end
  end
end

if $PROGRAM_NAME==__FILE__
  compiler=MiniC::Compiler.new
  compiler.compile ARGV.first
end
