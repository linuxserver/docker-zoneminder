FROM lsiobase/xenial

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"

# packages as variables
ARG BUILD_DEPENDENCIES="\
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
	libpcre3-dev \
	libpolkit-gobject-1-dev \
	libpostproc-dev \
	libswscale-dev \
	libtheora-dev \
	libtool \
	libv4l-dev \
	libvlccore-dev \
	libvlc-dev \
	libvorbis-dev \
	libvpx-dev \
	libx264-dev \
	yasm"

ARG RUNTIME_DEPENDENCIES="\
	apache2 \
	ffmpeg \
	libapache2-mod-php \
	libarchive-zip-perl \
	libav-tools \
	libcurl4-openssl-dev \
	libdate-manip-perl \
	libdbd-mysql-perl \
	libdbi-perl \
	libdevice-serialport-perl \
	libjpeg-turbo8 \
	libmime-lite-perl \
	libmime-perl \
	libmp4v2-2 \
	libpcre3 \
	libssl-dev \
	libsys-mmap-perl \
	libvlc5 \
	libvlccore8 \
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
	$BUILD_DEPENDENCIES \
	$RUNTIME_DEPENDENCIES && \

# build zoneminder
 git clone https://github.com/ZoneMinder/ZoneMinder /tmp/zoneminder && \
 cd /tmp/zoneminder && \
 git submodule update --init --recursive && \
 cmake . && \
 make && \
 make install && \

# uninstall build packages
 apt-get purge -y --auto-remove \
	$BUILD_DEPENDENCIES && \

# install runtime packages
 apt-get install -y \
	--no-install-recommends \
	$RUNTIME_DEPENDENCIES && \

# cleanup
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/lib/mysql \
	/var/tmp/* && \
 mkdir -p \
	/var/lib/mysql

