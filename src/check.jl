#!/usr/bin/env julia

using Runic

function main()
    # Find all *.jl files in the repo
    julia_files = readlines(`git ls-files -- '*.jl'`)
    if isempty(julia_files)
        println("Runic action: No files with `.jl` extension found in repo. Exiting.")
        return 0
    end
    # Set up Runic argument vector
    argv = prepend!(julia_files, ["--check", "--diff", "--verbose"])
    # Run Runic.main
    rc = Runic.main(argv)
    return rc
end

if abspath(PROGRAM_FILE) == @__FILE__
    exit(main())
end
