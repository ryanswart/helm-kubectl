FROM frolvlad/alpine-glibc

ARG VCS_REF
ARG BUILD_DATE
ARG OO_VERSION="3.9.0"
ARG OO_HASH="191fece"

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="helm-kubectl" \
      org.label-schema.url="https://hub.docker.com/r/dtzar/helm-kubectl/" \
      org.label-schema.vcs-url="https://github.com/dtzar/helm-kubectl" \
      org.label-schema.build-date=$BUILD_DATE

# Note: Latest version of kubectl may be found at:
# https://aur.archlinux.org/packages/kubectl-bin/
ENV KUBE_LATEST_VERSION="v1.10.2"
# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v2.9.1"

RUN apk add --no-cache ca-certificates bash git curl\
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q http://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

RUN curl -sSLo oc_client.tar.gz https://github.com/openshift/origin/releases/download/v${OO_VERSION}/openshift-origin-client-tools-v${OO_VERSION}-${OO_HASH}-linux-64bit.tar.gz
RUN tar -xzf oc_client.tar.gz -C /bin --strip-components 1 

WORKDIR /config

CMD bash
