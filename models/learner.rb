class Learner
  
  MAX_FRESH_NEURONS = 3
  MAX_COMPRESSED_NEURONS = 1
  MAX_NEW_NEURONS = (MAX_FRESH_NEURONS + MAX_COMPRESSED_NEURONS)
  MAX_NEURONS = 100
  
  def learn(input = false)
    # strengthen_useful_patterns(input)
    
    forget
    
    learn_new_patterns
    compress_patterns
  end
  
  private
  
  def learn_new_patterns
    Neuron.active_this_round.each{|n1|
      Neuron.active_last_round.each{|n2|
        if n1!=n2
          if not n1.all_children_ids.include?(n2.id) and not n2.all_children_ids.include?(n1.id)
            new_pattern = [n2,n1]
            if not Neuron.find_by_pattern(new_pattern)
              new_neuron = Neuron.create!(:array_of_neurons => new_pattern)
            end
          end
        end
      }
    }
  end
  
  def compress_patterns
  end
  
  def strengthen_useful_patterns(actual_input)
    #NOTE: maybe have correlation and strength as two different values. That way negatives can be stored
    
    #if actual_input == @most_recent_prediction
      #strengthen neurons that were used
    #else
      #weaken neurons that were used
    #end
    
  end
  
  
  def forget
    current_number_of_neurons = Neuron.all.count
    to_forget = (MAX_NEURONS - current_number_of_neurons)*MAX_NEW_NEURONS
    
    #gather weakest neurons
  end
  
end