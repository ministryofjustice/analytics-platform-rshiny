ARG r=4.1 # must correspond with a rocker tag as per https://hub.docker.com/r/rocker/shiny/tags

FROM rocker/shiny:${r}

ARG shinyserver=0.0.6 # must correspond with an analytics-platform-shiny-server version from here: https://github.com/ministryofjustice/analytics-platform-shiny-server

ENV STRINGI_DISABLE_PKG_CONFIG true \
AWS_DEFAULT_REGION eu-west-1 \
PATH="/opt/shiny-server/bin:/opt/shiny-server/ext/node/bin:${PATH}" \
SHINY_APP=/srv/shiny-server \
NODE_ENV=production

RUN sed -i 's,deb,deb [trusted=yes],g' /etc/apt/sources.list
RUN apt-get update -yq -y && apt-get install -yq --no-install-recommends ca-certificates && apt-get clean && rm -rf /var/lib/apt/lists/* && echo "dash dash/sh boolean false" | debconf-set-selections && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
RUN sed -i s,http://security.ubuntu.com/ubuntu/,https://mirror.mythic-beasts.com/ubuntu/,g /etc/apt/sources.list && sed -i s,http://archive.ubuntu.com/ubuntu/,https://mirror.mythic-beasts.com/ubuntu/,g /etc/apt/sources.list && sed -i s,http:,https:,g /etc/apt/sources.list # ubuntu mirrors are being unreliable today, mythic beasts are fine though

WORKDIR /srv/shiny-server

SHELL ["/bin/bash", "-c"]

# Cleanup shiny-server dir
RUN rm -rf ./*

# Make sure the directory for individual app logs exists
RUN mkdir -p /var/log/shiny-server

RUN apt-get update -y && \
  apt-get install -y wget bzip2 ca-certificates curl git libxml2-dev libssl-dev gpg apt-transport-https libicu-dev libcurl4-openssl-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

#RUN echo 'options(renv.config.pak.enabled = TRUE, renv.config.repos.override = "https://packagemanager.rstudio.com/cran/__linux__/focal/latest", repos="https://packagemanager.rstudio.com/cran/__focal__/focal/latest")' >> /usr/local/lib/R/etc/Rprofile.site
RUN echo 'options(renv.config.pak.enabled = TRUE, renv.config.repos.override = "https://cloud.r-project.org/", repos="https://cloud.r-project.org/")' >> /usr/local/lib/R/etc/Rprofile.site

RUN wget https://github.com/ministryofjustice/analytics-platform-shiny-server/archive/refs/tags/v${shinyserver}.tar.gz -O /tmp/analytics-platform-shiny-server.tar.gz && npm i -g /tmp/analytics-platform-shiny-server.tar.gz

# Shiny runs as 'shiny' user, adjust app directory permissions
RUN chown -R shiny:shiny .

ENV PKG_CONFIG_PATH /opt/conda/lib/pkgconfig/
# Run shiny-server on port 80
RUN sed -i 's/3838/9999/g' /etc/shiny-server/shiny-server.conf
CMD ["/bin/bash", "-c", "/usr/bin/shiny-server.sh"]
EXPOSE 9999
