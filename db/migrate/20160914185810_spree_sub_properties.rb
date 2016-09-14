class SpreeSubProperties < ActiveRecord::Migration
  def change
    create_table :spree_sub_properties do |t|
      t.integer :property_id, null: false
      t.integer :parent_id
      t.integer :position, default: 0
      t.string  :name
      t.timestamps null: true
    end

    add_index :spree_sub_properties, :property_id
  end
end
