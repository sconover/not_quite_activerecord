require "rubygems"

require "spec/inspect"

require "fileutils"
FileUtils.rm_f("log/test.log")

module Kernel
  alias_method :original_require, :require
  def require(*args)
    Inspect.record_time("require"){original_require(*args)}
  end
end

require "minitest/spec"
require "pp"

require "wrong/assert"
require "wrong/adapters/minitest"
require "wrong/message/test_context"
require "wrong/message/string_comparison"
Wrong.config[:color] = true
Wrong.config.alias_assert :expect

module Kernel
  def xdescribe(str)
    puts "x'd out 'describe \"#{str}\"'"
  end
end

class MiniTest::Spec
  class << self
    def xit(str)
      puts "x'd out 'it \"#{str}\"'"
    end

  end
end

class MiniTest::Unit
  alias_method :original_run, :run
  
  def run(*args)
    Inspect.record_time("test_run") { original_run(*args) }
  end
end

MiniTest::Unit.after_tests { Inspect.print_stats }



$LOAD_PATH << "lib"

require "not_quite_activerecord"
require "sqlite3"
require "active_record"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Base.connection.execute(%{
  create table houses(id integer primary key, address varchar(100))
})

class ActiveRecord::ConnectionAdapters::SQLiteAdapter
  alias_method :original_execute, :execute
  
  def execute(*args)
    Inspect.record_time("DB.execute"){ original_execute(*args) }
  end
end


class NQHouse < OpenStruct
  include NotQuiteActiveRecord::BaseMixin
  
  def id
    @table[:id]
  end
end

class ARHouse < ActiveRecord::Base
  set_table_name "houses"
end

CLASS_GROUPS = [["real AR",      {:house => ARHouse}],
                ["not quite AR", {:house => NQHouse}]]

module Kernel
  def describe_classes(&block)
    CLASS_GROUPS.each do |name, classes|
      describe name do
        block.call(classes)
      end
    end
  end
end





MiniTest::Unit.autorun



def truncate(tables)
  tables.each{|table|ActiveRecord::Base.connection.execute("truncate #{table}")}
end
