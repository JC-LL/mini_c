module MiniC
  class AstNode
    def accept visitor,args=nil
      name=self.class.name.split("::").last
      visitor.send("visit#{name}".to_sym,self,args)
    end
  end

  class Program < AstNode
    attr_accessor :decls,:body
    def initialize decls=[],body=nil
      @decls,@body=decls,body
    end
  end

  class Decl < AstNode
    attr_accessor :var,:type
    def initialize var,type
      @var,@type=var,type
    end
  end

  class Assign < AstNode
    attr_accessor :lhs,:rhs
    def initialize lhs,rhs
      @lhs,@rhs=lhs,rhs
    end
  end

  class If < AstNode
    attr_accessor :cond,:body,:else
    def initialize cond,body,else_=nil
      @cond,@body,@else=cond,body,else_
    end
  end

  class While < AstNode
    attr_accessor :cond,:body
    def initialize cond,body
      @cond,@body=cond,body
    end
  end

  class Body < AstNode
    attr_accessor :stmts
    def initialize stmts=[]
      @stmts=stmts
    end
  end

  class Else < AstNode
    attr_accessor :body
    def initialize body
      @body=body
    end
  end

  class Type < AstNode
  end

  class ScalarType < Type
    attr_accessor :tok
    def initialize tok
      @tok=tok
    end
  end

  class ArrayType < Type
    attr_accessor :type,:size
    def initialize type,size
      @type,@size=type,size
    end
  end

  # expressions
  class SingleTokenNode < AstNode
    attr_accessor :token
    def initialize token
      @token=token
    end
  end

  class Binary < AstNode
    attr_accessor :lhs,:op,:rhs
    def initialize lhs,op,rhs
      @lhs,@op,@rhs=lhs,op,rhs
    end
  end

  class Unary  < AstNode
    attr_accessor :op,:expr
    def initialize op,expr
      @op,@expr=op,expr
    end
  end

  class ArrayAccess  < AstNode
    attr_accessor :var,:index
    def initialize var,index
      @var,@index=var,index
    end
  end

  class Parenth  < AstNode
    attr_accessor :expr
    def initialize e
      @expr=e
    end
  end

  class Identifier < SingleTokenNode
  end

  class IntLiteral < SingleTokenNode
  end

  class FloatLiteral < SingleTokenNode
  end

  class BoolLiteral < SingleTokenNode
  end

end
