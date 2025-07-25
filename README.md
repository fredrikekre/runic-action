# runic-action

A GitHub Action to run the [Runic.jl](https://github.com/fredrikekre/Runic.jl)
code formatter.

## Usage

Full (copy-pasteable) workflow file example:

```yml
---
name: Check
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
    name: Runic formatting
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

> [!IMPORTANT]
> Please be aware of Runic's
> [version policy](https://github.com/fredrikekre/Runic.jl?tab=readme-ov-file#version-policy)
> when configuring the version. Pinning to a major release (as above with `version: '1'`)
> may cause occasional CI failures whenever there is a new minor release of Runic that
> happens to impact your code base. When this happens you simply have to i) re-run Runic on
> the new version, ii) commit the result, and iii) add the commit to
> [the ignore list](https://github.com/fredrikekre/Runic.jl?tab=readme-ov-file#ignore-formatting-commits-in-git-blame).
> This is still recommended since minor releases should be relatively rare, and if you use
> Runic you presumably want these minor bugfixes to be applied to your code base. The
> alternative is to pin to a minor (or patch) version and manually upgrade to new minor
> versions.

### Posting format diff as GitHub review comments

By passing `format_files: true` to the action and combining with e.g.
[reviewdog/action-suggester](https://github.com/reviewdog/action-suggester) a format diff
will be posted as GitHub review comments. Note that in order for the job to exit with
appropriate error you need to also configure `continue-on-error` for the runic job, and set
the `fail_level` (or similar for any other follow up action you are using) as in the example
below.

```yml
---
name: Check
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
    name: Runic formatting
    runs-on: ubuntu-latest
    # Permissions needed for reviewdog/action-suggester to post comments
    permissions:
      contents: read
      checks: write
      issues: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
      # - uses: julia-actions/setup-julia@v2
      #   with:
      #     version: '1.11'
      # - uses: julia-actions/cache@v2
      - uses: fredrikekre/runic-action@v1
        with:
          version: '1'
          format_files: true
        # Fail on next step instead
        continue-on-error: ${{ github.event_name == 'pull_request' }}
      - uses: reviewdog/action-suggester@v1
        if: github.event_name == 'pull_request'
        with:
          tool_name: Runic
          fail_level: warning
```

### Inputs

`runic-action` accepts the following inputs:

```yml
- uses: fredrikekre/runic-action@v1
  with:
    # Runic.jl version number or git revision (commit, tag, branch).
    # Please see the note above about Runic's version policy.
    # By default runic-action@v1 uses the latest release in the v1 release series.
    version: '1'
    # When `true`, format the files and leave the repository dirty (in addition to running
    # the usual check). Note that the exit code of the step is still the exit code of check.
    format_files: false
```
