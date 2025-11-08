#!/usr/bin/env bash

# make build-static
export $(grep -v '^#' .env.secrets | xargs -d '\n')
sshpass -p $DEPLOY_PASSWORD sftp -oBatchMode=no -b - $DEPLOY_HOST << !
   cd bicocalculator
   rm _app/immutable/assets/*
   rm _app/immutable/chunks/*
   rm _app/immutable/entry/*
   rm _app/immutable/nodes/*
   put -R build/* .
   bye
!
