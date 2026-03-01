# frozen_string_literal: true

require "json"
require "yaml"

module Teedr
  module Formatter
    def self.render_json(item)
      JSON.pretty_generate(
        body:       item.body,
        created_at: item.created_at.strftime("%Y-%m-%dT%H:%M:%SZ"),
        type:       item.type,
        source:     item.source,
        file_path:  item.file_path
      )
    end

    def self.render_markdown(item)
      frontmatter = {
        "created_at" => item.created_at.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "type"       => item.type,
        "source"     => item.source,
        "file_path"  => item.file_path
      }.to_yaml

      "#{frontmatter}---\n## [#{item.type}] #{item.created_at.strftime("%Y-%m-%d %H:%M:%S")}\n#{item.body}"
    end
  end
end
