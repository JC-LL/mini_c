module MiniC
  class Parser
    include InfoDisplay
    def parse filename
      @tokens=Lexer.new.lex(filename)
      @indent=1
      ast=parse_program
    end

    def accept_it
      @tokens.shift
    end

    def expect kind
      if (actual=show_next.kind)==kind
        accept_it
      else
        pos=show_next.pos
        raise "Syntax error at #{pos} : expecting token kind '#{kind}'. Got token kind '#{actual}'"
      end
    end

    def show_next
      @tokens.first
    end

    def indent
      @indent+=1
    end

    def dedent
      @indent-=1
    end

    def parse_program
      info @indent,"parse_program"
      indent
      expect :int
      expect :main
      expect :lparen
      expect :rparen
      expect :lbrace
      decls,stmts=[],[]
      while [:int,:bool,:float,:char].include? show_next.kind
        decls << parse_declaration()
      end
      while show_next.kind!=:rbrace
        stmts << parse_statement()
      end
      expect :rbrace
      dedent
      return Program.new(decls,Body.new(stmts))
    end

    def parse_declaration
      info @indent,"parse_declaration"
      indent
      type=parse_type
      ident=Identifier.new(expect(:identifier))
      if show_next.kind==:lbracket
        accept_it
        size=IntLiteral.new(expect(:int_literal))
        expect :rbracket
        type=ArrayType.new(type,size)
      end
      expect :semicolon
      dedent
      Decl.new(ident,type)
    end

    def parse_type
      if [:int,:bool,:float,:char].include? show_next.kind
        tok=accept_it
        ScalarType.new(tok)
      else
        pos=show_next.pos
        raise "syntax error at #{pos}: expecting type int,bool,float or char .Got '#{show_next.value}'"
      end
    end

    def parse_statement
      info @indent,"parse_statement"
      indent
      case show_next.kind
      when :if
        stmt=parse_if()
      when :while
        stmt=parse_while()
      else
        stmt=parse_assignment()
      end
      dedent
      stmt
    end

    def parse_assignment
      info @indent,"parse_assignment"
      indent
      lhs=Identifier.new(expect :identifier)
      if show_next.kind==:lbracket
        accept_it
        e=parse_expression
        expect :rbracket
        lhs=ArrayAccess.new(lhs,e)
      end
      expect :equ
      rhs=parse_expression
      expect :semicolon
      dedent
      Assign.new(lhs,rhs)
    end

    def parse_while
      info @indent,"parse_while"
      indent
      expect :while
      cond=parse_expression
      body=Body.new
      expect :lbrace
      while show_next.kind!=:rbrace
        body.stmts << parse_statement
      end
      expect :rbrace
      dedent
      While.new(cond,body)
    end

    def parse_if
      info @indent,"parse_if"
      indent
      expect :if
      cond=parse_expression()
      expect :lbrace
      body=Body.new
      while show_next.kind!=:rbrace
        body.stmts << parse_statement()
      end
      expect :rbrace
      if show_next.kind==:else
        else_=parse_else()
      end
      dedent
      return If.new(cond,body,else_)
    end

    def parse_else
      info @indent,"parse_else"
      indent
      body=Body.new
      expect :else
      expect :lbrace
      while show_next.kind!=:rbrace
        body.stmts << parse_statement
      end
      expect :rbrace
      dedent
      Else.new(body)
    end

    def parse_expression
      #info @indent,"parse_expression"
      indent
      e1=parse_conjunction
      while show_next.kind==:or_bar
        op=accept_it
        e2=parse_conjunction
        e1=Binary.new(e1,op,e2)
      end
      dedent
      e1
    end

    def parse_conjunction
      #info @indent,"parse_conjunction"
      indent
      e1=parse_equality
      while show_next.kind==:and_bar
        op=accept_it
        e2=parse_equality
        e1=Binary.new(e1,op,e2)
      end
      dedent
      e1
    end

    def parse_equality
      #info @indent,"parse_equality"
      indent
      e1=parse_relation
      if [:double_eq,:neq].include?(show_next.kind)
        op=accept_it
        e2=parse_relation
        e1=Binary.new(e1,op,e2)
      end
      dedent
      e1
    end

    def parse_relation
      #info @indent,"parse_relation"
      indent
      e1=parse_addition
      if [:lt,:lte,:gt,:gte].include?(show_next.kind)
        op=accept_it
        e2=parse_addition
        e1=Binary.new(e1,op,e2)
      end
      dedent
      e1
    end

    def parse_addition
      #info @indent,"parse_addition"
      indent
      e1=parse_term
      while [:add,:sub].include?  show_next.kind
        op=accept_it
        e2=parse_term
        e1=Binary.new(e1,op,e2)
      end
      dedent
      e1
    end

    def parse_term
      #info @indent,"parse_term"
      indent
      e1=parse_factor
      while [:mul,:div,:mod].include?  show_next.kind
        op=accept_it
        e2=parse_factor
        e1=Binary.new(e1,op,e2)
      end
      dedent
      e1
    end

    def parse_factor
      #info @indent,"parse_factor"
      indent
      if [:minus,:excl].include?(show_next.kind)
        op=accept_it
        e=parse_primary
        e=Unary.new(op,e)
      else
        e=parse_primary
      end
      dedent
      e
    end

    def parse_primary
      #info @indent,"parse_primary"
      indent
      case show_next.kind
      when :identifier
        prim=Identifier.new(accept_it)
        if show_next.kind==:lbracket
          accept_it
          e=parse_expression
          expect :rbracket
          prim=ArrayAccess.new(prim,e)
        end
      when :sub,:add
        op=accept_it
        e=parse_expression
        prim=Unary.new(op,e)
      when :int_literal
        prim=IntLiteral.new(accept_it)
      when :lparen
        e=parse_parenth
        prim=Parenth.new(e)
      else
        raise "Syntax error near : #{@tokens[0..10].map{|tok| tok.val}.join(" ")}"
      end
      dedent
      return prim
    end

    def parse_parenth
      #info @indent,"parse_parenth"
      indent
      expect :lparen
      e=parse_expression
      expect :rparen
      dedent
      e
    end
  end
end
