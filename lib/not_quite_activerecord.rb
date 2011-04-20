require "ostruct"

module NotQuiteActiveRecord
  
  
  
  module BaseMixin
    def self.included(destination_class)
      
      class_methods = Module.new do
        def create!(raw);      wrap(insert(raw))                        end
        def first;             wrap(storage.first)                      end
        def find(id)           wrap(storage.find{|raw|raw[:id]==id})    end
        
        
        private
        
        def insert(raw)       
          assign_id(raw)
          storage << raw
          raw
        end
        
        def storage;           @storage ||= []                          end
        def wrap(raw);         raw ? new(raw) : nil                     end
        def assign_id(raw);    raw[:id] = next_id                       end
        def next_id;           @id = @id ? @id + 1 : 1                  end
      end
      
      destination_class.send :extend, class_methods
    end
        
    def reload
      self.class.find(self.id)
    end
  end
end