#!/usr/bin/env julia

using Pkg

function main()
    # Parse the version number/commit id from the input
    input_version = get(ENV, "INPUT_RUNIC_VERSION", "master")
    # Note: tryparse(VersionNumber, input_version) would be nice but:
    # ```
    # julia> tryparse(VersionNumber, "500ba0988fbbd6632a0b00a78695cc4ae1ad5af7")
    # v"500.0.0-ba0988fbbd6632a0b00a78695cc4ae1ad5af7"
    # ```
    if occursin(r"^v?\d+(\.\d+){0,2}$", input_version)
        version_kwarg = (version = input_version,)
    else
        # Assume it is a git revision (commit id, branch name, tag)
        version_kwarg = (rev = input_version,)
    end
    # Install Runic
    Pkg.add(; name = "Runic", uuid = "62bfec6d-59d7-401d-8490-b29ee721c001", version_kwarg...)
    return 0
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
