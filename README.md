# Description

This branch is designed to maintain a Docker image providing a development environment
for this project. The image can be pulled from
[DockerHub](https://hub.docker.com/r/paveloom/c-gpkernels) or
[GitHub Packages](https://github.com/paveloom-c/GPKernels/packages/379510). For more
information about the content of the image, see under the spoiler.

<details>
<summary>Content of the image</summary>
<ul>
  <li>
    Base image:
    <a href="https://github.com/paveloom-d/binder-julia-plots">paveloom/binder-julia-plots</a>
    (0.1.1)
  </li>
  <li>
    Python (3.8):
    <ul>
      <li>Additional packages:</li>
      <ul>
        <li><a href="https://github.com/dfm/kplr">kplr</a></li>
      </ul>
    </ul>
  </li>
  <li>
    Julia (1.5.1):
    <ul>
      <li>Additional packages:</li>
      <ul>
        <li><a href="https://github.com/JuliaAstro/LombScargle.jl">LombScargle.jl</a></li>
        <li><a href="https://github.com/stevengj/NBInclude.jl">NBInclude.jl</a></li>
        <li><a href="https://github.com/JuliaNLSolvers/Optim.jl/">Optim.jl</a></li>
        <li><a href="https://github.com/JuliaPy/PyCall.jl">PyCall.jl</a></li>
        <li><a href="https://github.com/willtebbutt/Stheno.jl">Stheno.jl</a></li>
        <li><a href="https://github.com/FluxML/Zygote.jl">Zygote.jl</a></li>
      <ul>
    </ul>
  </li>
</ul>
</details>
