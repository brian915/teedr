# frozen_string_literal: true

require_relative "teedr/version"
require_relative "teedr/item"
require_relative "teedr/formatter"
require_relative "teedr/cli"

module Teedr
  class Error < StandardError; end
end
