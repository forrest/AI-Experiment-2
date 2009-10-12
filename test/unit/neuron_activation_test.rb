require File.dirname(__FILE__) + '/../test_helper'

class NeuronActivationTest < ActiveSupport::TestCase
  
  test "the age_all function" do
    am = ActivityMap.new
    
    n = Neuron.create(:input_char => "a")
    n.active = true
    
    assert (na = n.neuron_activation), "not creating activation status"
    assert na.active?
    assert !na.active_last_round?
    
    am.update_activity
    na = NeuronActivation.find(na.id)
    
    assert !na.active?, "Should have deactivated during aging"
    assert na.active_last_round?, "Should have moved activity to last round"
    
    am.update_activity
    na = NeuronActivation.find(na.id)    

    assert !na.active?, "Should have remained deactivated"
    assert !na.active_last_round?, "Should have deactivated last round"
  end
  
  test "the update_activity function" do
    am = ActivityMap.new
    sm = StructureMap.new
    sm.destroy_all
    
    a = Neuron.create!(:input_char => "a")
    b = Neuron.create!(:input_char => "b")
    ab = Neuron.create!(:array_of_neurons => [a,b])
  
    am.update_activity("a")
    a = Neuron.find(a.id)
    b = Neuron.find(b.id)
    ab = Neuron.find(ab.id)
    
    assert a.active?, "a should be active"
    assert !b.active?, "b should not be active"
    assert !ab.active?, "ab should not be active"
    
    am.update_activity("b")
    a = Neuron.find(a.id)
    b = Neuron.find(b.id)
    ab = Neuron.find(ab.id)
    
    assert !a.active?, "a should not be active"
    assert b.active?, "b should be active"
    assert ab.active?, "ab should be active"
    
    am.update_activity("a")
    a = Neuron.find(a.id)
    b = Neuron.find(b.id)
    ab = Neuron.find(ab.id)
    
    assert a.active?, "a should be active"
    assert !b.active?, "b should not be active"
    assert !ab.active?, "ab should not be active"
  end
  
end
