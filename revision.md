## Docker Image
-> A Docker image uses a layered file system. Each instruction in a Dockerfile typically creates a new layer in the image.
-> These layers are read-only, and when a container is run from the image, a writable layer is added on top.
-> Each line from a Dockerfile becomes a file, created in the vars/lib/docker which is the root directory, where all the metadata is saved.
-> Images are stored in the folder `overlay2` which is the default storage driver.  AUFS and BTRFS are other methods, pros and cons based on the use cases. The method can be changed via `daemon.json`.
-> The image is stored as layers, almost proportional to the number of lines in the Docker file. 'Almost proportional' because some things might already be there so they are ignored.Docker reuses existing layers from the cache if an identical layer already exists—making builds faster and more efficient. Example: If there are multiple Docker files with some common lines, Docker is intelligent enough to not repeat the same things again.
-> Each Dockerfile instruction is executed in an intermediate container, and its resulting filesystem state is committed as a new image layer.
-> vars/lib/docker/containers, is a writeable layer and contains the details of all the running and stopped containers.

---

## Docker Containers
-> Runtime instance of an image, but it is just a process.
-> Installing Docker installs Docker Client and Docker Daemon(background processes).
-> Can be checked using `systemctl status docker`
-> The client and the daemon communicate using REST API, the client intercepts our requests, translates them to REST and send them to the daemon.
-> We can see the layers using `docker image inspect nginx`
-> Running containers continue referencing to the images, so they keep accessing the "Work_dir and ___" in the overlay2 folder, rest are the layers for the image.
-> Containers are ephemeral, as long as there are no processes in the containers, it will exist.
-> `docker run -dit ubuntu`
-> Cgroups and namespaces
-> All the processes in a Linux machine are connected to the Root-Namespace.
-> There are 6 namespaces:
    -> Hostname
    -> Filesystem
    -> Network
    -> Process
    -> Interprocess communication
    -> User
-> All the containers are in pseudo-isolation, they run on the same mahcine but don't interact with each other.

-> When a container is created, it loads the system files to the memory, this process is very fast as only the essential files are loaded into memory. One issue arises when another process comes into the system and requires another file which hasn't been loaded. To deal with this, the daemon searches for the files in each layer till it finds the file and loads it into memory, this process is called CopyOnWrite(COW). This process might take a long time if there are multiple layers. To deal with this issue, we can reduce the number of layers, one such process is called Multi-Layer_Builds.

## Docker Volumes
-> Docker containers are ephemeral and if you want to persist the data then you have to attach a volume.
-> Create a volume:
` docker run -it -v /home/kp/test:/home/myvolume ubuntu bash `
-> `docker stop` and `docker kill` are 2 ways to stop a container, `stop` is a graceful way while `kill` is a brute force method to stop a container.
-> We can attach this volume to multiple containers and they can communicate with each other. 
-> Is accessible on the host machine too.

## Docker Networking
-> Every machine has an `eth0`, both host machine and containers. `eth0` is the default network interface name for the first Ethernet device on a Linux system, used to handle network communication.
-> `docker0` is the default virtual bridge network interface created by Docker to allow communication between containers and the host.
-> Docker creates the `docker0` bridge (usually 172.17.0.1) and uses iptables to route traffic between containers (in 172.17.0.0/16 subnet) and the host or external networks. The request is sent by the `eth0` of the host to `docker0` which will then forward the request to the appropriate container.
-> Whenever we create a new container, it will automatically create a new network device with all the appropriate connections and devices, like `eth0`
-> Can be viewed in the host machine using `ip a`.
-> A container will have its IP address assigned according to the IP Table and this IP will be used as the container's `eth0`.
-> We can create a new `network interface` to communicate between the containers, isolated from the host network. This interface will have a different subnet range(172.18.0.0/16) and any container attached to this interface will have a different IP. 
-> Usually, the containers connected to different networks can't communicate. We can use the command `docker network connect mynetwork <containerID>` to connect the container to `mynetwork`. This will result in the container obtaining 2 IP Addresses, one in each subnet. Now the container can communicate with containers in both network, using the specific IP Address belonging to that network.

## Persistent types
-> TempFS => It stores the data in the memory(Container gone, memory gone. Non-persistent)
-> Bindmount => Attach any location from host machine to container.
 ` docker run -it -v /home/kp/test:/home/myvolume ubuntu bash `
 -> Volume => `docker volume create `
    -> Voumes are created in the `var/lib/docker/volume` directory.
    -> It is different from bindmount cuz volumes are created in the Docker root folder and also provides better security.
    -> Anonymous volumes: ` docker run -it -v /test ubuntu bash `, this will create an anonymous volume in the container with the name `test`. In the host machine, a folder/volume will be created in the `var/lib/docker/volume` directory with the name of a random string.


---

# Kubernetes

## Master
-> Scheduler, Controller, API Server and ETCD.
-> ETCD is a No-SQL database and stores key-value pair.
-> ETCD is the only persistent storage on the Master
-> The other components are non-persistent and hence easier to scale.

    ->API Server: Authenticate, authorize, validate and communicate. Authentication is done by checking the user certificates by the kubectl who makes a REST API request.
    ->Scheduler: Its job is to find out which node is the best one to run a pod.
    -> Controller: Manages the state.

## Pods
-> Smallest unit in K8s where one or more containers are running
