FROM nginx:latest

LABEL description="Built by technotuba for K8s NGINX WWW"
LABEL org.opencontainers.image.description="Custom NGINX w/o extra packages"
LABEL maintainer="main.plan5783@fastmail.com"
LABEL org.opencontainers.source="https://github.com/gregheffner/k8-nginx-webpage"

ENV NGINX_VERSION=1.28.0 \
    NJS_VERSION=0.8.10 \
    NJS_RELEASE=3~bookworm \
    PKG_RELEASE=1~bookworm

RUN set -x && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        gnupg1 \
        ca-certificates \
        gettext-base \
        curl && \
    apt-get purge --allow-remove-essential -y libxml2 libtiff6 libldap-2.5-0 libkrb5-3 libgssapi-krb5-2 libkrb5-3 libkrb5support0 perl-base && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /
COPY docker-entrypoint.d/ /docker-entrypoint.d/

RUN chmod +x /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.d/*.sh || true

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
