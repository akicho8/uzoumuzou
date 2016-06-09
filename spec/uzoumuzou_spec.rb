require "spec_helper"

describe Uzoumuzou do
  it "空の場合" do
    Uzoumuzou.generate([]).should == ""
  end

  it do
    rows = {:a => 1, :b => 2}
    Uzoumuzou::Base.generate(rows).should == <<~EOT
    "a","1"
    "b","2"
    EOT

    rows = [{:a => 1, :b => 2}, {:a => 3, :b => 4}]
    Uzoumuzou::Base.generate(rows).should == <<~EOT
    "a","b"
    "1","2"
    "3","4"
    EOT

    rows = [[:a, :b], [ 1,  2], [ 3,  4]]
    Uzoumuzou::Base.generate(rows).should == <<~EOT
    "a","b"
    "1","2"
    "3","4"
    EOT

    rows = [:a, :b]
    Uzoumuzou::Base.generate(rows).should == <<~EOT
    "a","b"
    EOT

    rows = :a
    Uzoumuzou::Base.generate(rows).should == <<~EOT
    "a"
    EOT

    rows = "<a>x</a>"
    Uzoumuzou::DirectGenerator.generate(rows).should == <<~EOT
    "<a>x</a>"
    EOT

    rows = "<a>x</a>"
    Uzoumuzou::Generator.generate(rows).should == <<~EOT
    "x"
    EOT

    # uu({:a => 1, :b => 2})
    # uu([{:a => 1, :b => 2}, {:a => 3, :b => 4}])
    # uu([[:a, :b], [ 1,  2], [ 3,  4]])
    # uu([:a, :b])
    # uu(:x)
    # uu("<a>x</a>")
  end
end
