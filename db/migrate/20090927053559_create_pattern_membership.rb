class CreatePatternMembership < ActiveRecord::Migration
  def self.up
    begin
      create_table :pattern_memberships, :force => true do |t|
        t.integer :parent_id, :child_id
        t.integer :sort_order, :default => 0
      end
      add_index :pattern_memberships, :parent_id
      add_index :pattern_memberships, :child_id
    rescue Exception => e
      self.down
      raise e
    end
    
  end

  def self.down
    remove_index :pattern_memberships, :parent_id rescue nil
    remove_index :pattern_memberships, :child_id rescue nil
    drop_table :pattern_memberships rescue nil
  end
end
