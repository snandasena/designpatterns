# Builder Design Pattern
#
# Intent: Lets you construct complex objects step by step. The pattern allows
# you to produce different types and representations of an object using the same
# construction code.

# The Builder interface specifies methods for creating the different parts of
# the Product objects.
class Builder
  # @abstract
  def produce_part_a
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def produce_part_b
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def produce_part_c
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# The Concrete Builder classes follow the Builder interface and provide specific
# implementations of the building steps. Your program may have several
# variations of Builders, implemented differently.
class ConcreteBuilder1 < Builder
  # A fresh builder instance should contain a blank product object, which is
  # used in further assembly.
  def initialize
    reset
  end

  def reset
    @product = Product1.new
  end

  # Concrete Builders are supposed to provide their own methods for retrieving
  # results. That's because various types of builders may create entirely
  # different products that don't follow the same interface. Therefore, such
  # methods cannot be declared in the base Builder interface (at least in a
  # statically typed programming language).
  #
  # Usually, after returning the end result to the client, a builder instance is
  # expected to be ready to start producing another product. That's why it's a
  # usual practice to call the reset method at the end of the `getProduct`
  # method body. However, this behavior is not mandatory, and you can make your
  # builders wait for an explicit reset call from the client code before
  # disposing of the previous result.
  def product
    product = @product
    reset
    product
  end

  def produce_part_a
    @product.add('PartA1')
  end

  def produce_part_b
    @product.add('PartB1')
  end

  def produce_part_c
    @product.add('PartC1')
  end
end

# It makes sense to use the Builder pattern only when your products are quite
# complex and require extensive configuration.
#
# Unlike in other creational patterns, different concrete builders can produce
# unrelated products. In other words, results of various builders may not always
# follow the same interface.
class Product1
  def initialize
    @parts = []
  end

  # @param [String] part
  def add(part)
    @parts << part
  end

  def list_parts
    print "Product parts: #{@parts.join(', ')}"
  end
end

# The Director is only responsible for executing the building steps in a
# particular sequence. It is helpful when producing products according to a
# specific order or configuration. Strictly speaking, the Director class is
# optional, since the client can control builders directly.
class Director
  # @return [Builder]
  attr_accessor :builder

  def initialize
    @builder = nil
  end

  # The Director works with any builder instance that the client code passes to
  # it. This way, the client code may alter the final type of the newly
  # assembled product.
  def builder=(builder)
    @builder = builder
  end

  # The Director can construct several product variations using the same
  # building steps.

  def build_minimal_viable_product
    @builder.produce_part_a
  end

  def build_full_featured_product
    @builder.produce_part_a
    @builder.produce_part_b
    @builder.produce_part_c
  end
end

# The client code creates a builder object, passes it to the director and then
# initiates the construction process. The end result is retrieved from the
# builder object.

director = Director.new
builder = ConcreteBuilder1.new
director.builder = builder

puts 'Standard basic product: '
director.build_minimal_viable_product
builder.product.list_parts

puts "\n\n"

puts 'Standard full featured product: '
director.build_full_featured_product
builder.product.list_parts

puts "\n\n"

# Remember, the Builder pattern can be used without a Director class.
puts 'Custom product: '
builder.produce_part_a
builder.produce_part_b
builder.product.list_parts
