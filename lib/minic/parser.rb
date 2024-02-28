require_relative "lexer"

module MiniC
  class Parser
    def parse filename
      @tokens=Lexer.new.lex(filename)
      parse_program
    end

    def accept_it
      @tokens.shift
    end

    def expect kind
      if (actual=show_next.kind)==kind
        accept_it
      else
        raise "Syntax error : expecting token kind '#{kind}'. Got token kind '#{actual}'"
      end
    end

    def show_next
      @tokens.first
    end

    def parse_program
      expect :int
      expect :main
      expect :lparen
      expect :rparen
      expect :lbrace
      while [:int,:bool,:float,:char].include? show_next.kind
        parse_declaration
      end
      while show_next.kind!=:rbrace
        parse_statement
      end
      expect :rbrace
    end

    def parse_declaration
      parse_type
      expect :identifier
      if show_next.kind==:lbracket
        accept_it
        expect :int_literal
        expect :rbracket
      end
      expect :semicolon
    end

    def parse_type
      if [:int,:bool,:float,:char].include? show_next.kind
        accept_it
      else
        raise "syntax error : expecting type int,bool,float or char .Got '#{show_next.value}'"
      end
    end

    def parse_statement
      case show_next.kind
      when :if
        parse_if
      when :while
        parse_while
      else
        parse_assignment
      end
    end

    def parse_assignment
      expect :identifier
      if show_next.kind==:lbracket
        accept_it
        parse_expression
        expect :rbracket
      end
      expect :equ
      parse_expression
      expect :semicolon
    end

    def parse_expression
      raise "NIY"
    end
  end
end
