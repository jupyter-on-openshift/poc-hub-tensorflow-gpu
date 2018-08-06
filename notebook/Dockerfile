FROM myproject/minimal-notebook:latest

USER root

#### Packages ####
RUN yum clean all && yum repolist && yum install -y epel-release

#### Default PATH ####

ENV CUDA_HOME /usr/local/cuda
ENV PATH $PATH:$CUDA_HOME

### CUDA Profile ####
#  For CUDA profiling, TensorFlow requires CUPTI.

ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

#### Nvidia Docker ####

LABEL com.nvidia.volumes.needed="nvidia_driver"

#### Nvidia Container Runtime ###

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"

#### NVIDIA CUDA Runtime ####

ENV CUDA_VERSION 9.0.176

LABEL com.nvidia.cuda.version="${CUDA_VERSION}"

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}

ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/extras/CUPTI/lib64" >> /etc/ld.so.conf.d/nvidia.conf

RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/7fa2af80.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
    echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -
COPY cuda.repo /etc/yum.repos.d/cuda.repo

ENV CUDA_PKG_VERSION 9-0-$CUDA_VERSION
RUN yum install -y \
        cuda-nvrtc-$CUDA_PKG_VERSION-1 \
        cuda-nvgraph-$CUDA_PKG_VERSION-1 \
        cuda-cusolver-$CUDA_PKG_VERSION-1 \
        cuda-cublas-$CUDA_PKG_VERSION.3-1 \
        cuda-cufft-$CUDA_PKG_VERSION-1 \
        cuda-curand-$CUDA_PKG_VERSION-1 \
        cuda-cusparse-$CUDA_PKG_VERSION-1 \
        cuda-npp-$CUDA_PKG_VERSION-1 \
        cuda-cudart-$CUDA_PKG_VERSION-1 && \
    ln -s cuda-9.0 /usr/local/cuda && \
    rm -rf /var/cache/yum/*

#### NVIDIA CUDA ####

RUN yum install -y cuda-9-0

#### NVIDIA CUDNN ####

COPY . /tmp/src

RUN tar --no-same-owner -xzf /tmp/src/cudnn-9.0-linux-x64-v7.1.tgz -C /usr/local --wildcards 'cuda/lib64/libcudnn.so.*' && \
    rm /tmp/src/cudnn-*.tgz && \
    ldconfig

#### S2I build ####

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src

USER 1001

RUN /opt/app-root/builder/assemble
