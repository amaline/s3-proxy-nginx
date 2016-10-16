# s3-proxy-nginx

This repository is primarily a circleci yaml file and a deploy script that performs a custom build of nginx adding the following modules

- ngx_aws_auth (https://github.com/anomalizer/ngx_aws_auth) - proxy requests to authenticated S3 backends using Amazon's V4 authentication API

After compilation, the build creates a compress tar file with the nginx binary. The deploy script then creates a github release and uploads to github.  The release is tagged with the version number in the circle.yml file.
