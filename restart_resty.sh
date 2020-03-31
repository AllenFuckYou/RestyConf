#!/usr/bin/env bash
openresty -p `pwd` -c conf/nginx.conf -s reload
