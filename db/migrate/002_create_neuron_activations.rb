class CreateNeuronActivations < ActiveRecord::Migration
  def self.up
    create_table :neuron_activations do |t|
      t.boolean :active, :active_last_round, :default => false
      t.integer :neuron_id
    end
    
    add_index :neuron_activations, :neuron_id
  end

  def self.down
    remove_index :neuron_activations, :neuron_id
    drop_table :neuron_activations
  end
end
