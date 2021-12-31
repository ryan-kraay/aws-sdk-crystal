# frozen_string_literal: true

# Taken from objects.cr from v 0.7.6
  # Defines new_method as an alias of old_method.
  #
  # This creates a new method new_method that invokes old_method.
  #
  # Note that due to current language limitations this is only useful
  # when neither named arguments nor blocks are involved.
  #
  # ```
  # class Person
  #   getter name
  #
  #   def initialize(@name)
  #   end
  #
  #   alias_method full_name, name
  # end
  #
  # person = Person.new "John"
  # person.name #=> "John"
  # person.full_name #=> "John"
  # ```
  macro alias_method(new_method, old_method)
    def {{new_method.id}}(*args)
      {{old_method.id}}(*args)
    end
  end


module Seahorse
  module Client
    module Http

      # Provides a Hash-like interface for HTTP headers.  Header names
      # are treated indifferently as lower-cased strings.  Header values
      # are cast to strings.
      #
      #     headers = Http::Headers.new
      #     headers['Content-Length'] = 100
      #     headers[:Authorization] = 'Abc'
      #
      #     headers.keys
      #     #=> ['content-length', 'authorization']
      #
      #     headers.values
      #     #=> ['100', 'Abc']
      #
      # You can get the header values as a vanilla hash by calling {#to_h}:
      #
      #     headers.to_h
      #     #=> { 'content-length' => '100', 'authorization' => 'Abc' }
      #
      class Headers

        include Enumerable(Tuple(String, String))

        # @api private
        def initialize(headers = {} of String => String)
          @data = {} of String => String
          #headers.each_pair do |key, value|
          headers.each do |key, value|
            self[key] = value
          end
        end

        # @param [String] key
        # @return [String]
        def [](key)
          @data[key.to_s.downcase]
        end

        # @param [String] key
        # @param [String] value
        def []=(key, value)
          @data[key.to_s.downcase] = value.to_s
        end

        # @param [Hash] headers
        # @return [Headers]
        def update(headers)
          headers.each do |k, v|
            self[k] = v
          end
          self
        end

        # @param [String] key
        def delete(key)
          @data.delete(key.to_s.downcase)
        end

        def clear
          @data = {} of String => String
        end

        # @return [Array<String>]
        def keys
          @data.keys
        end

        # @return [Array<String>]
        def values
          @data.values
        end

        # @return [Array<String>]
        def values_at(*keys)
          @data.values_at(*keys.map{ |key| key.to_s.downcase })
        end

        # @yield [key, value]
        # @yieldparam [String] key
        # @yieldparam [String] value
        # @return [nil]
        # RKR: https://crystal-lang.org/api/1.2.2/Enumerable.html#each%28%26%3AT-%3E%29-instance-method
        # Hash does not support Enumeration: https://github.com/crystal-lang/crystal/issues/132
        def each(&block : Tuple(String, String) -> )
          @data.each do |key, value|
            yield({key, value})
          end
          nil
        end
        def each
          @data.each
        end
#        def each(&block)
#          if block_given?
#            @data.each_pair do |key, value|
#              yield(key, value)
#            end
#            nil
#          else
#            @data.enum_for(:each)
#          end
#        end
#        TODO: each_pair is redunant and not kept in Crystal
#        alias_method each_pair, each
        
        alias_method values, each_pair

        # @return [Boolean] Returns `true` if the header is set.
        def has_key?(key)
          @data.has_key?(key.to_s.downcase)
        end
        # RKR: Crystal uses has_key and not key?
        #alias_method has_key?, key?
        #alias_method include?, key?

        # @return [Hash]
        def to_hash
          @data.dup
        end
        alias_method to_h, to_hash

        # @api private
        def inspect
          @data.inspect
        end

      end
    end
  end
end
