module Spree
  class Property < Spree::Base
    acts_as_list

    has_many :property_prototypes
    has_many :prototypes, through: :property_prototypes

    has_many :product_properties, dependent: :delete_all, inverse_of: :property
    has_many :products, through: :product_properties

    has_many :sub_properties, inverse_of: :property
    has_one :root, -> { where parent_id: nil }, class_name: "Spree::SubProperty", dependent: :destroy

    validates :name, :presentation, presence: true

    scope :sorted, -> { order(:name) }

    after_touch :touch_all_products

    after_save :set_name

    private

    def touch_all_products
      products.update_all(updated_at: Time.current)
    end

    def set_name
      if root
        root.update_columns(
            name: name,
            updated_at: Time.current
        )
      else
        self.root = SubProperty.create!(property_id: id, name: name)
      end
    end
  end
end
