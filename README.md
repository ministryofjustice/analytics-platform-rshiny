# analytics-platform-rshiny

RShiny Docker image for Analytics Platform

[![Docker Repository on Quay](https://quay.io/repository/mojanalytics/rshiny/status "Docker Repository on Quay")](https://quay.io/repository/mojanalytics/rshiny)

Users can deploy [shiny apps](https://shiny.rstudio.com/) on the Analytical Platform.

## Usage

#### Build

```
make build
```

#### Run locally

```
make up
```

## Per User Apps

Shiny apps are [built and deployed by Concourse](https://github.com/ministryofjustice/analytics-platform-concourse-github-org-resource/blob/c67dcf4ed75ccc34ea339283282b2278f4ed4a85/resource/webapp_pipeline.yaml) which installs the `webapp` helm chart [passing correct image values](https://github.com/ministryofjustice/analytics-platform-helm-charts/blob/master/charts/webapp/values.yaml#L4).

Each shiny app has its own repository with `Dockerfile` based on [`moj-analytical-services/rshiny-template` repository](https://github.com/moj-analytical-services/rshiny-template) (cloned when creating a new app).

This docker image is [used as base image in the `moj-analytical-services/rshiny-template` repository (`conda` branch)](https://github.com/moj-analytical-services/rshiny-template/blob/conda/Dockerfile#L1).

Another significant difference of the `conda` branch is that it also [uses `analytics-platform-shiny-server`](https://github.com/moj-analytical-services/rshiny-template/blob/conda/Dockerfile#L17) instead of official shiny server - main reason for this was to be able to use R environment installed with conda (or any R environment in your `PATH`).
