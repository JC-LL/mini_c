module MiniC
  class Compiler
    include InfoDisplay
    attr_accessor :options,:ast
    def initialize options={}
      @options=options
    end

    def compile filename
      begin
        ast=parse(filename)
        gen_dot(ast)
      rescue Exception => e
        puts e
        puts e.backtrace
      end
    end

    def parse filename
      info 0,"parsing file '#{filename}'"
      Parser.new.parse filename
      info 1,"file parsed successfully ! AST in memory !"
    end

    def gen_dot ast
      info 0,"generating dot"
      filename=DotGen.new.gen(ast)
      info 1,"generated file '#{filename}'"
    end
  end
end

if $PROGRAM_NAME==__FILE__
  compiler=MiniC::Compiler.new
  compiler.compile ARGV.first
end
