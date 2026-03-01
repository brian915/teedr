# frozen_string_literal: true

module Teedr
  class Item
    attr_reader :body, :created_at, :type, :source, :file_path

    def initialize(body:, type: "text", created_at: Time.now, source: "inline", file_path: nil)
      @body       = body
      @type       = type
      @created_at = created_at
      @source     = source
      @file_path  = file_path
    end
  end
end
