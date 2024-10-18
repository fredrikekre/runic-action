# runic-action

A GitHub Action to run the [Runic.jl](https://github.com/fredrikekre/Runic.jl)
code formatter.

## Usage

Full (copy-pasteable) workflow file example:

```yml
name: Runic
on:
  push:
    branches:
      - 'master'
      - 'release-'
    tags:
      - '*'
  pull_request:
jobs:
  runic:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # - uses: julia-actions/setup-julia@v2
      #   with:
      #     version: '1.11'
      # - uses: julia-actions/cache@v2
      - uses: fredrikekre/runic-action@v1
        with:
          version: '1'
```

This runs Runic's check mode, with diff output, on all Julia files in the
checked out repository.

The [`julia-actions/setup-julia`](https://github.com/julia-actions/setup-julia)
and [`julia-actions/cache`](https://github.com/julia-actions/cache) actions are
optional. Without the former `runic-action` will use whatever julia version is
installed in the runner by default.

### Inputs

`runic-action` accepts the following inputs:

```yml
- uses: fredrikekre/runic-action@v1
  with:
    # Runic.jl version number or git revision (commit, tag, branch).
    #
    # It is __highly recommended__ to pin this version to a full version number (e.g.
    # `major.minor.patch`) to avoid CI failures due to changes in Runic.jl since even
    # formatting bug fixes may result in formatting changes that would then fail the
    # workflow.
    #
    # By default runic-action@v1 uses the latest release in the v1 release series.
    version: '1'
```
