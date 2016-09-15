module Spree
  module Admin
    class PropertiesController < ResourceController
      def index
        respond_with(@collection)
      end

      private

      def location_after_save
        if @property.created_at == @property.updated_at
          edit_admin_property_url(@property)
        else
          admin_properties_url
        end
      end

      def collection
        return @collection if @collection.present?
        # params[:q] can be blank upon pagination
        params[:q] = {} if params[:q].blank?

        @collection = super
        @search = @collection.ransack(params[:q])
        @collection = @search.result.
              page(params[:page]).
              per(Spree::Config[:properties_per_page])

        @collection
      end
    end
  end
end
