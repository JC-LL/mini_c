class Token
  attr_accessor :kind,:val,:pos
  def initialize kind,val,pos=[]
    @kind,@val,@pos=kind,val,pos
  end
end
