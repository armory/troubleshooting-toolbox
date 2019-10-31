   
docker build -t quay.io/starlingbank/docker-debugging-tools:${BUILD_NUMBER} .
 
docker tag quay.io/starlingbank/docker-debugging-tools:${BUILD_NUMBER} quay.io/starlingbank/docker-debugging-tools:latest
 
docker push quay.io/starlingbank/docker-debugging-tools:${BUILD_NUMBER}
docker push quay.io/starlingbank/docker-debugging-tools:latest
