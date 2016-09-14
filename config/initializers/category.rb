class Spree::Category < Spree::Base
  self.table_name = 'spree_taxonomies'
  acts_as_list

  validates :name, presence: true

  has_many :catelogs, :foreign_key=>'taxonomy_id', class_name: "Spree::Catalog"
  has_one :root, -> { where parent_id: nil }, class_name: "Spree::Catalog", dependent: :destroy , :foreign_key=>'taxonomy_id'

  after_save :set_name

  default_scope -> { order(:position) }

  private

  def set_name
    if root
      root.update_columns(
          name: name,
          updated_at: Time.current
      )
    else
      self.root = Taxon.create!(taxonomy_id: id, name: name)
    end
  end
end