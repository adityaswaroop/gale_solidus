object false
node(:count) { @sub_properties.count }
node(:total_count) { @sub_properties.total_count }
node(:current_page) { @sub_properties.current_page }
node(:per_page) { @sub_properties.limit_value }
node(:pages) { @sub_properties.total_pages }
child @sub_properties => :sub_properties do
  attributes *sub_property_attributes
  unless params[:without_children]
    extends "spree/api/sub_properties/sub_properties"
  end
end
