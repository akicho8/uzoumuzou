require "active_support/core_ext/kernel/concern"

module Uzoumuzou
  concern :ActiveRecord do
    class_methods do
      def to_ucsv(**options)
        Uzoumuzou.generate(all.collect(&:attributes), options)
      end
    end

    def to_ucsv(**options)
      Uzoumuzou.generate(attributes, options)
    end
  end
end

Kernel.class_eval do
  def uu(object, **options)
    if object.respond_to?(:to_ucsv)
      object.to_ucsv(options).display
    else
      Uzoumuzou.generate(object).display
    end
  end
end

[Array, Hash, Symbol, String, Numeric].each do |e|
  e.class_eval do
    def to_ucsv(**options)
      Uzoumuzou.generate(self, options)
    end
  end
end
