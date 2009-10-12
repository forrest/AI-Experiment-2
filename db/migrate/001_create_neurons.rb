class CreateNeurons < ActiveRecord::Migration
  def self.up
    create_table :neurons do |t|
      t.integer :complexity
      t.integer :strength, :default => 0
      t.integer :active_up_to, :default => 0
      t.string :input_char, :limit => 1
      t.text :all_children_ids #serialized
    end
    
  end

  def self.down
    drop_table :neurons
  end
end
