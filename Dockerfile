FROM alpine

WORKDIR app

ENV TERRAFORM_VERSION=0.11.7
ENV KUBECTL_VERSION=1.11.0

# Make local env vars available
COPY .env /app/external-vars

# Needed linux tools
RUN apk update &&\
  apk add sudo zip unzip

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

# AWS auth setup
RUN export $(cat ./external-vars | xargs) && mkdir ~/.aws && \
  echo -e "[default] \n\
  aws_access_key_id=$AWS_ACCESS_KEY_ID \n\
  aws_secret_access_key=$AWS_SECRET_ACCESS_KEY \n"\
  > ~/.aws/credentials
