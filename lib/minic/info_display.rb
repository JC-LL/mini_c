module MiniC
  module InfoDisplay
    def info(level,str,other="")
      case level
      when 0
        space_bar=""
      when 1
        space_bar=" |-"
      else
        space_bar=" "*3*(level-1)+" |-"
      end
      str="#{space_bar}[+] #{str}"
      other="#{other}"
      if other.size > 0
        puts str.ljust(40,'.')+" #{other}"
      else
        puts str
      end
    end

    def step str=""
      puts str
      puts "hit_a_key"
      $stdin.gets
    end
  end
end
