module Spree
  module Admin
    class SubPropertiesController < Spree::Admin::BaseController
      respond_to :html, :json, :js

      def index
      end

      def search
        if params[:ids]
          @sub_properties = Spree::SubProperty.where(id: params[:ids].split(','))
        else
          @sub_properties = Spree::SubProperty.limit(20).ransack(name_cont: params[:q]).result
        end
      end

      def create
        @property = Property.find(params[:property_id])
        @sub_property = @property.sub_properties.build(params[:sub_property])
        if @sub_property.save
          respond_with(@sub_property) do |format|
            format.json { render json: @sub_property.to_json }
          end
        else
          flash[:error] = Spree.t('errors.messages.could_not_create_sub_property')
          respond_with(@sub_property) do |format|
            format.html { redirect_to @property ? edit_admin_property_url(@property) : admin_properties_url }
          end
        end
      end

      def edit
        @property = Property.find(params[:property_id])
        @sub_property = @property.sub_properties.find(params[:id])
      end

      def update
        @property = Property.find(params[:property_id])
        @sub_property = @property.sub_properties.find(params[:id])
        parent_id = params[:sub_property][:parent_id]
        new_position = params[:sub_property][:position]

        if parent_id
          @sub_property.parent = SubProperty.find(parent_id.to_i)
        end

        if new_position
          @sub_property.child_index = new_position.to_i
        end



        @sub_property.assign_attributes(sub_property_params)

        if @sub_property.save
          flash[:success] = flash_message_for(@sub_property, :successfully_updated)
        end

        respond_with(@sub_property) do |format|
          format.html { redirect_to edit_admin_property_url(@property) }
        end
      end

      def destroy
        @sub_property = SubProperty.find(params[:id])
        @sub_property.destroy
        respond_with(@sub_property) { |format| format.json { render json: '' } }
      end

      private

      def sub_property_params
        params.require(:sub_property).permit([:name, :parent_id, :property_id])
      end
    end
  end
end