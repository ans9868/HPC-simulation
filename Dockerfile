FROM rockylinux:9

# Install basic dependencies
RUN dnf -y update && \
    dnf -y install wget git gcc gcc-c++ make \
    squashfs-tools libseccomp-devel cryptsetup \
    glib2-devel pkgconfig which fuse3-devel \
    autoconf automake libtool python3 python3-pip \
    fuse fuse-overlayfs && \
    dnf clean all

# Install Conda (Miniforge)
RUN curl -L -o /tmp/miniforge.sh \
    https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh && \
    bash /tmp/miniforge.sh -b -p /opt/conda && \
    rm /tmp/miniforge.sh
ENV PATH="/opt/conda/bin:$PATH"

# Install Python packages
RUN pip install --no-cache-dir questionary PyYAML

# Install Go for Singularity
RUN curl -L -o /tmp/go.tar.gz \
    https://go.dev/dl/go1.21.13.linux-arm64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:$PATH"

# Install Singularity
RUN curl -L -o /tmp/singularity.tar.gz \
    https://github.com/sylabs/singularity/releases/download/v4.1.2/singularity-ce-4.1.2.tar.gz && \
    tar -xzf /tmp/singularity.tar.gz -C /tmp && \
    cd /tmp/singularity-ce-4.1.2 && \
    ./mconfig && \
    make -C builddir && \
    make -C builddir install && \
    rm -rf /tmp/singularity*

CMD ["/bin/bash"]