```@meta
EditURL = "nothing"
```

# GPKernels

### What is this?

This is the documentation of a project to investigate the influence of the selection of
kernels for [Gaussian processes](https://en.wikipedia.org/wiki/Gaussian_process) on the
process of modeling light curves of different objects from the
[Kepler Archive](https://archive.stsci.edu/kepler/data_search/search.php). For a look under
the hood, visit the [project repository](https://github.com/paveloom-c/GPKernels).

### What objects?

These are the [F-type stars](https://en.wikipedia.org/wiki/F-type_main-sequence_star)
mentioned in the paper
[Mathur et al. (2014)](https://www.mendeley.com/catalogue/6be7d4d7-360f-3acb-9fc5-941020e088da/).
They have published rotation periods, which are interesting to use when testing models. See
more about object identifiers on the [`IDs`](@ref IDs) page.

### Models, huh? What do they look like?

Essentially it's a combination of a periodic kernel, some kernel adding attenuation,
and white noise. That is, these are models of a quasi-periodic process. See the
[`IDs`](@ref IDs) page for a complete list of models used.

### What do I do next from here?

Well, there's a section on the sidebar with all the notebooks, maybe that's worth checking
out.

### Wait, notebooks?

Yes, Jupyter Notebooks converted to HTML pages. Their two main types in this work are
_preambles_, which contain data about an object, and _models_, which contain the process
of modeling a given time series. Accordingly, they are organized by these identifiers.
