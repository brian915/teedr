# frozen_string_literal: true

require "thor"

module Teedr
  class CLI < Thor
    default_command :ingest

    desc "ingest", "Ingest content and output a structured feed item"
    option :body,   type: :string,  desc: "Content to ingest"
    option :file,   type: :string,  desc: "Path to file containing content"
    option :type,   type: :string,  default: "text", desc: "Item type"
    option :format, type: :string,  default: "json", desc: "Output format (json or markdown)"
    option :output, type: :string,  desc: "Write output to file instead of stdout"
    def ingest(*args)
      body = resolve_body(args)
      item = Teedr::Item.new(body: body, type: options[:type])
      result = render(item)
      write_output(result)
    end

    private

    def resolve_body(args)
      if options[:file]
        File.read(options[:file])
      elsif options[:body]
        options[:body]
      elsif args.first
        args.first
      else
        warn "Error: provide content, --body, or --file"
        exit 1
      end
    end

    def render(item)
      case options[:format]
      when "markdown"
        Teedr::Formatter.render_markdown(item)
      else
        Teedr::Formatter.render_json(item)
      end
    end

    def write_output(result)
      if options[:output]
        File.write(options[:output], result)
      else
        puts result
      end
    end
  end
end
