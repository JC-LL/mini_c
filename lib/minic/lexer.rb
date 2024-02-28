require_relative "token"

module MiniC
  class Lexer
    def lex filename
      puts src=IO.read(filename)
      tokens=[]
      while src.size!=0
        case src
        when /\A\s+/
          #tokens << Token.new(:space,$&)
        when /\Aint\b/
          tokens << Token.new(:int,$&)
        when /\Amain\b/
          tokens << Token.new(:main,$&)
        when /\A\(/
          tokens << Token.new(:lparen,$&)
        when /\A\)/
          tokens << Token.new(:rparen,$&)
        when /\A{/
          tokens << Token.new(:lbrace,$&)
        when /\A}/
          tokens << Token.new(:rbrace,$&)
        when /\A\[/
          tokens << Token.new(:lbracket,$&)
        when /\A\]/
          tokens << Token.new(:rbracket,$&)
        when /\A\,/
          tokens << Token.new(:comma,$&)
        when /\A\;/
          tokens << Token.new(:semicolon,$&)
        when /\A\=/
          tokens << Token.new(:equ,$&)
        when /\A\+/
          tokens << Token.new(:add,$&)
        when /\A\-/
          tokens << Token.new(:sub,$&)
        when /\A\*/
          tokens << Token.new(:mul,$&)
        when /\A\//
          tokens << Token.new(:div,$&)
        when /\A\|\|/
          tokens << Token.new(:or_bar,$&)
        when /\A\&\&/
          tokens << Token.new(:and_bar,$&)
        when /\A\d+\b/
          tokens << Token.new(:int_literal,$&)
        when /\A\w+\b/
          tokens << Token.new(:identifier,$&)
        else
          raise "lexical error at : #{src[0..20]}..."
        end
        src.delete_prefix!($&)
      end
      pp tokens
    end
  end
end

if $PROGRAM_NAME==__FILE__
  MiniC::Lexer.new.lex ARGV.first
end
