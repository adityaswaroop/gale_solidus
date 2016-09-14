module Spree
  module Admin
    class TaxonomiesController < ResourceController
      private

      def location_after_save
        if @taxonomy.created_at == @taxonomy.updated_at
          edit_admin_category_url(@taxonomy)
        else
          admin_categories_url
        end
      end
    end
  end
end
