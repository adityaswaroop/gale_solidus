object false
node(:attributes) { [*property_attributes] }
node(:required_attributes) { required_fields_for(Spree::Property)  }
