#!/usr/bin/env julia

using Runic

function main()
    # Find all *.jl files in the repo
    julia_files = readlines(`git ls-files -- '*.jl'`)
    if isempty(julia_files)
        println("Runic action: No files with `.jl` extension found in repo. Exiting.")
        return 0
    end
    # Run Runic.main
    rc = Runic.main(append!(["--check", "--diff", "--verbose"], julia_files))
    # Format files, and leave the the repo dirty, if requested
    if rc != 0 && get(ENV, "INPUT_RUNIC_FORMAT_FILES", "false") == "true"
        rc2 = Runic.main(append!(["--inplace"], julia_files))
        rc = max(rc, rc2)
    end
    return rc
end

if abspath(PROGRAM_FILE) == @__FILE__
    exit(main())
end
