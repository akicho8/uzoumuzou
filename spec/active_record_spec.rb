require "spec_helper"
require "active_record"

ActiveRecord::Base.send(:include, Uzoumuzou::ActiveRecord)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end
end

class User < ActiveRecord::Base
end

describe Uzoumuzou::ActiveRecord do
  before do
    2.times { |i| User.create!(:name => i) }
  end

  it do
    User.to_ucsv.should == <<~EOT
"id","name"
"1","0"
"2","1"
EOT
    User.first.to_ucsv.should == <<~EOT
"id","1"
"name","0"
EOT
  end
end
