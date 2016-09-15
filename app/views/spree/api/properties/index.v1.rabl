object false
child(@properties => :properties) do
  extends "spree/api/properties/show"
end
node(:count) { @properties.count }
node(:current_page) { @properties.current_page }
node(:pages) { @properties.total_pages }
