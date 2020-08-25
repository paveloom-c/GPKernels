# Base image
FROM paveloom/binder-julia-plots:0.1.0

# Copy the scripts to the root
COPY scripts /scripts

# Allow their execution
RUN sudo chmod -R +x /scripts

# Install Python packages
RUN /scripts/user/python/install-python-packages.sh

# Install Julia packages
RUN /scripts/user/julia/install-julia-packages.sh

# Remove scripts
RUN sudo rm -rf /scripts