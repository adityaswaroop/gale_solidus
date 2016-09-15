object false
node(:data) { @property.root.name }
node(:attr) do
  { :id => @property.root.id,
    :name => @property.root.name
  }
end
node(:state) { "closed" }
