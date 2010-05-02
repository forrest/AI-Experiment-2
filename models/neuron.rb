class Neuron <  ActiveRecord::Base
  has_one :neuron_activation
  
  has_many :pattern_memberships, :foreign_key => "parent_id"
  has_many :child_neurons, :through => :pattern_memberships, :source => :child#, :order => "pattern_memberships.sort_order"
  
  has_many :parent_memberships, :foreign_key => "child_id", :class_name => "PatternMembership"
  has_many :parent_neurons, :through => :parent_memberships, :source => :parent
  
  #this is an array of the sorted IDs of this neurons direct children. This is used to quickly find possible matches.
  serialize :all_children_ids, Array
  
  validates_uniqueness_of :all_children_ids, :on => :create, :message => "must be unique"
  validates_uniqueness_of :input_char, :on => :create, :message => "must be unique"
  validates_numericality_of :complexity, :on => :create, :message => "is not a number"
  #TODO: add validation for unique input_chars, but only when input_char is present
  
  def validate
    if (input_char.nil? or input_char.empty?) and (all_children_ids.blank? or all_children_ids.empty?)
      errors.add(:input_char, "must have an input_char or children")
    end    
  end
  
  #OPTIMIZE: this can be expanded to get just neurons that have the first input as the selected char or have the next input as the selected char
  named_scope :can_by_processed, :conditions => ["complexity > 1"], :order => "complexity"
  named_scope :active_this_round, :joins => :neuron_activation, :conditions => {:neuron_activations => {:active => true}}
  named_scope :active_last_round, :joins => :neuron_activation, :conditions => {:neuron_activations => {:active_last_round => true}}
  named_scope :of_level, lambda{|*args| 
    {:conditions => {:complexity => args[0].to_i}}
  }
  
  named_scope :ready_to_fire, {:joins => "JOIN pattern_memberships ON (pattern_memberships.parent_id = neurons.id AND pattern_memberships.sort_order = neurons.active_up_to)
                                            JOIN neurons AS children ON (pattern_memberships.child_id = children.id)
                                            JOIN neuron_activations as child_activations ON (child_activations.neuron_id = children.id)",
                                  :conditions => ["child_activations.active = ?", true], :readonly => false
  }
  
  attr_writer :array_of_neurons
  attr_accessible :array_of_neurons, :input_char
  
  before_validation_on_create :store_children
  def store_children
    @array_of_neurons ||= []
  
    @array_of_neurons.each_index{|index|
      n = @array_of_neurons[index]
      self.pattern_memberships.build(:child => n, :sort_order => index)
    }
  
    child_ids = []
    @array_of_neurons.each{|n|
      child_ids << n.id
    }
    child_ids.concat(self.child_neurons.collect(&:id))
    child_ids.uniq!
    child_ids.sort!
    self.all_children_ids = child_ids
  end
  
  before_validation_on_create :set_complexity
  def set_complexity
    if input_char.nil? or input_char.empty?
      self.complexity = (@array_of_neurons.collect(&:complexity).max || 0)+1
    else
      self.complexity = 1
    end
  end
  
  before_validation_on_create :set_default_activation
  def set_default_activation
    self.build_neuron_activation
  end
  
  def ordered_children
    #child_neurons
    self.pattern_memberships.all(:order => "sort_order", :include => :child).collect(&:child)
  end
  
  def Neuron.find_by_pattern(array_of_neurons)
    ids = array_of_neurons.collect(&:id) 
    ids.uniq!
    ids.sort!
    
    serialized = "--- \n"
    serialized << ids.collect{|id| "- #{id}\n"}.join("")
    
    parents_of_first_neuron = array_of_neurons.first.parent_neurons
    possibles_matches = parents_of_first_neuron.find_all_by_all_children_ids(serialized)
    return possibles_matches.detect{|possible_match|  possible_match.ordered_children==array_of_neurons }
  end
  
  def active=(is_active)
    self.neuron_activation.update_attribute(:active, is_active)
  end
  
  def active?
    self.neuron_activation.active?
  end
  
  def process
    if !self.ordered_children.empty? and self.ordered_children[self.active_up_to].active?
      self.active_up_to+=1
      if self.active_up_to>=self.pattern_memberships.count
        self.active_up_to = 0
        self.active = true
      end
    else
      self.active_up_to = 0
    end
    self.save
  end
  
  def to_s
    "[#{self.pattern_string}] #{active? ? "*" : ""}"
  end
  
  def pattern_string
    if self.input_char.nil? or self.input_char.empty?
      ch = ordered_children.collect{|c|
        c.pattern_string
      }
      str = "(#{ch.join(" ")})"
    else
      str = self.input_char
      str = "_" if str==" "
    end
    return str
  end
     
  def reset!
    update_attribute(:active_up_to, 0)
    active = false
  end  
    
end
