module Spree
  class SubProperty < Spree::Base
    acts_as_nested_set dependent: :destroy

    belongs_to :property, class_name: 'Spree::Property', inverse_of: :sub_properties
    validates :name, presence: true


    after_save :touch_ancestors_and_property
    after_touch :touch_ancestors_and_property

    private

    def touch_ancestors_and_property
      # Touches all ancestors at once to avoid recursive property touch, and reduce queries.
      self.class.where(id: ancestors.pluck(:id)).update_all(updated_at: Time.current)
      # Have property touch happen in #touch_ancestors_and_property rather than association option in order for imports to override.
      property.try!(:touch)
    end

  end
end