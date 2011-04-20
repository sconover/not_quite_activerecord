require "benchmark"
require "spec/numeric_extensions"

module Inspect
  
  @@stats = {}
  def self.record_time(type)
    result = nil
    duration = Benchmark.realtime {
      result = yield
    }
    stat_record = @@stats[type] ||= {:count => 0, :total_duration => 0}
    stat_record[:count] += 1
    stat_record[:total_duration] += duration
    result
  end
  
  def self.print_stats
    $stderr.puts get_stats
  end
  
  def self.get_stats
    str = ""
    
    if @@stats.length>0
      
      stat_name = "stat name".ljust(40)
      count = "count".ljust(10)
      total_ms = "total s  "
      percall_ms = "percall ms  "
      calls_per_s = "calls per s"

      cols = [
        stat_name,
        count,
        total_ms,
        percall_ms,
        calls_per_s,
      ]
      header_line = "  #{cols.join}"
      str += header_line + "\n"
      str += "  " + ("-" * cols.join.length) + "\n"

      
      @@stats.keys.sort.each do |stat_type|
        stat = @@stats[stat_type]
        
        
        
        str += [
          "  #{stat_type.ljust(stat_name.length)}",
          stat[:count].to_s.ljust(count.length),
          stat[:total_duration].precision(3).to_s.ljust(total_ms.length),
          ((stat[:total_duration].to_f/stat[:count].to_f) * 1000).precision(2).ljust(percall_ms.length),
          (stat[:count].to_f/stat[:total_duration].to_f).precision(3)
        ].join
        str += "\n"
      end
    end
    
    str
  end
  
  
  module RequireStatGathering

    def self.included(other)
      other.send(:alias_method, :original_require_without_stat_gathering, :require)
      other.send(:alias_method, :require, :require_with_stat_gathering)
    end

    @@require_to_time = {}

    def require_with_stat_gathering(file)
      start = Time.now

      original_require_without_stat_gathering(file)

      diff = (Time.now.to_f-start.to_f).to_f

      unless @@require_to_time[file]
        @@require_to_time[file] = diff
      end
    end

    def print_require_times_sorted
      entries = []
      @@require_to_time.each{|entry|entries << entry}
      entries.sort!{|a,b|b[1]<=>a[1]}

      entries.each{|entry|puts "#{entry[1].to_s.ljust(10)} #{entry[0]}"}

    end
  end

  def self.profile_requires
    Object.send(:include, RequireStatGathering)

    yield

    RequireStatGathering.print_require_times_sorted
  end
end
