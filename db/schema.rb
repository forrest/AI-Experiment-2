# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090927053559) do

  create_table "neuron_activations", :force => true do |t|
    t.boolean "active",            :default => false
    t.boolean "active_last_round", :default => false
    t.integer "neuron_id"
  end

  add_index "neuron_activations", ["active"], :name => "index_neuron_activations_on_active"
  add_index "neuron_activations", ["neuron_id"], :name => "index_neuron_activations_on_neuron_id"

  create_table "neurons", :force => true do |t|
    t.integer "complexity"
    t.integer "strength",                      :default => 0
    t.integer "active_up_to",                  :default => 0
    t.string  "input_char",       :limit => 1
    t.text    "all_children_ids"
  end

  add_index "neurons", ["complexity"], :name => "index_neurons_on_complexity"

  create_table "pattern_memberships", :force => true do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.integer "sort_order", :default => 0
  end

  add_index "pattern_memberships", ["child_id"], :name => "index_pattern_memberships_on_child_id"
  add_index "pattern_memberships", ["parent_id"], :name => "index_pattern_memberships_on_parent_id"

end
