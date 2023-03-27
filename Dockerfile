FROM ubuntu:jammy

ARG r=4.1.3 # must correspond with a rocker tag as per https://hub.docker.com/r/rocker/shiny/tags
ARG shinyserver=0.0.6 # must correspond with an analytics-platform-shiny-server version from here: https://github.com/ministryofjustice/analytics-platform-shiny-server

ENV STRINGI_DISABLE_PKG_CONFIG=true \
    AWS_DEFAULT_REGION=eu-west-1 \
    PATH="/opt/R/4.1.3/bin:/opt/shiny-server/bin:/opt/shiny-server/ext/node/bin:${PATH}" \
    SHINY_APP=/srv/shiny-server \
    NODE_ENV=production

RUN sed -i 's,deb,deb [trusted=yes],g' /etc/apt/sources.list && \
    apt-get update -yq -y && apt-get install -yq --no-install-recommends ca-certificates && apt-get clean && rm -rf /var/lib/apt/lists/* && echo "dash dash/sh boolean false" | debconf-set-selections && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
    sed -i s,http://security.ubuntu.com/ubuntu/,https://mirror.mythic-beasts.com/ubuntu/,g /etc/apt/sources.list && sed -i s,http://archive.ubuntu.com/ubuntu/,https://mirror.mythic-beasts.com/ubuntu/,g /etc/apt/sources.list && sed -i s,http:,https:,g /etc/apt/sources.list && \ 
    apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -yq --no-install-recommends wget adduser apt base-files base-passwd bash binutils binutils-common binutils-x86-64-linux-gnu bsdutils bzip2-doc ca-certificates coreutils cpp cpp-11 curl dash debconf debianutils diffutils dpkg e2fsprogs findutils fontconfig fontconfig-config fonts-dejavu-core g++ g++-11 gcc gcc-11 gcc-11-base gcc-12-base gfortran gfortran-11 gpgv grep gzip hostname icu-devtools init-system-helpers libacl1 libapt-pkg6.0 libasan6 libatomic1 libattr1 libaudit-common libaudit1 libbinutils libblkid1 libbrotli1 libbsd0 libbz2-1.0 libbz2-dev libc-bin libc-dev-bin libc-devtools libc6 libc6-dev libcairo2 libcap-ng0 libcap2 libcc1-0 libcom-err2 libcrypt-dev libcrypt1 libctf-nobfd0 libctf0 libcurl4 libdatrie1 libdb5.3 libdebconfclient0 libdeflate0 libexpat1 libext2fs2 libffi8 libfontconfig1 libfreetype6 libfribidi0 libgcc-11-dev libgcc-s1 libgcrypt20 libgd3 libgfortran-11-dev libgfortran5 libglib2.0-0 libglib2.0-data libgmp10 libgnutls30 libgomp1 libgpg-error0 libgraphite2-3 libgssapi-krb5-2 libharfbuzz0b libhogweed6 libice6 libicu-dev libicu70 libidn2-0 libisl23 libitm1 libjbig0 libjpeg-turbo8 libjpeg8 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 libldap-common liblsan0 liblz4-1 liblzma-dev liblzma5 libmd0 libmount1 libmpc3 libmpfr6 libncurses6 libncursesw6 libnettle8 libnghttp2-14 libnsl-dev libnsl2 libopenblas-dev libopenblas-pthread-dev libopenblas0 libopenblas0-pthread libp11-kit0 libpam-modules libpam-modules-bin libpam-runtime libpam0g libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpaper-utils libpaper1 libpcre2-16-0 libpcre2-32-0 libpcre2-8-0 libpcre2-dev libpcre2-posix3 libpcre3 libpixman-1-0 libpng16-16 libprocps8 libpsl5 libquadmath0 libreadline8 librtmp1 libsasl2-2 libsasl2-modules libsasl2-modules-db libseccomp2 libselinux1 libsemanage-common libsemanage2 libsepol2 libsm6 libsmartcols1 libss2 libssh-4 libssl3 libstdc++-11-dev libstdc++6 libsystemd0 libtasn1-6 libtcl8.6 libthai-data libthai0 libtiff5 libtinfo6 libtirpc-common libtirpc-dev libtirpc3 libtk8.6 libtsan0 libubsan1 libudev1 libunistring2 libuuid1 libwebp7 libx11-6 libx11-data libxau6 libxcb-render0 libxcb-shm0 libxcb1 libxdmcp6 libxext6 libxft2 libxml2 libxpm4 libxrender1 libxss1 libxt6 libxxhash0 libzstd1 linux-libc-dev login logsave lsb-base make manpages manpages-dev mawk mount ncurses-base ncurses-bin openssl passwd perl-base procps publicsuffix readline-common rpcsvc-proto sed sensible-utils shared-mime-info sysvinit-utils tar tzdata ubuntu-keyring ucf unzip usrmerge util-linux x11-common xdg-user-dirs zip zlib1g zlib1g-dev npm node-shiny-server-client gdebi-core lsb-release wget bzip2 ca-certificates curl git libxml2-dev libssl-dev gpg apt-transport-https libicu-dev libcurl4-openssl-dev xtail && \
    curl -O https://cdn.posit.co/r/ubuntu-2204/pkgs/r-${r}_1_amd64.deb && dpkg -i r-${r}_1_amd64.deb && rm r-${r}_1_amd64.deb && rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoclean && \
    /opt/R/4.1.3/bin/R -e "install.packages('shiny', repos='https://packagemanager.rstudio.com/cran/__jammy__/focal/latest')" && wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.20.1002-amd64.deb -O /tmp/shiny-server.deb && gdebi -n /tmp/shiny-server.deb && \
    mkdir -p /var/log/shiny-server && wget https://github.com/ministryofjustice/analytics-platform-shiny-server/archive/refs/tags/v${shinyserver}.tar.gz -O /tmp/analytics-platform-shiny-server.tar.gz && npm i -g /tmp/analytics-platform-shiny-server.tar.gz && \
    chown -R shiny:shiny /srv/shiny-server  # && chown shiny:shiny /usr/bin/shiny-server && chown shiny:shiny /usr/bin/shiny-server.sh

WORKDIR /srv/shiny-server

SHELL ["/bin/bash", "-c"]

# Cleanup shiny-server dir
RUN rm -rf ./*

# Shiny runs as 'shiny' user, adjust app directory permissions
ADD shiny-server.conf /etc/shiny-server/shiny-server.conf
ADD shiny-server.sh /usr/bin/shiny-server.sh
RUN chown -R shiny:shiny /usr/bin/shiny-server.sh && chmod +x /usr/bin/shiny-server.sh 

USER shiny

CMD ["/bin/bash", "-c", "/usr/bin/shiny-server.sh"]
EXPOSE 9999
