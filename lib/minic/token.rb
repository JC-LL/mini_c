class Token
  attr_accessor :kind,:value,:pos
  def initialize kind,value,pos=[]
    @kind,@value,@pos=kind,value,pos
  end
end
