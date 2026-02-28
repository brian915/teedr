# teedr v0 Plan

## Context

Building `teedr`, a Ruby gem and CLI tool that ingests content and marshals it into structured feed items (JSON or Markdown). v0 is a development/testing scaffold -- no Rails UI yet. The gem structure follows ~/bin/poster_child/ as the reference pattern.

Target directory: /Users/brian/dotfiles/bin/teedr/ (exists, empty)

---

## Structure

```
teedr/
  exe/
    teedr                  # thin entry point, starts CLI
  lib/
    teedr.rb               # requires all lib files, defines Teedr::Error
    teedr/
      version.rb           # VERSION constant
      item.rb              # feed item model (body, created_at, type)
      formatter.rb         # JSON and Markdown output
      cli.rb               # Thor-based CLI
  spec/
    spec_helper.rb
    teedr/
      item_spec.rb
      formatter_spec.rb
      cli_spec.rb
  bin/
    setup                  # bundle install helper
    console                # irb console helper
  teedr.gemspec
  Gemfile
  Rakefile
  .rubocop.yml
  .rspec
  .gitignore
```

---

## Key Files

### exe/teedr
Thin wrapper -- require the gem, call Teedr::CLI.start.

### lib/teedr/item.rb
Struct-like class with three fields:
- body (string) -- the content
- created_at (Time, defaults to Time.now)
- type (string, defaults to "text")

### lib/teedr/formatter.rb
Two methods:
- to_json(item) -- renders item as JSON
- to_markdown(item) -- renders item as a simple Markdown block

### lib/teedr/cli.rb
Thor CLI with one command: ingest

Options:
- --body TEXT -- inline content
- --file PATH -- read content from file
- --type TYPE -- item type (default: "text")
- --format json|markdown -- output format (default: json)
- --output PATH -- write to file instead of stdout

### teedr.gemspec
Mirrors poster-child.gemspec: name, version, author, ruby >= 3.2.0, executables ["teedr"], Thor dependency.

---

## Feed Item Schema (v0)

JSON output:

  {
    "body": "content here",
    "created_at": "2026-02-28T12:00:00Z",
    "type": "text"
  }

Markdown output:

  ## [text] 2026-02-28 12:00:00
  content here

---

## Future Enhancements (noted, not built)
- Pluggable output formats (CSV, HTML)
- Rails/Turbo/Hotwire view layer
- Persistent storage (SQLite/ActiveRecord)

---

## Verification
1. cd /Users/brian/dotfiles/bin/teedr && bundle install
2. exe/teedr ingest --body "hello world" -- should print JSON to stdout
3. exe/teedr ingest --file somefile.txt --format markdown -- should print Markdown
4. exe/teedr ingest --body "test" --output /tmp/out.json -- should write to file
