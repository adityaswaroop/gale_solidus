class AddColumnToProduct < ActiveRecord::Migration
  def change
    add_column :spree_properties, :position, :integer, default: 0
    add_column :spree_sub_properties, :lft, :integer
    add_column :spree_sub_properties, :rgt, :integer
  end
end
