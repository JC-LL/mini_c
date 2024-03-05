module MiniC
  class Lexer
    # naive lexer
    def lex filename
      src=IO.read(filename)
      @line,@col=1,1
      tokens=[]
      while src.size!=0
        case src
        when /\A\n+/
          @line+=$&.size
          @col=1
        when /\A\s+/
          @col+=$&.size
        when /\Aint\b/
          tokens << Token.new(:int,$&,pos)
        when /\Amain\b/
          tokens << Token.new(:main,$&,pos)
        when /\Aif\b/
          tokens << Token.new(:if,$&,pos)
        when /\Aelse\b/
          tokens << Token.new(:else,$&,pos)
        when /\Awhile\b/
          tokens << Token.new(:while,$&,pos)
        when /\A\(/
          tokens << Token.new(:lparen,$&,pos)
        when /\A\)/
          tokens << Token.new(:rparen,$&,pos)
        when /\A{/
          tokens << Token.new(:lbrace,$&,pos)
        when /\A}/
          tokens << Token.new(:rbrace,$&,pos)
        when /\A\[/
          tokens << Token.new(:lbracket,$&,pos)
        when /\A\]/
          tokens << Token.new(:rbracket,$&,pos)
        when /\A\,/
          tokens << Token.new(:comma,$&,pos)
        when /\A\;/
          tokens << Token.new(:semicolon,$&,pos)
        when /\A\=\=/
          tokens << Token.new(:double_eq,$&,pos)
        when /\A\=/
          tokens << Token.new(:equ,$&,pos)
        when /\A\+/
          tokens << Token.new(:add,$&,pos)
        when /\A\-/
          tokens << Token.new(:sub,$&,pos)
        when /\A\*/
          tokens << Token.new(:mul,$&,pos)
        when /\A\//
          tokens << Token.new(:div,$&,pos)
        when /\A\|\|/
          tokens << Token.new(:or_bar,$&,pos)
        when /\A\&\&/
          tokens << Token.new(:and_bar,$&,pos)
        when /\A\d+\b/
          tokens << Token.new(:int_literal,$&,pos)
        when /\A\w+\b/
          tokens << Token.new(:identifier,$&,pos)
        else
          pos=show_next.pos
          raise "lexical error at #{pos} : #{src[0..20]}..."
        end
        src.delete_prefix!($&)
      end
      tokens
    end

    def pos
      [@line,@col]
    end
  end
end

if $PROGRAM_NAME==__FILE__
  MiniC::Lexer.new.lex ARGV.first
end
