module MiniC
  class PrettyPrinter < Visitor
    include InfoDisplay

    def print ast
      ast.accept(self)
    end

    def visitProgram(program,args=nil)
      indent
      code=Code.new
      info @indent,"visitProgram"
      code << "int main(){"
      code.indent=2
      program.decls.each{|decl| code << decl.accept(self,args)}
      code << program.body.accept(self,args)
      code.indent=0
      code << "}"
      dedent
      return code
    end

    def visitDecl decl,args=nil
      indent
      info @indent,"visitDecl"
      var=decl.var.accept(self,args)
      type=decl.type.accept(self,args)
      dedent
      "#{type} #{var};"
    end

    def visitAssign assign,args=nil
      indent
      info @indent,"visitAssign"
      lhs=assign.lhs.accept(self,args)
      rhs=assign.rhs.accept(self,args)
      dedent
      "#{lhs} = #{rhs};"
    end

    def visitIf if_,args=nil
      indent
      info @indent,"visitIf"
      cond=if_.cond.accept(self,args)
      body=if_.body.accept(self,args)
      else_=if_.else.accept(self,args) if if_.else
      dedent
      code=Code.new
      code << "if #{cond}{"
      code.indent=2
      code << body
      code.indent=0
      code << "}"
      code
    end

    def visitWhile while_,args=nil
      indent
      info @indent,"visitWhile"
      cond=while_.cond.accept(self,args)
      body=while_.body.accept(self,args)
      dedent
      code=Code.new
      code << "while #{cond}{"
      code.indent=2
      code << body
      code.indent=0
      code << "}"
      code
    end

    def visitBody body,args=nil
      indent
      code=Code.new
      info @indent,"visitBody"
      body.stmts.each{|stmt| code << stmt.accept(self,args)}
      dedent
      code
    end

    def visitElse else_,args=nil
      indent
      info @indent,"visitElse"
      body=else_.body.accept(self,args)
      dedent
      code=Code.new
      code << "else {"
      code.indent=2
      code << body
      code.indent=0
      code << "}"
      code
    end

    def visitScalarType scalar_type,args=nil
      scalar_type.tok.val
    end

    def visitArrayType array_type,args=nil
      indent
      info @indent,"visitArrayType"
      type=array_type.type.accept(self,args)
      size=array_type.size.accept(self,args)
      dedent
      "#{type}[#{size}]"
    end

    def visitBinary binary,args=nil
      indent
      info @indent,"visitBinary"
      lhs=binary.lhs.accept(self,args)
      rhs=binary.rhs.accept(self,args)
      dedent
      "(#{lhs} #{binary.op.val} #{rhs})"
    end

    def visitUnary unary,args=nil
      indent
      info @indent,"visitUnary"
      expr=unary.expr.accept(self,args)
      dedent
      "#{unary.op.val} #{expr}"
    end

    def visitArrayAccess access,args=nil
      indent
      info @indent,"visitArrayAccess"
      var=access.var.accept self,args
      idx=access.index.accept self,args
      dedent
      "#{var}[#{idx}]"
    end

    def visitParenth parenth,args=nil
      indent
      info @indent,"visitParenth"
      expr=parenth.expr.accept(self,args)
      dedent
      "(#{expr})"
    end

    def visitSingleTokenNode st_node,args=nil
      st_node.token.val
    end

    def visitIdentifier id,args=nil
      visitSingleTokenNode(id)
    end

    def visitIntLiteral lit,args=nil
      visitSingleTokenNode(lit)
    end

    def visitFloatLiteral lit,args=nil
      visitSingleTokenNode(lit)
    end

    def visitBoolLiteral lit,args=nil
      visitSingleTokenNode(lit)
    end
  end
end
