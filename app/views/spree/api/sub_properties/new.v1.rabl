object false
node(:attributes) { [*sub_property_attributes] }
node(:required_attributes) { required_fields_for(Spree::SubProperty) }
