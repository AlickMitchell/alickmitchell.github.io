#!/bin/sh
USER=frank
HOST=cablekitten
DIR=/var/www/cablekitten.co.uk   # the directory where your web site files should go

hugo && rsync -avz --delete --no-owner --no-group --no-atimes --no-times --no-perms public/ ${USER}@${HOST}:${DIR} # this will delete everything on the server that's not in the local public folder 

ssh frank@cablekitten sudo chown -R www-data:www-data /var/www/cablekitten.co.uk/
exit 0
