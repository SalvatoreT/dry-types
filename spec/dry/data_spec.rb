require 'spec_helper'

RSpec.describe Dry::Data do
  describe '.register' do
    it 'registers a new type constructor' do
      class FlatArray
        def self.constructor(input)
          input.flatten
        end
      end

      Dry::Data.register(
        :custom_array,
        Dry::Data::Type.new(FlatArray.method(:constructor), Array)
      )

      input = [[1], [2]]

      expect(Dry::Data[:custom_array][input]).to eql([1, 2])
    end
  end

  describe '.register_class' do
    it 'registers a class and uses `.new` method as default constructor' do
      module Test
        class User < Struct.new(:name)
        end
      end

      Dry::Data.register_class(Test::User)

      expect(Dry::Data['test.user'].primitive).to be(Test::User)
    end
  end

  describe '.[]' do
    it 'returns registered type for "string"' do
      expect(Dry::Data['string']).to be_a(Dry::Data::Type)
      expect(Dry::Data['string'].name).to eql('String')
    end

    it 'caches dynamically built types' do
      expect(Dry::Data['array<string>']).to be(Dry::Data['array<string>'])
    end
  end
end
