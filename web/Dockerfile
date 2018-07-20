FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ENV POSTGRES_DB ${POSTGRES_DB}
ENV POSTGRES_USER ${POSTGRES_USER}
ENV IMPORT_MEMORY_SIZE ${IMPORT_MEMORY_SIZE}
ENV IMPORT_CPU_COUNT ${IMPORT_CPU_COUNT}
ENV USERNAME osm

RUN apt-get update
RUN apt-get install -y libboost-all-dev git-core tar unzip wget bzip2 \
  build-essential autoconf libtool libxml2-dev libgeos-dev libgeos++-dev \
  libpq-dev libbz2-dev libproj-dev munin-node munin libprotobuf-c0-dev \
  protobuf-c-compiler libfreetype6-dev libtiff5-dev libicu-dev libgdal-dev \
  libcairo-dev libcairomm-1.0-dev apache2 apache2-dev libagg-dev liblua5.2-dev \
  ttf-unifont lua5.1 liblua5.1-dev libgeotiff-epsg curl postgresql-client \
  make cmake g++ libboost-dev libboost-system-dev \ 
  libboost-filesystem-dev libexpat1-dev zlib1g-dev libbz2-dev libpq-dev \
  libgeos-dev libgeos++-dev libproj-dev lua5.2 liblua5.2-dev \
  autoconf apache2-dev libtool libxml2-dev libbz2-dev \
  libgeos-dev libgeos++-dev libproj-dev gdal-bin libmapnik-dev mapnik-utils \
  python-mapnik npm nodejs osm2pgsql \
  fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont

RUN npm install -g carto

RUN useradd -ms /bin/bash ${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}
RUN git clone -b switch2osm git://github.com/SomeoneElseOSM/mod_tile.git
WORKDIR /home/${USERNAME}/mod_tile
RUN ./autogen.sh
RUN ./configure
RUN make

USER root
RUN make install
RUN make install-mod_tile
RUN ldconfig

USER ${USERNAME}
WORKDIR /home/${USERNAME}
RUN git clone git://github.com/gravitystorm/openstreetmap-carto.git
WORKDIR /home/${USERNAME}/openstreetmap-carto
ADD project.mml /home/${USERNAME}/openstreetmap-carto
RUN scripts/get-shapefiles.py
RUN carto project.mml > mapnik.xml

USER root
RUN mkdir /var/lib/mod_tile
RUN chown www-data:www-data /var/lib/mod_tile
RUN mkdir /var/run/renderd
ADD ./mod_tile.conf /etc/apache2/conf-available/
RUN chown www-data:www-data /var/run/renderd
RUN a2enconf mod_tile

ADD ./renderd.conf /usr/local/etc/
RUN service apache2 restart

ADD wait-for-postgres.sh /
RUN chmod a+x /wait-for-postgres.sh
ADD ./run.sh /
RUN chmod a+x /run.sh
CMD ["/run.sh"]
