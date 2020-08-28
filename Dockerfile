# Base image for the build stage
FROM paveloom/binder-base:0.1.2 AS fitsio

# Switch to the `root` user
USER root

# Copy the scripts to the root
COPY fitsio-scripts /scripts

# Allow their execution
RUN chmod -R +x /scripts

# Install build dependencies
RUN /scripts/root/build/install-build-dependencies.sh

# Switch back to the non-root user
USER $USER

# Install the `fitsio` package
RUN /scripts/user/fitsio/install-fitsio.sh

# Base image for the main stage
FROM paveloom/binder-julia-plots:0.1.1 AS main

# Copy the `fitsio` package
COPY --from=fitsio --chown=$USER:$USER $HOME/.local/lib/python3.8/site-packages/fitsio $HOME/.local/lib/python3.8/site-packages/fitsio

# Copy the scripts to the root
COPY main-scripts /scripts

# Allow their execution
RUN sudo chmod -R +x /scripts

# Install Python packages
RUN /scripts/user/python/install-python-packages.sh

# Install Julia packages
RUN /scripts/user/julia/install-julia-packages.sh

# Delete the scripts
RUN sudo rm -rf /scripts