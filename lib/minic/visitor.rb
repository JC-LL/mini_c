module MiniC
  class Visitor
    include InfoDisplay

    def visit ast
      ast.accept(self)
    end

    def visitProgram(program,args=nil)
      indent
      info @indent,"visitProgram"
      program.decls.each{|decl| decl.accept(self,args)}
      program.body.accept(self,args)
      dedent
    end

    def visitDecl decl,args=nil
      indent
      info @indent,"visitDecl"
      decl.var.accept(self,args)
      decl.type.accept(self,args)
      dedent
    end

    def visitAssign assign,args=nil
      indent
      info @indent,"visitAssign"
      assign.lhs.accept(self,args)
      assign.rhs.accept(self,args)
      dedent
    end

    def visitIf if_,args=nil
      indent
      info @indent,"visitIf"
      if_.cond.accept(self,args)
      if_.body.accept(self,args)
      if_.else.accept(self,args) if if_.else
      dedent
    end

    def visitWhile while_,args=nil
      indent
      info @indent,"visitWhile"
      while_.cond.accept(self,args)
      while_.body.accept(self,args)
      dedent
    end

    def visitBody body,args=nil
      indent
      info @indent,"visitBody"
      body.stmts.each{|stmt| stmt.accept(self,args)}
      dedent
    end

    def visitElse else_,args=nil
      indent
      info @indent,"visitElse"
      else_.body.accept(self,args)
      dedent
    end

    def visitScalarType scalar_type,args=nil
    end

    def visitArrayType array_type,args=nil
      indent
      info @indent,"visitArrayType"
      array_type.type.accept(self,args)
      array_type.size.accept(self,args)
      dedent
    end

    def visitBinary binary,args=nil
      indent
      info @indent,"visitBinary"
      binary.lhs.accept(self,args)
      binary.rhs.accept(self,args)
      dedent
    end

    def visitUnary unary,args=nil
      indent
      info @indent,"visitUnary"
      unary.op
      unary.expr.accept(self,args)
      dedent
    end

    def visitArrayAccess access,args=nil
      indent
      info @indent,"visitArrayAccess"
      access.var.accept self,args
      access.index.accept self,args
      dedent
    end

    def visitParenth parenth,args=nil
      indent
      info @indent,"visitParenth"
      parenth.expr.accept(self,args)
      dedent
    end

    def visitSingleTokenNode st_node,args=nil
    end

    def visitIdentifier id,args=nil
    end

    def visitIntLiteral lit,args=nil
    end

    def visitFloatLiteral lit,args=nil
    end

    def visitBoolLiteral lit,args=nil
    end
  end
end
