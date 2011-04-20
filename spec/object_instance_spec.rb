require "spec/helper"


describe_classes do |k|
  describe "instance separation" do
  
    it "autoincrements the id" do
      main = k[:house].create!(:address => "123 Main")
      canal = k[:house].create!(:address => "456 Canal")

      expect { main.id.is_a?(Numeric) }
      expect { canal.id.is_a?(Numeric) }
      expect { canal.id > main.id }
    end
  
    it "returns a separate instance for each retrieved object" do
      k[:house].create!(:address => "123 Main")
      deny { k[:house].first.equal?(k[:house].first) }
    end

    it "does not allow changes to one instance to affect another" do
      k[:house].create!(:address => "123 Main")

      k[:house].first.address = "456 Canal"
      expect { k[:house].first.address == "123 Main" }
    end
  
    describe "reload" do
      it "returns a new instance of the object with contents from the data store" do
        house = k[:house].create!(:address => "123 Main")
        house.address = "456 Zzz"
      
        expect { house.reload.address == "123 Main" }
      end
    end
  
  end
end