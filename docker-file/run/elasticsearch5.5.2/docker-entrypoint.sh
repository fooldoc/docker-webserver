#!/bin/sh

su-exec elasticsearch /usr/share/elasticsearch/bin/elasticsearch

tail -f /dev/null