require "ostruct"

module NotQuiteActiveRecord
  
  
  
  module BaseMixin
    def self.included(destination_class)
      
      class_methods = Module.new do
        def create!(args);     storage << args                          end
        def first;             new(storage.first)                       end

        private
        def storage;           @storage ||= []                          end
      end
      
      destination_class.send :extend, class_methods
    end
    
  end
end