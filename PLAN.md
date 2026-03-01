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
Class with five fields:
- body (string) -- the content
- created_at (Time, defaults to Time.now)
- type (string, defaults to "text")
- source (string) -- origin of the content: "inline" or "file"
- file_path (string, optional) -- populated when source is "file", nil otherwise

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
    "type": "text",
    "source": "inline",
    "file_path": null
  }

Markdown output (with YAML frontmatter):

  ---
  created_at: 2026-02-28T12:00:00Z
  type: text
  source: inline
  file_path: null
  ---
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
- Additional source types beyond "inline" and "file" (e.g. url, api, stdin) -- each may require its own metadata stored alongside source and file_path

---

## Build Order
1. Scaffold all gem files (gemspec, Gemfile, Rakefile, lib, exe, bin)
2. Verify with manual CLI test
3. Write specs using TDD going forward

## Minimum Spec
- Pass a string via positional arg, confirm formatted output is returned
- Pass a file via --file, confirm formatted output is returned

## See Also
- STATUS.md -- session log and next steps
- TUTORIAL.md -- project overview and education
