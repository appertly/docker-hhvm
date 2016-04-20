# docker-hhvm
Docker image of HHVM.

## Sessions
You can set a `MEMCACHED` environment variable (either in your `docker run` command or in an inheriting Dockerfile) with the connection string to Memcached. When HHVM starts, the value of this environment variable will be written to `/etc/hhvm/php.ini` to enable Memcached based session storage.

## CA Certificates
You can mount a volume to `/usr/local/share/ca-certificates` that contains any certificate authorities you wish to accept as trusted. Debian's `update-ca-certificates` is run before HHVM executes.
