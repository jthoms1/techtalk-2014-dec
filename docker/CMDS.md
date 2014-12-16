Docker Provisioning
============================

Create container for node application

```
cd node_app
docker build -t jthoms1/node-app
```

List all images
```
docker ps -a
```

So how fast are LXC vs virtual machines.
```
sudo docker run ubuntu:14.04 /bin/echo 'Hello world'
```
