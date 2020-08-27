# Base image for the build stage
FROM paveloom/binder-base:0.1.1 as fitsio

# Switch to the `root` user
USER root

# Copy the scripts to the root
COPY build-scripts /scripts

# Allow their execution
RUN chmod -R +x /scripts

# Install build dependencies
RUN /scripts/root/build/install-build-dependencies.sh

# Switch back to the non-root user
USER $USER

# Install the `fitsio` package
RUN /scripts/user/fitsio/install-fitsio.sh

# Base image for the main stage
FROM paveloom/binder-julia-plots:0.1.0

# Copy the `fitsio` package
COPY --from=fitsio $HOME/.local/lib/python3.8/site-packages/fitsio $HOME/.local/lib/python3.8/site-packages/fitsio

# Copy the scripts to the root
COPY main-scripts /scripts

# Allow their execution
RUN sudo chmod -R +x /scripts

# Install Python packages
RUN /scripts/user/python/install-python-packages.sh

# Install Julia packages
RUN /scripts/user/julia/install-julia-packages.sh

# Remove scripts
RUN sudo rm -rf /scripts