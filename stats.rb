class Stat
    attr_reader :step, :previous_count, :new_count, :delta

    def initialize(values={})
        @values = values
        @step = values[:step]
        @previous_count = values[:previous_count]
        @new_count = values[:new_count]
        @delta = values[:delta]
    end
end

class Stats
    attr_reader :last
    def initialize
      @stats_list = []
      @stats = {}
      @last = nil
    end
  
    def capture(stat)
      @stats_list << Stat.new(stat)
      @last = stat
    end
  
    def calculate
      deltas = @stats_list.map(&:delta)
      @stats[:avg_delta] = avg(deltas)
      # devestation if the delta was negative and was at least 20% of the previous total
      @stats[:devestations] = @stats_list.select { |i| i.delta < 0 && (i.delta.abs / i.previous_count.to_f) > 0.2 }
      # boom if the delta was positive and was at least 20% of the previous total
      @stats[:growth_booms] = @stats_list.select { |i| i.delta > 0 && (i.delta / i.previous_count.to_f) > 0.2 }
    end
    
    def to_s
      o = ""
      o << "Generations: #{@stats_list.count}\n"
      o << "Average delta: #{@stats[:avg_delta]}\n"
      o << "Devestations (-20%): #{@stats[:devestations].count}\n"
      o << "Growth booms (+20%): #{@stats[:growth_booms].count}\n"
      o
    end
  
  private
    def avg(set)
        set.sum / set.count.to_f
    end
  end