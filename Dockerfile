ARG BASE_IMAGE
FROM ${BASE_IMAGE}

COPY data /data

ARG BUNDLE_OBJECT
ENV BUNDLE_OBJECT=${BUNDLE_OBJECT}

ARG RUNTIME_USER
ARG RUNTIME_GROUP

RUN set -x \
  && mkdir -p /data/repo \
  && curl -sL https://repo.elitea.ai/target/public/depot/export/bundles/${BUNDLE_OBJECT}/data | tar -C /data/repo -xzvf - \
  && chown -R ${RUNTIME_USER}:${RUNTIME_GROUP} /data

USER ${RUNTIME_USER}:${RUNTIME_GROUP}

ENV ADMIN_LOGIN=admin
ENV ADMIN_APPPASS=internal
ENV PYLON_APPKEY=internal
ENV PYLON_NAME=repo
ENV PYLON_CONFIG_SEED=file:/data/configs/pylon.yml
ENV PYLON_MODE=oneshot

RUN set -x \
  && python -m pylon.main \
  && rm -rf /data/plugins/*/.git \
  && rm -rf /data/cache

ENV PYLON_MODE=web
ENV PYLON_WEB_RUNTIME=gevent
