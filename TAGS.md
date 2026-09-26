# Machine tags

`./install` detects `LINUX` or `MAC` and reads additional tags from `tags` in
the repository root. `tags` is gitignored and optional. Write uppercase tags
separated by spaces or newlines:

```text
NO_SUDO
UTEXAS LAB_MACHINE
```

For another machine, `tags` could contain:

```text
NO_SUDO
UTEXAS AMRL
```

Tags are independent. Grouping tags on a line is only for readability. `LINUX`
and `MAC` are detected automatically; `ELSE` and `END` are reserved words.

Use markers in files under `templates/`:

```text
#====== LINUX ======
Linux content
###====== NO_SUDO ======
Linux content for machines without sudo
###====== ELSE ======
Linux content for machines with sudo
###====== END ======
#====== ELSE ======
Non-Linux content
#====== END ======
```

The leading `#` characters show nesting: use `#` for top-level
blocks, `###` for nested blocks, and `#####` for another level. A nested branch
is included only when its parent branch is included, giving an AND condition.
At the same depth, consecutive tag markers are alternatives, like the existing
`LINUX` / `MAC` blocks. The first matching tag wins. `ELSE` is optional and must
be last; `END` closes the block at its depth. Blocks can also be independent:

```text
#====== UTEXAS ======
Shared UT Austin settings
#====== END ======

#====== AMRL ======
AMRL-only settings
#====== END ======
```

The renderer reports mismatched and missing markers with a file and line number.
Run `./install --render-only` to generate files without running the package
installer or changing home-directory links.
