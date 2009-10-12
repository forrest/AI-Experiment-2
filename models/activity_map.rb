class ActivityMap
  
  def initialize
    reset
  end
  
  def update_activity(input = false)
    age_all
    activate_input_neuron(input) if input
    run_through_step
  end
  
  private
  
  def age_all
    ActiveRecord::Base.connection.execute("UPDATE neuron_activations SET neuron_activations.active_last_round = neuron_activations.active, neuron_activations.active = 0")
  end
  
  def reset
    NeuronActivation.find_each{|na| na.update_attributes(:active => false, :active_last_round => false)}
  end
  
  def activate_input_neuron(input)
    neuron = Neuron.find_or_create_by_input_char(input)
    neuron.active = true
  end
  
  def run_through_step
    Neuron.can_by_processed.find_each{|n|
      n.process
    }
  end
  
end