module Uzoumuzou
  class Railtie < Rails::Railtie
    initializer "uzoumuzou" do
      ActiveSupport.on_load(:active_record) do
        include Uzoumuzou::ActiveRecord
      end
    end
  end
end
