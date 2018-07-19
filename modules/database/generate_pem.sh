function parse_input() {
  eval "$(jq -r '@sh "export DB_INSTANCE=\(.db_instance) PROJECT=\(.project)"')"
  if [[ -z "${DB_INSTANCE}" ]]; then export DB_INSTANCE=none; fi
  if [[ -z "${PROJECT}" ]]; then export PROJECT=none; fi
}

function create_pem() {
  if ! [ -e .secrets/client_cert.pem ]
  then
    gcloud config set project $PROJECT
    gcloud sql ssl client-certs create client_cert client_cert.pem --instance $DB_INSTANCE
    mv client_cert.pem .secrets/client_cert.pem

    gcloud sql ssl client-certs describe client_cert --instance $DB_INSTANCE > temp.txt
    grep -E "\s\s((.)*)" temp.txt > cert.crt
    CERT="$(sed 's/^..//' cert.crt)"

    echo "${CERT}" >> .secrets/client_cert.pem

    rm -rf temp.txt cert.crt
  fi
}

function produce_output() {
  export PEM_CONTENT=`cat .secrets/client_cert.pem`

  jq -n \
    --arg pem_content "$PEM_CONTENT" \
    '{"pem":$pem_content}'
}

parse_input
create_pem
produce_output
