#!/usr/bin/env julia

using Runic

function main()
    # Find all *.jl files in the repo
    ls_files_cmd = Cmd(["git"; "ls-files"; "--"; "*.jl"; [":!:$exclude" for exclude in ARGS]])
    julia_files = readlines(ls_files_cmd)
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
