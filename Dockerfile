FROM debian:12-slim

LABEL maintainer="https://github.com/Skeeve"

# ENV SDK_ARCH=A13
# ENV SDK_ARCH=iMX6
ENV SDK_ARCH=B288
ENV GITHUB_BASE=/SDK
ENV SDK_BASE=${GITHUB_BASE}/SDK-${SDK_ARCH}
ENV SDK_URL=https://github.com/pocketbook/SDK_6.3.0
ENV SDK_BRANCH=5.19

ENV CMAKE_VERSION=3.27.5
ENV CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}

VOLUME "/project"
WORKDIR "/project"

# Prepare SDK
RUN apt-get update \
 && apt-get upgrade --yes \
 && apt-get install --yes \
    locales \
    git \
    build-essential \
    wget \
	subversion \
    libtinfo5 \
    python3 \
    python3-pip \
    sudo \
    ccls \
 && rm -rf /var/lib/apt/lists/*
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
 && git clone -b ${SDK_BRANCH} --single-branch ${SDK_URL} ${GITHUB_BASE} \
 && ${SDK_BASE}/bin/update_path.sh

# Get cmake
RUN CMAKE="cmake-${CMAKE_VERSION}-linux-$( uname -m )" \
 && wget -c ${CMAKE_URL}/${CMAKE}.tar.gz -O - | tar xvzf - --strip-components=1 --directory=/usr \
;

ARG USERNAME=User
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

ENV PATH="$PATH:/SDK/usr/bin"
USER $USERNAME

RUN pip3 install pyright --break-system-packages
RUN pip3 install conan==2.0.14 --break-system-packages
ENV PATH="$PATH:/home/$USERNAME/.local/bin:${SDK_BASE}/usr/bin"

ENTRYPOINT [ "bash" ]
