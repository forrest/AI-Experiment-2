class PatternMembership <  ActiveRecord::Base
  belongs_to :parent, :class_name => "Neuron"
  belongs_to :child, :class_name => "Neuron"
  
  validates_uniqueness_of :sort_order, :scope => :parent_id
end