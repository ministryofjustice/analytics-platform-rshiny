# Pin a specific version of r base 3.4.2 to correspond to R Studio on the paltform
FROM r-base@sha256:909f337dc78803f2d648ba6e256e73f45897f83c7d34831d3a980a7b52fbb39d


# Remainder is the Dockerfile from https://github.com/rocker-org/shiny/tree/282306dff422a66d5041b8c55e2e82b083b4c8b4
MAINTAINER Winston Chang "winston@rstudio.com"

## Install dependencies and Download and install shiny server

## See https://www.rstudio.com/products/shiny/download-server/ for the
## instructions followed here.

RUN apt-get update
RUN apt-mark hold r-base-core  # apt-get commands such as apt-get install curl will sometimes upgrade the version of R, which we want pinned

RUN apt-get remove -y libperl5.26

RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev && \
    wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.7.907-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    rm -rf /var/lib/apt/lists/



COPY shiny-server.sh /usr/bin/shiny-server.sh

## Uncomment the line below to include a custom configuration file. You can download the default file at
## https://raw.githubusercontent.com/rstudio/shiny-server/master/config/default.config
## (The line below assumes that you have downloaded the file above to ./shiny-customized.config)
## Documentation on configuration options is available at
## http://docs.rstudio.com/shiny-server/

# COPY shiny-customized.config /etc/shiny-server/shiny-server.conf

CMD ["/usr/bin/shiny-server.sh"]
