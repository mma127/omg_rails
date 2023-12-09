require 'saulabs/trueskill'

include Saulabs::TrueSkill

module Ratings
  class NamedRating < Saulabs::TrueSkill::Rating
    attr_reader :name

    def initialize(name, mean, deviation)
      super(mean, deviation)
      @name = name
    end
  end
end
