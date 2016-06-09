require "active_support/core_ext/string"
require "csv"

module Uzoumuzou
  class Base
    def self.generate(*args, &block)
      new(*args, &block).generate
    end

    def initialize(rows, options = {})
      @options = {
        :header => true,
      }.merge(options)

      @rows = rows
    end

    def generate
      return "" if @rows.blank?
      if e = function_table.find { |e| e[:if].call(@rows) }
        @rows = e[:convert].call(@rows)
      end
      @rows = @rows.collect {|e| e.collect(&method(:value_normalize)) }
      @rows.collect {|e| CSV.generate_line(e, :force_quotes => true) }.join
    end

    private

    def value_normalize(value)
      value
    end

    def function_table
      [
        # {:a => 1, :b => 2}
        # [a][1]
        # [b][2]
        {
          :if      => -> e { e.kind_of?(Hash) },
          :convert => -> e { e.to_a },
        },

        # [{:a => 1, :b => 2}, {:a => 3, :b => 4}]
        # [a][b]
        # [1][2]
        # [3][4]
        {
          :if      => -> e { e.kind_of?(Array) && e.all?{|e|e.kind_of?(Hash)} },
          :convert => -> e {
            keys = e.inject([]) { |a, e| a | e.keys }
            body = e.collect { |e| e.values_at(*keys) }
            if @options[:header]
              [keys] + body
            else
              body
            end
          },
        },

        # [[:a, :b], [ 1,  2], [ 3,  4]]
        # [a][b]
        # [1][2]
        # [3][4]
        {
          :if      => -> e { e.kind_of?(Array) && e.all?{|e|e.kind_of?(Array)} },
          :convert => -> e { e },
        },

        # [:a, :b]
        # [a][b]
        {
          :if      => -> e { e.kind_of?(Array) },
          :convert => -> e { [e] },
        },

        # :a
        # [a]
        {
          :if      => -> e { true },
          :convert => -> e { [[e]] },
        },
      ]
    end
  end

  class DirectGenerator < Base
  end

  require "rails-html-sanitizer"

  class Generator < Base
    def value_normalize(value)
      s = value.to_s.strip
      if s.start_with?("<") && s.end_with?(">")
        s = sanitizer.sanitize(s)
      end
      s
    end

    def sanitizer
      @sanitizer ||= Rails::Html::FullSanitizer.new
    end
  end

  def self.generate(*args, &block)
    Generator.new(*args, &block).generate
  end
end

if $0 == __FILE__
  list = {:a => 1, :b => 2}
  puts Uzoumuzou::Base.generate({:a => 1, :b => 2})

  list = [{:a => 1, :b => 2}, {:a => 3, :b => 4}]
  puts Uzoumuzou::Base.generate(list)

  list = [[:a, :b], [ 1,  2], [ 3,  4]]
  puts Uzoumuzou::Base.generate(list)

  list = [:a, :b]
  puts Uzoumuzou::Base.generate(list)

  list = :a
  puts Uzoumuzou::Base.generate(list)

  list = "<a>x</a>"
  puts Uzoumuzou::DirectGenerator.generate(list)

  list = "<a>x</a>"
  puts Uzoumuzou::Generator.generate(list)

  require "./core_ext"
  uu({:a => 1, :b => 2})
  uu([{:a => 1, :b => 2}, {:a => 3, :b => 4}])
  uu([[:a, :b], [ 1,  2], [ 3,  4]])
  uu([:a, :b])
  uu(:a)
  uu("<a>x</a>")
end
# >> "Key","Value"
# >> "a","1"
# >> "b","2"
# >> "a","b"
# >> "1","2"
# >> "3","4"
# >> "a","b"
# >> "1","2"
# >> "3","4"
# >> "a","b"
# >> "a"
# >> "<a>x</a>"
# >> "x"
# >> "Key","Value"
# >> "a","1"
# >> "b","2"
# >> "a","b"
# >> "1","2"
# >> "3","4"
# >> "a","b"
# >> "1","2"
# >> "3","4"
# >> "a","b"
# >> "a"
# >> "x"
