collection @sub_property.children, :object_root => false
node(:data) { |sub_property| sub_property.name }
node(:attr) do |sub_property|
  { :id => sub_property.id,
    :name => sub_property.name
  }
end
node(:state) { "closed" }
