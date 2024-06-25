# kramdown-haml

This is a HAML filter for using Kramdown to render the inline Markdown texts.

This is a fork of the [haml-kramdown gem](https://github.com/blindgaenger/kramdown-haml) but it does **not** use the `:kramdown` filter.

## Usage

Simply use the standard  `:markdown` filter:

Gemfile

    gem 'haml'
    gem 'kramdown'
    gem 'kramdown-haml'

foo.haml

    .content
      :markdown
        # Kramdown

        - foo
        - bar

That's it!

## Why?

There are only two established and pure Ruby Markdown engines: Maruku and
Kramdown. Although Maruku is widely used and stable it is not actively
maintained. At that time the current version 0.6.0 was published at May 4, 2009.

As some deprecation warnings arised for Maruku I was in need to find an
alternative and found Kramdown. Unfortunately there was no build-in Kramdown
support/filter in HAML ...
