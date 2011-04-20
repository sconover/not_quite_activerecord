require "spec/helper"

describe "#find" do
  describe "by id" do  
    [ARHouse, NQHouse].each do |_class_|
      describe _class_.name do
        it "looks the correct house up by id" do
          main = _class_.create!(:address => "123 Main")
          canal = _class_.create!(:address => "456 Canal")
    
          expect { _class_.find(main.id).address == "123 Main" }
          expect { _class_.find(canal.id).address == "456 Canal" }
        end
      end
    end
  end
end