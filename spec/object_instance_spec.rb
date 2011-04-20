require "spec/helper"

describe "instance separation" do
  
  [ARHouse, NQHouse].each do |_class_|
    describe _class_.name do
      it "returns a separate instance for each retrieved object" do
        _class_.create!(:address => "123 Main")
        deny { _class_.first.equal?(_class_.first) }
      end

      it "does not allow changes to one instance to affect another" do
        _class_.create!(:address => "123 Main")

        _class_.first.address = "456 Canal"
        assert { _class_.first.address == "123 Main" }
      end
    end
  end
  
end