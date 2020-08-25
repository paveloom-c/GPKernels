#!/bin/sh

echo '\n\e[1;36mInstalling Julia packages:\e[0m'

echo '\e[1;36m> Creating a kernel to use multithreading...\e[0m'
julia -e 'using IJulia; installkernel("Julia (4 threads)", env=Dict("JULIA_NUM_THREADS"=>"4"))' >/dev/null 2>&1

echo '\e[1;36m> Installing `LombScargle`...\e[0m'
julia -e 'using Pkg; Pkg.add("LombScargle"); using LombScargle' >/dev/null 2>&1

echo '\e[1;36m> Installing `Optim`...\e[0m'
julia -e 'using Pkg; Pkg.add("Optim"); using Optim' >/dev/null 2>&1

echo '\e[1;36m> Installing `PyCall`...\e[0m'
julia -e 'using Pkg; Pkg.add("PyCall"); using PyCall' >/dev/null 2>&1

echo '\e[1;36m> Installing `Soss`...\e[0m'
julia -e 'using Pkg; Pkg.add("Soss"); using Soss' >/dev/null 2>&1

echo '\e[1;36m> Installing `Statistics`...\e[0m'
julia -e 'using Pkg; Pkg.add("Statistics"); using Statistics' >/dev/null 2>&1

echo '\e[1;36m> Installing `Stheno`...\e[0m'
julia -e 'using Pkg; Pkg.add("Stheno"); using Stheno' >/dev/null 2>&1

echo '\e[1;36m> Installing `Zygote`...\e[0m'
julia -e 'using Pkg; Pkg.add("Zygote"); using Zygote' >/dev/null 2>&1
