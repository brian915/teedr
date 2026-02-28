# frozen_string_literal: true

module Teedr
  class Item
    attr_reader :body, :created_at, :type

    def initialize(body:, type: "text", created_at: Time.now)
      @body       = body
      @type       = type
      @created_at = created_at
    end
  end
end
