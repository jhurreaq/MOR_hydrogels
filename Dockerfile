# Start from an Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to ensure non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary utilities and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    wget \
    dpkg-dev \
    fakeroot \
    ca-certificates \
    python3-pip \
    python3-dev \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add the FEniCS PPA (if needed) and install FEniCS
RUN add-apt-repository ppa:fenics-packages/fenics && \
    apt-get update && \
    apt-get install -y fenics

# Clone the RBniCS repository and install the package
WORKDIR /app
RUN git clone https://github.com/RBniCS/RBniCS.git
WORKDIR /app/RBniCS
RUN python3 setup.py install

RUN pip install --upgrade numpy
RUN pip install ipykernel
RUN pip install matplotlib-label-lines scipy

# Switch back to your default directory
WORKDIR /home/rbnics/shared

# Set the default command to bash, so you get an interactive shell when starting the container
CMD ["bash"]
