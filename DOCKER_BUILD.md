
# Contents of the rshiny:3.5.1 Docker Image

## rocker/shiny:3.5.2

It uses the rocker/shiny docker image as the base image.
<https://hub.docker.com/r/rocker/shiny>

| Layer                     | Description                                                                                                                 | Purpose                                      | Size  |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- | ----- |
| R and build tools         | These are from the r-ver base image <https://hub.docker.com/r/rocker/>r-ver                                                 | R version 3.5.2                              | 609MB |
| System Packages           | sudo, gdebi-core, pandoc, pandoc-citeproc, libcurl4-gnutls-dev, libcairo2-dev, libxt-dev, xtail, wget                       | Various system utlities                      | 313MB |
| Shiny Server              | Installs the ubuntu 14:04 version of the Shiny server from <https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server> | Shiny server and some example apps           | 481MB |
| Shiny Server start script |                                                                                                                             | Start the shiny server when the image starts | 397B  |

## quay.io:rshiny:3.5.1

We then install some packages in to produce the quay.io:rshiny image we use in the Analytical Platform.

| Layer                        | Description                                                                        | Purpose                                                                                                                           | Size  |
| ---------------------------- | ---------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ----- |
| Remove Shiny server examples | We don't need the shiny app examples                                               |                                                                                                                                   | 0B    |
| System Packages              | wget bzip2 ca-certificates curl git libxml2-dev libssl-dev gpg apt-transport-https | Various system utlities e.g. curl, git, gpg                                                                                       | 155MB |
| Conda                        | The latest version of conda for debian.                                            | Package management                                                                                                                | 227MB |
| r-base                       | The r base conda package                                                           | Provide basic R functions. This layer seems to be much larger than it should be (when I built the image locally it was only 283MB | 980MB |
