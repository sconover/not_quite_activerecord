require "spec/helper"

describe "#first" do
  [ARHouse, NQHouse].each do |_class_|
    describe _class_.name do
      it "gets the first row it comes across" do
        _class_.create!(:address => "123 Main")
    
        expect { _class_.first.address == "123 Main" }
      end
    end
  end
end