docker run \
  --name=hakuneko -d \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Paris \
  -e CLI_ARGS= `#optional` \
  -e GUIAUTOSTART=true \
  -p 3000:3000 \
  -v $(pwd)/appdata/$(date +%F)/config:/config \
  --restart unless-stopped \
  --privileged 
  hakuneko:focal