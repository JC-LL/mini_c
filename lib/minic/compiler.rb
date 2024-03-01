module MiniC
  class Compiler
    attr_accessor :options
    def initialize options={}
      @options=options
    end

    def compile filename
      parser=Parser.new
      ast=parser.parse(filename)
      pp ast
      DotGen.new.gen(ast)
    end
  end
end

if $PROGRAM_NAME==__FILE__
  compiler=MiniC::Compiler.new
  compiler.compile ARGV.first
end
