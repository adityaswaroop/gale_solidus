module Spree
  module Api
    class SubPropertiesController < Spree::Api::BaseController
      def index
        if property
          @sub_properties = property.root.children
        elsif params[:ids]
          @sub_properties = Spree::SubProperty.accessible_by(current_ability, :read).where(id: params[:ids].split(','))
        else
          @sub_properties = Spree::SubProperty.accessible_by(current_ability, :read).order(:property_id).ransack(params[:q]).result
        end

        @sub_properties = paginate(@sub_properties)
        respond_with(@sub_properties)
      end

      def new
      end

      def show
        @sub_property = sub_property
        respond_with(@sub_property)
      end

      def jstree
        show
      end

      def create
        authorize! :create, SubProperty
        @sub_property = Spree::SubProperty.new(sub_property_params)
        @sub_property.property_id = params[:property_id]
        property = Spree::Property.find_by(id: params[:property_id])

        if property.nil?
          @sub_property.errors.add(:property_id, I18n.t('spree.api.invalid_property_id'))
          invalid_resource!(@sub_property) && return
        end

        @sub_property.parent_id = property.root.id unless params[:sub_property][:parent_id]

        if @sub_property.save
          respond_with(@sub_property, status: 201, default_template: :show)
        else
          invalid_resource!(@sub_property)
        end
      end

      def update
        authorize! :update, sub_property
        if sub_property.update_attributes(sub_property_params)
          respond_with(sub_property, status: 200, default_template: :show)
        else
          invalid_resource!(sub_property)
        end
      end

      def destroy
        authorize! :destroy, sub_property
        sub_property.destroy
        respond_with(sub_property, status: 204)
      end

      def products
        # Returns the products sorted by their position with the classification
        # Products#index does not do the sorting.
        sub_property = Spree::SubProperty.find(params[:id])
        @products = paginate(sub_property.products.ransack(params[:q]).result)
        render "spree/api/products/index"
      end

      private

      def default_per_page
        500
      end

      def property
        if params[:property_id].present?
          @property ||= Spree::Property.accessible_by(current_ability, :read).find(params[:property_id])
        end
      end

      def sub_property
        @sub_property ||= property.sub_properties.accessible_by(current_ability, :read).find(params[:id])
      end

      def sub_property_params
        if params[:sub_property] && !params[:sub_property].empty?
          params.require(:sub_property).permit([:name, :parent_id, :property_id])
        else
          {}
        end
      end
    end
  end
end