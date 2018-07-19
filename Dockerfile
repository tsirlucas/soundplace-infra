FROM alpine

WORKDIR app

COPY .secrets ./.secrets

ENV TERRAFORM_VERSION=0.11.7
ENV KUBECTL_VERSION=1.11.0
ENV GCLOUD_SDK_VERSION=207.0.0
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
ENV GOOGLE_APPLICATION_CREDENTIALS=./.secrets/gcloud_auth.json

# Needed linux tools
RUN apk --no-cache add \
  python \
  py-crcmod \
  bash \
  libc6-compat \
  openssh-client \
  git \
  sudo \
  zip \
  unzip \
  jq

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz &&\
  mv google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz /tmp/google-cloud-sdk.tar.gz &&\
  mkdir -p /usr/local/gcloud &&\
  tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz &&\
  /usr/local/gcloud/google-cloud-sdk/install.sh &&\
  gcloud --version

# Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip &&\
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip &&\
  rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip &&\
  sudo mv terraform /usr/local/bin/ &&\
  terraform --version

# Kubectl
RUN wget https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl &&\
  chmod +x ./kubectl &&\
  sudo mv ./kubectl /usr/local/bin/kubectl &&\
  kubectl version --short --client

# GCloud Auth
RUN gcloud auth activate-service-account --key-file ./.secrets/gcloud_auth.json

# PSQL
RUN apk --update add postgresql-client

# Clear garbage
RUN rm -rf .secrets
