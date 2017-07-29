FROM lsiobase/xenial

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV MYSQL_DIR="/data"
ENV DATADIR=$MYSQL_DIR/databases

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
	libcurl4-openssl-dev \
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
	libbz2-dev \
	libcurl3 \
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
	mariadb-client \
	mariadb-server \
	php \
	php-cli \
	php-mysql \
	vlc-data"

# install packages
RUN \
 apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 && \
 echo "deb [arch=amd64,i386] http://mirrors.coreix.net/mariadb/repo/10.1/ubuntu xenial main" >> /etc/apt/sources.list.d/mariadb.list && \
 echo "deb-src http://mirrors.coreix.net/mariadb/repo/10.1/ubuntu xenial main" >> /etc/apt/sources.list.d/mariadb.list && \
 apt-get update && \
 apt-get install -y \
	--no-install-recommends \
	$BUILD_DEPENDENCIES \
	$RUNTIME_DEPENDENCIES && \

# build zoneminder
 git clone https://github.com/ZoneMinder/ZoneMinder /tmp/zoneminder && \
 cd /tmp/zoneminder && \
 git submodule update --init --recursive && \
 cmake \
	-DCMAKE_INSTALL_PREFIX=/usr \
	. && \
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

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /data
