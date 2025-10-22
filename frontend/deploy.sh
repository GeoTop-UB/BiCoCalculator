#!/usr/bin/env bash

make build-static
sshpass -f <passwordfile> sftp -oBatchMode=no -b - <hosturl> << !
   cd bbcalculator
   rm _app/immutable/assets/*
   rm _app/immutable/chunks/*
   rm _app/immutable/entry/*
   rm _app/immutable/nodes/*
   put -R build/* .
   bye
!
