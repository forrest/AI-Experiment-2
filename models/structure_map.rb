class StructureMap
  
  def initialize
    ActiveRecord::Base.connection.execute("UPDATE neurons SET neurons.active_up_to = 0")
  end
  
  def to_s
    Neuron.all(:order => "complexity").collect(&:to_s).join("\n")
  end
  
  def destroy_all
    Neuron.destroy_all
    PatternMembership.destroy_all
  end
  
end