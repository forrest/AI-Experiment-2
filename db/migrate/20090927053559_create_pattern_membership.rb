class CreatePatternMembership < ActiveRecord::Migration
  def self.up
    create_table :pattern_memberships, :force => true do |t|
      t.integer :parent_id, :child_id
      t.integer :sort_order, :default => 0
    end
    add_index :pattern_memberships, :parent_id
  end

  def self.down
    remove_index :pattern_memberships, :parent_id
    drop_table :pattern_memberships
  end
end
