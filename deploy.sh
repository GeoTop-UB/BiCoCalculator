#!/usr/bin/env bash

# make build-static
set -o allexport
source .env.secrets
set +o allexport
# export $(grep -v '^#' .env.secrets | xargs -d '\n')
# mkdir bicocalculator
# mkdir _app
# mkdir _app/immutable
# mkdir _app/immutable/assets
# mkdir _app/immutable/chunks
# mkdir _app/immutable/entry
# mkdir _app/immutable/nodes
sshpass -p $DEPLOY_PASSWORD sftp -oBatchMode=no -b - $DEPLOY_HOST << !
   cd bicocalculator
   rm _app/immutable/assets/*
   rm _app/immutable/chunks/*
   rm _app/immutable/entry/*
   rm _app/immutable/nodes/*
   put -R _build/* .
   bye
!
