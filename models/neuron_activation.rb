class NeuronActivation <  ActiveRecord::Base
  belongs_to :neuron
  
  named_scope :active_this_round, :conditions => {:active => true}
  named_scope :active_last_round, :conditions => {:active_last_round => true}
  
  def validate
    if active and active_last_round and self.neuron.input_char.blank?
      errors.add(:active, "should not be able to be active two turns in a row.")
    end
  end
  
  def status=(new_status)
    self.active = new_status
    self.save
  end
  
end