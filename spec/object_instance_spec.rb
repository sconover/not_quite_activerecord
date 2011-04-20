require "spec/helper"

describe "instance separation" do
  
  [ARHouse, NQHouse].each do |_class_|
    describe _class_.name do
      it "autoincrements the id" do
        main = _class_.create!(:address => "123 Main")
        canal = _class_.create!(:address => "456 Canal")

        expect { main.id.is_a?(Numeric) }
        expect { canal.id.is_a?(Numeric) }
        expect { canal.id > main.id }
      end
      
      it "returns a separate instance for each retrieved object" do
        _class_.create!(:address => "123 Main")
        deny { _class_.first.equal?(_class_.first) }
      end

      it "does not allow changes to one instance to affect another" do
        _class_.create!(:address => "123 Main")

        _class_.first.address = "456 Canal"
        assert { _class_.first.address == "123 Main" }
      end
      
      describe "reload" do
        it "returns a new instance of the object with contents from the data store" do
          house = _class_.create!(:address => "123 Main")
          house.address = "456 Zzz"
          
          expect { house.reload.address == "123 Main" }
        end
      end
    end
  end
  
end