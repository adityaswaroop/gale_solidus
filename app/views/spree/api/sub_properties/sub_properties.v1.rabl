child :children => :sub_properties do
  attributes *sub_property_attributes

  extends "spree/api/sub_properties/sub_properties"
end
