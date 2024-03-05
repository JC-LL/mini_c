module MiniC
  class Code
    attr_accessor :indent,:lines
    def initialize
      @indent=0
      @lines=[]
    end

    def <<(e)
      case e
      when Code
        e.lines.each{|line| dump(line)}
      when String
        dump(e)
      end
    end

    def dump line
      @lines << " "*@indent+line
    end

    def finalize
      @lines.join("\n")
    end

    def save_as filename
      File.open(filename,'w'){|f| f.puts finalize}
    end
  end
end
