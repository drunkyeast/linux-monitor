FROM  ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
# 可以让 apt-get 等工具在安装软件包时跳过交互式提示（如选择语言、时区等）

ENV TZ=Asia/Shanghai

SHELL ["/bin/bash", "-c"]
# 指定了 Dockerfile 中后续的 RUN 指令用/bin/bash执行, 而不是默认的/bin/sh

RUN apt-get clean && \
    apt-get autoclean
COPY apt/sources.list /etc/apt/

RUN apt-get update  && apt-get upgrade -y  && \
    apt-get install -y \
    htop \
    apt-utils \
    curl \
    git \
    openssh-server \
    build-essential \
    qtbase5-dev \
    qtchooser \
    qt5-qmake \
    qtbase5-dev-tools \
    libboost-all-dev \
    net-tools \
    vim \
    stress 

RUN apt-get install -y libc-ares-dev  libssl-dev gcc g++ make 
RUN apt-get install -y  \
    libx11-xcb1 \
    libfreetype6 \
    libdbus-1-3 \
    libfontconfig1 \
    libxkbcommon0   \
    libxkbcommon-x11-0


 COPY install/cmake /tmp/install/cmake
 RUN /tmp/install/cmake/install_cmake.sh

COPY install/protobuf /tmp/install/protobuf
RUN /tmp/install/protobuf/install_protobuf.sh

COPY install/abseil /tmp/install/abseil
RUN /tmp/install/abseil/install_abseil.sh

COPY install/grpc /tmp/install/grpc
RUN /tmp/install/grpc/install_grpc.sh



 RUN apt-get install -y python3-pip
 RUN pip3 install cuteci -i https://mirrors.aliyun.com/pypi/simple

 COPY install/qt /tmp/install/qt
 RUN /tmp/install/qt/install_qt.sh






