$LOAD_PATH << "../lib"
require "active_record"
require "uzoumuzou"

ActiveRecord::Base.include(Uzoumuzou::ActiveRecord)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end
end

class User < ActiveRecord::Base
end

["alice", "bob"].each{|name| User.create!(:name => name) }

uu User
uu User.first
uu User.limit(1)
