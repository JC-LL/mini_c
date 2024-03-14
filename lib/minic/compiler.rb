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
        dummy_visit(ast)
      rescue Exception => e
        puts e
        puts e.backtrace
      end
    end

    def parse filename
      info 0,"parsing file '#{filename}'"
      ast=Parser.new.parse filename
      info 1,"file parsed successfully ! AST in memory !"
      return ast
    end

    def gen_dot ast
      info 0,"generating dot"
      filename=DotGen.new.gen(ast)
      info 1,"generated file '#{filename}'"
    end

    def dummy_visit ast
      info 0,"dummy visit"
      Visitor.new.visit(ast)
    end
  end
end
