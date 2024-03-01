module MiniC
  class Program
    attr_accessor :decls,:body
    def initialize decls=[],body=nil
      @decls,@body=decls,body
    end
  end

  class Decl
    attr_accessor :var,:type
    def initialize var,type
      @var,@type=var,type
    end
  end

  class Assign
    attr_accessor :lhs,:rhs
    def initialize lhs,rhs
      @lhs,@rhs=lhs,rhs
    end
  end

  class If
    attr_accessor :cond,:body,:else
    def initialize cond,body,else_=nil
      @cond,@body,@else=cond,body,else_
    end
  end

  class While
    attr_accessor :cond,:body
    def initialize cond,body
      @cond,@body=cond,body
    end
  end

  class Body
    attr_accessor :stmts
    def initialize stmts=[]
      @stmts=stmts
    end
  end

  class Else
    attr_accessor :body
    def initialize body
      @body=body
    end
  end

  class Type
  end

  class ScalarType
    def initialize kind
      @kind=kind
    end
  end

  class ArrayType
    def initialize type,size
      @type,@size=type,size
    end
  end

  # expressions
  class SingleTokenNode
    def initialize token
      @token=token
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

  class Binary
    attr_accessor :lhs,:op,:rhs
    def initialize lhs,op,rhs
      @lhs,@op,@rhs=lhs,op,rhs
    end
  end

  class Unary
    attr_accessor :op,:expr
    def initialize op,expr
      @op,@expr=op,expr
    end
  end

  class ArrayAccess
    attr_accessor :var,:index
    def initialize var,index
      @var,@index=var,index
    end
  end

  class Parenth
    attr_accessor :expr
    def initialize e
      @expr=e
    end
  end
end
