$LOAD_PATH << "../lib"
require "uzoumuzou"

uu 1
uu "foo"
uu :foo
uu [:a, :b]
uu({:id => 1, :name => "alice"})
uu [{:id => 1, :name => "alice"}, {:id => 2, :name => "bob"}]
puts [{:id => 1, :name => "alice"}, {:id => 2, :name => "bob"}].to_ucsv
puts [{"a" => ["a"]}].to_ucsv
puts [{"a" => {"a" => 1}}].to_ucsv
# >> "1"
# >> "foo"
# >> "foo"
# >> "a","b"
# >> "id","1"
# >> "name","alice"
# >> "id","name"
# >> "1","alice"
# >> "2","bob"
# >> "id","name"
# >> "1","alice"
# >> "2","bob"
# >> "a"
# >> "[""a""]"
# >> "a"
# >> "{""a""=>1}"
