require File.dirname(__FILE__) + '/../test_helper'

class NeuronTest < ActiveSupport::TestCase

  test "storing space but failing validation when needed" do
    n = Neuron.create(:input_char => " ")
    assert n.valid?, "did not create neuron"
    assert_equal " ", n.input_char, "not storing correct input_char"    
    assert_equal "_", n.pattern_string, "not displaying space as underline"
    
    n = Neuron.create()
    assert !n.valid?, "should not be valid"
  end

  test "Check complexities are set correctly" do
    input_neuron = Neuron.create(:input_char => "a")
    assert input_neuron, "did not create neuron"
    assert_equal 1, input_neuron.complexity, "Not setting complexity correctly on input neuron"
    
    input2 = Neuron.create(:input_char => "b")
    
    more_complex = Neuron.create(:array_of_neurons => [input_neuron, input2])
    assert more_complex, "did not create neuron"
    assert_equal 2, more_complex.complexity, "Not setting complexity correctly on more complex neuron"
    
    very_complex = Neuron.create(:array_of_neurons => [more_complex, input_neuron, input2])
    assert very_complex, "did not create neuron"
    assert_equal 3, very_complex.complexity, "Not setting complexity correctly on very complex neuron"
  end
  
  test "Patterns are getting stored correctly" do
    @a = Neuron.create(:input_char => "a")
    @b = Neuron.create(:input_char => "b")
    @c = Neuron.create(:input_char => "c")
    
    @complex = Neuron.create(:array_of_neurons => [@c,@a,@b])
    
    assert @complex, "did not create copmlex neuron"
    assert_equal 2, @complex.complexity, "did not set complexity correctly"
    assert_equal 3, @complex.child_neurons.count, "wrong number of children"
    assert_equal [@c,@a,@b], @complex.ordered_children, "wrong order of children"
    
    assert_equal 1, @a.parent_neurons.count, "not connecting to parent neurons"
    assert_equal [@complex], @a.parent_neurons, "not connecting to parent neurons"
  end
  
  test "activation of complex neurons" do
    #neurons are ordered [c, a, b]
    test_Patterns_are_getting_stored_correctly
    
    assert_equal 0, @complex.active_up_to, "not starting at zero"
    
    @c.active = true
    @a.active = false
    @b.active = false
    @complex.process
    assert_equal 1, @complex.active_up_to, "not progressing properly"
    
    @c.active = false
    @a.active = true
    @b.active = false
    @complex.process
    assert_equal 2, @complex.active_up_to, "not progressing properly"
    
    @c.active = false
    @a.active = false
    @b.active = true
    @complex.process
    assert_equal 0, @complex.active_up_to, "not reset upon activation"
    
    assert @complex.active?, "Not activating neuron upon pattern completion"
    
  end
  
  test "find by pattern" do
    test_Patterns_are_getting_stored_correctly
    
    assert_nil Neuron.find_by_pattern([@c, @a]), "should not return a match"
    assert_nil Neuron.find_by_pattern([@a,@b,@c]), "should not return a match"
    
    assert Neuron.find_by_pattern([@c,@a,@b]), "should return a match"
  end
  
end
