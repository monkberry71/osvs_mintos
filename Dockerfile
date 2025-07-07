FROM debian:stable-slim

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \   
        binutils \ 
        nasm \
        qemu-system-x86 \
        qemu-utils \
        ca-certificates \
        curl \
        git \
        vim \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Default command
CMD [ "bash" ]
