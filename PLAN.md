# teedr v0 Plan

## Context

Building `teedr`, a Ruby gem and CLI tool that ingests content and marshals it into structured feed items (JSON or Markdown). v0 is a development/testing scaffold -- no Rails UI yet. The gem structure follows ~/bin/poster_child/ as the reference pattern.

Target directory: /Users/brian/dotfiles/bin/teedr/

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
Class with three fields:
- body (string) -- the content
- created_at (Time, defaults to Time.now)
- type (string, defaults to "text")

### lib/teedr/formatter.rb
Two methods:
- render_json(item) -- renders item as JSON
- render_markdown(item) -- renders item as a simple Markdown block

### lib/teedr/cli.rb
Thor CLI with one command: ingest, set as default_command so the subcommand is optional.
Both forms work:
- bundle exec exe/teedr "hello world"
- bundle exec exe/teedr ingest "hello world"

Options:
- --body TEXT -- inline content
- --file PATH -- read content from file
- --type TYPE -- item type (default: "text")
- --format json|markdown -- output format (default: json)
- --output PATH -- write output to file instead of stdout
- positional arg -- first argument used as body if --body and --file are omitted

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

## Code Style Notes
- 2-space indentation (standard Ruby, per CLAUDE.md -- overrides code-skillz legacy setting)
- frozen_string_literal on all lib files
- Method names: render_json, render_markdown (avoids collision with Ruby stdlib to_json)

---

## Future Enhancements (noted, not built)
- Rails/Turbo/Hotwire view layer consuming teedr output
- Persistent storage (SQLite/ActiveRecord)

---

## Build Order
1. Scaffold all gem files (gemspec, Gemfile, Rakefile, lib, exe, bin)
2. Verify with manual CLI test (see Verification below)
3. Write specs after first round of files passes manually

## Minimum Spec (written after scaffold)
- Pass a string via positional arg, confirm formatted output is returned
- Pass a file via --file, confirm formatted output is returned

---

## Progress Log

### 2026-02-28
- Created directory structure (exe/, lib/teedr/, spec/teedr/, bin/)
- Wrote lib/teedr/version.rb
- Wrote teedr.gemspec
- Wrote Gemfile
- Wrote Rakefile
- Wrote lib/teedr/item.rb
- Wrote lib/teedr/formatter.rb (render_json, render_markdown)
- Wrote lib/teedr/cli.rb (ingest command with --body, --file, --type, --format, --output, positional arg)
- Wrote lib/teedr.rb (root require file)
- Wrote exe/teedr (executable entry point)
- Wrote bin/setup, bin/console
- Wrote .rubocop.yml, .rspec, .gitignore
- Pending: add default_command :ingest to CLI so subcommand is optional
- Pending: bundle install and manual verification
- Pending: write specs

---

## Verification
1. bundle install
2. bundle exec exe/teedr ingest "hello world" -- JSON to stdout
3. bundle exec exe/teedr "hello world" -- same result, no subcommand needed
4. bundle exec exe/teedr ingest --file somefile.txt --format markdown
5. bundle exec exe/teedr ingest "test" --output /tmp/out.json
