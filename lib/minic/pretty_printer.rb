module MiniC

  class PrettyPrinter < Visitor
    def print ast
      ast.accept(self)
    end

    # 'super' calls visitProgram from inherited Visitor.
    # This is just to display visit messages.
    # This can be suppressed of course.

    def visitProgram(program,args=nil)
      super
      code=Code.new
      code << "int main(){"
      code.indent=2
      program.decls.each{|decl| code << decl.accept(self,args)}
      code << program.body.accept(self,args)
      code.indent=0
      code << "}"
      return code
    end

    def visitDecl decl,args=nil
      super
      var=decl.var.accept(self,args)
      type=decl.type.accept(self,args)
      "#{type} #{var};"
    end

    def visitAssign assign,args=nil
      super
      lhs=assign.lhs.accept(self,args)
      rhs=assign.rhs.accept(self,args)
      "#{lhs} = #{rhs};"
    end

    def visitIf if_,args=nil
      super
      cond=if_.cond.accept(self,args)
      body=if_.body.accept(self,args)
      else_=if_.else.accept(self,args) if if_.else
      code=Code.new
      code << "if #{cond}{"
      code.indent=2
      code << body
      code.indent=0
      code << "}"
      code
    end

    def visitWhile while_,args=nil
      super
      cond=while_.cond.accept(self,args)
      body=while_.body.accept(self,args)
      code=Code.new
      code << "while #{cond}{"
      code.indent=2
      code << body
      code.indent=0
      code << "}"
      code
    end

    def visitBody body,args=nil
      super
      code=Code.new
      body.stmts.each{|stmt| code << stmt.accept(self,args)}
      code
    end

    def visitElse else_,args=nil
      super
      body=else_.body.accept(self,args)
      code=Code.new
      code << "else {"
      code.indent=2
      code << body
      code.indent=0
      code << "}"
      code
    end

    def visitScalarType scalar_type,args=nil
      super
      scalar_type.tok.val
    end

    def visitArrayType array_type,args=nil
      super
      type=array_type.type.accept(self,args)
      size=array_type.size.accept(self,args)
      super
      "#{type}[#{size}]"
    end

    def visitBinary binary,args=nil
      lhs=binary.lhs.accept(self,args)
      rhs=binary.rhs.accept(self,args)
      "(#{lhs} #{binary.op.val} #{rhs})"
    end

    def visitUnary unary,args=nil
      expr=unary.expr.accept(self,args)
      "#{unary.op.val} #{expr}"
    end

    def visitArrayAccess access,args=nil
      var=access.var.accept self,args
      idx=access.index.accept self,args
      "#{var}[#{idx}]"
    end

    def visitParenth parenth,args=nil
      expr=parenth.expr.accept(self,args)
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
