object @sub_property
attributes *sub_property_attributes

child :children => :sub_properties do
  attributes *sub_property_attributes
end
