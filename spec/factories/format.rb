Factory.sequence(:name) {|n| "Format #{n}"}

Factory.define :format do |format|
  format.name { Factory.next :name }
end