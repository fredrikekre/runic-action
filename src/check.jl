#!/usr/bin/env julia

using Runic

function main()
    # Parse extensions from input
    extensions_str = get(ENV, "INPUT_RUNIC_EXTENSIONS", "jl")
    extensions = filter(!isempty, strip.(split(extensions_str, ",")))
    if isempty(extensions)
        extensions = ["jl"]
    end
    # Find all files matching the extensions
    patterns = ["*." * ext for ext in extensions]
    files = readlines(`git ls-files -- $patterns`)
    if isempty(files)
        exts = join(("." * ext for ext in extensions), ", ", ", and ")
        println("Runic action: No files with $exts extension(s) found in repo. Exiting.")
        return 0
    end
    # Build common flags
    common_flags = String[]
    if get(ENV, "INPUT_RUNIC_DOCSTRINGS", "false") == "true"
        push!(common_flags, "--docstrings")
    end
    # Run Runic.main
    rc = Runic.main(append!(append!(["--check", "--diff", "--verbose"], common_flags), files))
    # Format files, and leave the the repo dirty, if requested
    if rc != 0 && get(ENV, "INPUT_RUNIC_FORMAT_FILES", "false") == "true"
        rc2 = Runic.main(append!(append!(["--inplace"], common_flags), files))
        rc = max(rc, rc2)
    end
    return rc
end

if abspath(PROGRAM_FILE) == @__FILE__
    exit(main())
end
