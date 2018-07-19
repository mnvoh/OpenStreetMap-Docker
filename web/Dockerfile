FROM ubuntu:18.04

ENV POSTGRES_DB ${POSTGRES_DB}
ENV POSTGRES_USER ${POSTGRES_USER}
ENV POSTGRES_PASS ${POSTGRES_PASS}
ENV IMPORT_MEMORY_SIZE ${IMPORT_MEMORY_SIZE}
ENV IMPORT_CPU_COUNT ${IMPORT_CPU_COUNT}
ENV USERNAME osm

RUN apt-get update
RUN apt-get install -y libboost-all-dev git-core tar unzip wget bzip2 \
build-essential autoconf libtool libxml2-dev libgeos-dev libgeos++-dev \
libpq-dev libbz2-dev libproj-dev munin-node munin libprotobuf-c0-dev \
protobuf-c-compiler libfreetype6-dev libtiff5-dev libicu-dev libgdal-dev \
libcairo-dev libcairomm-1.0-dev apache2 apache2-dev libagg-dev liblua5.2-dev \
ttf-unifont lua5.1 liblua5.1-dev libgeotiff-epsg curl postgresql-client

RUN apt-get install -y make cmake g++ libboost-dev libboost-system-dev \ 
libboost-filesystem-dev libexpat1-dev zlib1g-dev libbz2-dev libpq-dev \
libgeos-dev libgeos++-dev libproj-dev lua5.2 liblua5.2-dev

RUN apt-get install -y autoconf apache2-dev libtool libxml2-dev libbz2-dev \
libgeos-dev libgeos++-dev libproj-dev gdal-bin libmapnik-dev mapnik-utils \
python-mapnik

RUN apt-get install -y fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont

RUN apt-get install -y npm nodejs
RUN npm install -g carto

RUN useradd -ms /bin/bash ${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN git clone git://github.com/openstreetmap/osm2pgsql.git
WORKDIR /home/${USERNAME}/osm2pgsql
RUN mkdir build
WORKDIR /home/${USERNAME}/osm2pgsql/build
RUN cmake ..
RUN make

USER root
RUN make install

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
RUN carto project.mml > mapnik.xml

RUN scripts/get-shapefiles.py

USER root
RUN mkdir /var/lib/mod_tile
RUN chown ${USERNAME} /var/lib/mod_tile
RUN mkdir /var/run/renderd
RUN chown ${USERNAME} /var/run/renderd
RUN echo "LoadModule tile_module /usr/lib/apache2/modules/mod_tile.so" >> \
  /etc/apache2/conf-available/mod_tile.conf
RUN a2enconf mod_tile

ADD ./renderd.conf /usr/local/etc/
ADD ./000-default.conf /etc/apache2/sites-available/
RUN service apache2 restart

USER ${USERNAME}
ADD ./run.sh /
RUN chmod a+x /run.sh
CMD ["/run.sh"]
