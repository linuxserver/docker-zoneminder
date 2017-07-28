FROM lsiobase/xenial

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"

# packages as variables
ARG BUILD_PACKAGES="\
	cmake \
	dh-autoreconf \
	dpatch \
	g++ \
	gcc \
	git \
	libavcodec-dev \
	libavdevice-dev \
	libavfilter-dev \
	libavformat-dev \
	libavresample-dev \
	libavutil-dev \
	libbz2-dev \
	libjpeg-turbo8-dev \
	libmp4v2-dev \
	libmysqlclient-dev \
	libnetpbm10-dev \
	libpcre3 \
	libpcre3-dev \
	libpolkit-gobject-1-dev \
	libpostproc-dev \
	libssl-dev \
	libswscale-dev \
	libtheora-dev \
	libtool \
	libv4l-dev \
	libvlc5 \
	libvlccore8 \
	libvlccore-dev \
	libvlc-dev \
	libvorbis-dev \
	libvpx-dev \
	libx264-dev \
	yasm"

ARG RUNTIME_PACKAGES="\
	apache2 \
	libapache2-mod-php \
	libarchive-zip-perl \
	libav-tools \
	libdate-manip-perl \
	libdbd-mysql-perl \
	libcurl4-openssl-dev \
	libdbi-perl \
	libdevice-serialport-perl \
	libjpeg-turbo8 \
	libmime-lite-perl \
	libmime-perl \
	libsys-mmap-perl \
	libwww-perl \
	mysql-client \
	mysql-server \
	php \
	php-cli \
	php-mysql \
	vlc-data"

# install packages
RUN \
 apt-get update && \
 apt-get install -y \
	--no-install-recommends \
	$BUILD_PACKAGES \
	$RUNTIME_PACKAGES && \

# build zoneminder
 git clone https://github.com/ZoneMinder/ZoneMinder /tmp/zoneminder && \
 cd /tmp/zoneminder && \
 git submodule update --init --recursive && \
 cmake . && \
 make && \
 make install && \

# cleanup
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
