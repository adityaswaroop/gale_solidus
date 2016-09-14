module Spree
  class SubProperty < Spree::Base
    acts_as_nested_set dependent: :destroy

    belongs_to :property, class_name: 'Spree::Property', inverse_of: :sub_properties

  end
end