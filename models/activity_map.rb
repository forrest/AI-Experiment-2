class ActivityMap
  
  def initialize
    reset
  end
  
  def update_activity(input = false)
    age_level(1)
    activate_input_neuron(input) if input
    
    (2..max_level).each{|level|
      process_level(level)
    }
  end
  
  private
  
  
  def process_level(level)
    to_check = Neuron.of_level(level).ready_to_fire
    age_level(level)
    
    if to_check.count > 0
      to_check.each(&:process)
    end
  end

  def max_level
    Neuron.maximum(:complexity)
  end
  
  def age_level(complexity)
    ActiveRecord::Base.connection.execute(" UPDATE neuron_activations JOIN neurons ON (neuron_activations.neuron_id = neurons.id) 
                                            SET neuron_activations.active_last_round = neuron_activations.active, neuron_activations.active = 0 
                                            WHERE neurons.complexity = #{complexity}")
  end
  
  def activate_input_neuron(input)
    neuron = Neuron.find_or_create_by_input_char(input)
    neuron.active = true
  end
  
  
  def reset
    NeuronActivation.find_each{|na| na.update_attributes(:active => false, :active_last_round => false)}
  end  
  
end
