class CreateNeuronActivations < ActiveRecord::Migration
  def self.up
    begin
      create_table :neuron_activations do |t|
        t.boolean :active, :active_last_round, :default => false
        t.integer :neuron_id
      end

      add_index :neuron_activations, :neuron_id
      add_index :neuron_activations, :active
    rescue Exception => e
      self.down
      raise e
    end
    
  end

  def self.down
    remove_index :neuron_activations, :active rescue nil
    remove_index :neuron_activations, :neuron_id rescue nil
    drop_table :neuron_activations rescue nil
  end
end
