FROM almalinux:9

# Configure dependancys and create build directorys
RUN dnf groupinstall 'Development Tools' -y && \
dnf install -y cmake \
gcc \
libX11-devel \
libXcursor-devel \
libXi-devel \ 
libXext-devel \
libXrandr-devel \
libXinerama-devel \
freetype-devel \
fontconfig-devel \
libxml2-devel \
libxslt-devel \
mesa-libGL-devel \
libpng-devel \
libjpeg-turbo-devel \
glib2-devel \
libgcrypt-devel \
gnutls-devel \
wget \
glibc-devel.i686 \
libX11-devel.i686 \
freetype-devel.i686 \
libxcb.i686 \
libXext-devel.i686 && \
mkdir wine-builds && cd wine-builds && \
wget https://dl.winehq.org/wine/source/10.0/wine-10.0.tar.xz && \
tar -xf wine-10.0.tar.xz && \
cd wine-10.0 && \
mkdir build64 build32

# Make Wine64/32 bit
WORKDIR /wine-builds/wine-10.0/build64

RUN ../configure --enable-win64 && \
make -j$(nproc) && \
make install -j$(nproc)

WORKDIR /wine-builds/wine-10.0/build32

RUN PKG_CONFIG_PATH=/usr/lib/pkgconfig ../configure --with-wine64=../build64  --without-freetype && \
make -j$(nproc) && \
make install -j$(nproc)

WORKDIR /

# Clean up build tools, dependacies, and directorys
RUN dnf remove -y \
    autoconf \
    automake \
    binutils \
    bison \
    flex \
    gcc \
    gcc-c++ \
    gdb \
    glibc-devel \
    libtool \
    make \
    pkgconf \
    pkgconf-m4 \
    pkgconf-pkg-config \
    redhat-rpm-config \
    rpm-build \
    rpm-sign \
    strace \
    cmake \
    gcc \
    libX11-devel \
    libXcursor-devel \
    libXi-devel \
    libXext-devel \
    libXrandr-devel \
    libXinerama-devel \
    freetype-devel \
    fontconfig-devel \
    libxml2-devel \
    libxslt-devel \
    mesa-libGL-devel \
    libpng-devel \
    libjpeg-turbo-devel \
    glib2-devel \
    libgcrypt-devel \
    gnutls-devel \
    wget \
    glibc-devel.i686 \
    libX11-devel.i686 \
    freetype-devel.i686 \
    libxcb.i686 \
    libXext-devel.i686 && \
    rm -rf /wine-builds
