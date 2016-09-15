object @property

if params[:set] == 'nested'
  extends "spree/api/properties/nested"
else
  attributes *property_attributes

  child :root => :root do
      attributes *sub_property_attributes

    child :children => :sub_properties do
      attributes *sub_property_attributes
    end
  end
end
