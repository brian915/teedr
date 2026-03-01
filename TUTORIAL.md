# teedr -- Project Overview and Tutorial

This document is a running educational reference for the teedr project. It will grow as the project grows.

---

## What is teedr?

teedr is a Ruby gem and CLI tool that ingests content (text, files) and marshals it into structured feed items. The output is JSON or Markdown, intended for eventual consumption by a Rails/Turbo/Hotwire social feed UI.

v0 is a development and testing scaffold -- no UI yet. The focus is on the ingestion pipeline and data structure.

---

## Directory Structure

```
teedr/
  exe/
    teedr            # CLI executable entry point (standard gem convention since Bundler 1.9)
  lib/
    teedr.rb         # Root require file -- loads all lib files, defines Teedr::Error
    teedr/
      version.rb     # VERSION constant
      item.rb        # Feed item model
      formatter.rb   # JSON and Markdown output
      cli.rb         # Thor-based CLI
  spec/
    spec_helper.rb
    teedr/
      item_spec.rb
      formatter_spec.rb
      cli_spec.rb
  bin/
    setup            # Runs bundle install (development helper)
    console          # Opens an IRB session with the gem loaded (development helper)
  PLAN.md            # Project plan and schema reference
  STATUS.md          # Session log and next steps
  TUTORIAL.md        # This file
  teedr.gemspec      # Gem specification
  Gemfile            # Development dependencies
  Rakefile           # Rake tasks (spec, rubocop)
  .rubocop.yml       # RuboCop linting config
  .rspec             # RSpec config
  .gitignore         # Git ignore rules
```

Note: `exe/` holds the user-facing executable. `bin/` holds development helpers only. This is the standard Ruby gem convention.

---

## Key Files Explained

### exe/teedr

The entry point. Four lines: require the gem, start the CLI. Nothing else belongs here.

```ruby
#!/usr/bin/env ruby
require "teedr"
Teedr::CLI.start
```

### lib/teedr.rb

Loads all the gem's parts in dependency order and defines the base error class.

### lib/teedr/item.rb

The feed item model. A plain Ruby class (not ActiveRecord) with five fields:

- body -- the content
- created_at -- timestamp, defaults to now
- type -- content type, defaults to "text"
- source -- where the content came from: "inline" or "file"
- file_path -- the file path if source is "file", nil otherwise

### lib/teedr/formatter.rb

Renders an Item into output. Two methods:

- render_json(item) -- produces pretty-printed JSON including all fields
- render_markdown(item) -- produces a Markdown document with YAML frontmatter containing all metadata fields, followed by the body

### lib/teedr/cli.rb

The command-line interface, built with Thor. One command: ingest. Set as the default command so it can be omitted.

Options:
- positional arg -- body shorthand (e.g. teedr ingest "hello")
- --body TEXT -- inline content
- --file PATH -- read content from a file
- --type TYPE -- item type (default: text)
- --format json|markdown -- output format (default: json)
- --output PATH -- write to a file instead of stdout

---

## Feed Item Schema

JSON:

```json
{
  "body": "content here",
  "created_at": "2026-02-28T12:00:00Z",
  "type": "text",
  "source": "inline",
  "file_path": null
}
```

Markdown (with YAML frontmatter):

```
---
created_at: 2026-02-28T12:00:00Z
type: text
source: inline
file_path: null
---
## [text] 2026-02-28 12:00:00
content here
```

---

## Naming Conventions

- Files: snake_case (item.rb, formatter.rb)
- Classes and modules: CamelCase (Teedr::Item, Teedr::Formatter)
- Methods: snake_case verbs (render_json, resolve_body)
- Constants: UPPERCASE (Teedr::VERSION)
- CLI executable: matches gem name (teedr)

---

## Code Style

- 2-space indentation (standard Ruby)
- frozen_string_literal: true on all lib files
- Method names chosen to avoid Ruby stdlib collisions (render_json not to_json)
- YAML used for metadata and config files throughout the project
- Thor used for CLI (same pattern as poster_child reference gem)

---

## Running the CLI

```
bundle exec exe/teedr ingest "hello world"
bundle exec exe/teedr --body "hello world" --format markdown
bundle exec exe/teedr --file path/to/file.txt
bundle exec exe/teedr ingest "hello world" --output /tmp/out.json
```

---

## Reference and Further Reading

- Thor gem (CLI framework): https://github.com/rails/thor
- Bundler gem structure guide: https://bundler.io/guides/creating_gem.html
- Ruby gem conventions: https://guides.rubygems.org/make-your-own-gem/
- YAML frontmatter (used by Obsidian, Jekyll, and others): https://jekyllrb.com/docs/front-matter/
- poster_child (reference gem for this project): ~/bin/poster_child/
