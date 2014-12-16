Docker Provisioning
============================

Create container for node application

List all images
```
docker ps -a
```

So how fast are LXC vs virtual machines.
```
sudo docker run ubuntu:12.04 /bin/echo 'Hello world'
```

Build image using dockerfile in current directory and tag as jthoms1/node-demo
Run the image in detached mode and forwoard port 8080 of host os to 3000 in the container
```
docker build -t jthoms1/node-demo .
docker run -d -p 8080:3000 jthoms1/node-demo
```

192.168.59.103:8080

List all images
```
docker ps -a
```

Kill the docker image
```
docker kill <imageid>
