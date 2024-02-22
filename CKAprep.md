# 02/09/2024 was the beginning for the Kuberntetes on the Techtorial platform.
# 02/11/2024 is today's date start for CKA prep kinda thing.

# https://www.youtube.com/watch?v=d6WC5n9G_sM First course by Stashchuk.com freeCodeCamp
# Course plan
- Terminology and key features of Kubernetes
- Creating a k8s cluster locally
- Create and scale deployments
- Build custom Docker image and create deployment using published image
- Create services and deployments using YAML files
- Connect different deployments together.
- Change container runtime from the Docker to CRI-O

Kubernetes is container orchestration system. Allows you to create containers on different VMs or physical servers without our intervention.
K8s because 8 letter between start and end letter.

- K8s takes care of automatic deployment of the containerized applications across different servers.
- Distribution of the load across multiple servers.
- Auto scaling of the deployed applications
- Monitoring and health check of the containers
- Replacement of the failed containers

Since it is managing CONTAINERS, it is supposed to use some runtime like Docker, CRI-O, containerd
Pod is the smallest unit in the K8s world. And containers are created inside of pods. SO:
Pod(Container, Container, Shared Volumes, Shared IP Address), so could be several containers per pod

One container per pod is the common use case.

One pod, one server!!!!

Kubernetes Cluster(Node(Pod(container), Pod, ..., Pod), Node, Node, Node, ..., Node)

Master Node(Control Plane) -> Worker Node, Worker Node, Worker Node, ...

Master Node(API server, Scheduler(planning and distributing the load), Kube Controller Manager, Cloud Controller Manager, etcd, kubelet, kube-proxy, container runtime), worker node(kubelet, kube-proxy, container runtime)

# Cluster management - kubectl - kube control
Using this you can manage remote clusters.

kubectl connects with master node with HTTPS. 

# Required software
We can use minikube to avoid paying in cloud service.
Creates Kubernetes cluster with single Node.
To create a virtual node you need : VirtualBox, Docker, VMware, Hyper-V, Parallels

# minikube start
Start some vm or docker as a virtual machine and we can check the status with minikube status and connect to the cluster via SSH either with ssh or minikube ssh(if you use docker) command.

Default minikube node user credentials:
username: docker
password: tcuser

kubectl cluster-info will show the cluster info.

On minikube this single node acts both like a master node and a worker node.

kubectl get nodes will show you all the nodes
kubectl get pods will show you all the pods in the default namespace(-A will show for all namespaces, -n for specific, -o wide will give an ip address for the pod)
kubectl get namespaces shows all namespaces
kubectl run nginx --image=nginx will run a pod with nginx container inside. Name before the image doesnt have to be the same as the image name
kubectl describe pod <pod-name> will show all the metadata and inforamtion about the container

If a Docker is a runtime for containers, then if you create a pod with a container inside, there always would be a "/pause" container running along with it.

if you go inside a container from the node of minikube (after minikube ssh) you can do hostname to know the hostname and hostname -i to see the ip address of the container. Then you can do curl and the ip address of the container and if you are using the nginx you should see the nginx welcome page.

Since this is an internal Ip or private IP we cannot connect to it with our local machine on which minikube is running.

kubectl delete pod <pod-name> will delete the pod

Deployment - a distribution tool for pods (pods are supposed to be the same always in one deployment)

kubectl create deployment <deployment name> --image=<image name>
kubectl describe deployment <deployment-name>

Selectors are used to connect pods with deployments cause pods and deployments are separate objects.
Strategy type of a deployment is usually a rolling update.
Label of the selector is the same as pod's label that's how they are connected.
Replica set manages all pods related to deployment - it is a set of replicas which are pods (hundreds and hundreds of them could be there)

Name of the pods are starting with the name of the deployment too. Different hash for each pod but the same prefix for the pods in the same deployment

# Let's try to scale pods in the deployment
kubectl scale deployment nginx-deployment --replicas=5
If you run K8s in the multiple pods you can see how they are assigned to these different pods after you scale them

If we will try to curl these ip addresses of pods from the local machine rn it won't work
But if we connect to the cluster we can curl it.

# There are three pods managers like Deployments
- StatefulSets(STS)
kubectl get sts -A
- DaemonSets(DS)
kubectl get ds -A
- Deployments
kubectl get deployments -A
There are differencies for each of them.
Stateful sets are the ones you should be most careful with. 

You can edit deployments, Ds, STS, and it's YAML file. So if you want to have more replicas, you can either use the command or edit it there.

hpa - horizontal pod autoscaler

Better don't delete the pod manually because it will take more time in the usual workload. Use kubectl rollout restart sts <sts-name>

Cluster's IP address that you get with kubectl get services or svc is internal IP address so it is not available outside of the cluster.
Cluster IP could be utilized only to connect to pods internally.

If your namespace stuck in terminating state and stuff like that, to delete it you need to delete everything under spec.finalizers

We are gonna define resources and quota to namespaces so they don't consume each other's CPU, memory and so on.
We need namespaces in order to segregate the duties. So it could be an interview question (I will separate my applications on the namespace level)

In the regular k8s we can get all the most consuming pods by running kubectl top pods.

We can get yaml manifest of the pod, or deployment, or sts, and so on with| kubectl get pod <pod-name> -o yaml

So we have to separate our applications with the namespaces.

# Resource Quotas
Helps us to limit the amount of compute resources that can be consumed by a set of pods in a namespace. A resource quota is defined as a K8s object that specifies the maximum amount of CPU, memory, and other resources that can be used by pods in a namespace. That is being done to avoid unnecessary costs. The maximum number of pods that can be created in the namespace, the total amount of CPU and memory that can be requested by all pods in the namespace.

There is a tool called goldilocks, it is an open-source tool which you can use to control the Resource Distribution and Resource Management. So when developers develop an application, they use goldilocks to control the resource consumption.

# Limit Range
LimitRange is a resource object that is used to specify default and maximum reosurce limits for a set of pods in a namespace. Sets for individual pods or containers within a namespace, while ResourceQuota is used to set hard limits on the total amount of resources. Resource quota will affect all the resources and limit range is working on the pod level.
So it is gonna block us from let's say creating a pod that consumes 700m CPU when it constrain it for 500m

It will apply to only newly created pods, but not the existing pods. Thus, pods are not editable. So you need to delete the pod and create it again.

# Resource Requirements and Limits
Usually being set by the developers. We can set the requested cpu and memory and limit of cpu and memory on a container level. 100miliCPU equals (0.1CPU). so 1000mCPU is 1 CPU.

# Services
Services are a core component in K8s that are used to manage networking and traffic flow within a cluster. They provide a stable IP address and DNS name for a set of pods and allow for communication between different components within and outside of the applications.

# Different service providers
## ClusterIP, NodePort, LoadBalancer.
We can switch between them.

# Assignment
Deploy a grafana and try to change a service provider to nodeport type and make it to work and don't use port forwarding to accees application use NodePort service to access to application.

# When we scale our deployment it automatically distributes a traffic to the pods.

If we delete our service (deployment exposement) we, therefore, won't be able to connect to the cluster. However, if we create a new service with type NodePort, we will be able to connect to the deployment using node ip address (connect to the specific pod) and we can even do that in the browser but not with docker as a vm unfortunately.

🎉  Opening service default/k8s-web-hello in default browser...
👉  http://127.0.0.1:40909
❗  Because you are using a Docker driver on linux, the terminal needs to be open to run it.

# When we use the LoadBalancer as a service type
We will see external ip pending when kubectl get svc.

🎉  Opening service default/k8s-web-hello in default browser...
👉  http://127.0.0.1:40909
❗  Because you are using a Docker driver on linux, the terminal needs to be open to run it.

# Let's try to update the version of the image on our pods
If the strategy is the rolling update, new pods will be created with the new image and the old pod will stay with old image until replaced.

docker build . -t mirow228/k8s-web-hello:2.0.0

kubectl set image deploy k8s-web-hello k8s-web-hello=mirow228/k8s-web-hello:2.0.0 is a command to do when an image in a deployment is updated.

and when we do kubectl get pods we will see that these pods are 50-55 s old, meaning that the old pods were destroyed

So when we will do minikube service k8s-web-hello we will see our pods updated and our app is updated.

And also when there is a rollout update replica set for the old image stays there.

# another step
Now we are going to deploy another two applications together so our application takes all the regular requests to / and shows our app, but if request is for lets say /nginx then it is forwarding the request to another app nginx.

# Scheduling
How scheduling works. When a pod is created it is not assigned to any specific Node initially. Instead, the pod is marked as "unscheduled" and is added to a scheduling queue. The scheduler continously watches this queue and selects an appropriate Node for each unscheduled Pod. The scheduler uses a set of rules to determine which nodes are eligible for scheduling.
## Pod scheduling
And also scheduler checks the CPU and memory requirements specified in the pod's config and ensures that the selected node has enough resources to run the pod.
## Taint
Nodes can be tainted to indicate that they have specific restrictions on the pods that can be scheduled on them. 
So we can for example dedicate one node to specific resources. Pods also can specify tolerations for these taints, which allow them to be scheduled on the tainted nodes.
# Node Selectors
Users can also specify them, which are labels that are applied to nodes in the cluster. The scheduler can use these selectors to filter out nodes that don't match the pod's requirements.
# Node Affinity Types
requiredDuringSchedulingIgnoredDuringExecution
- Ensure that the pod is only scheduled on nodes that match the specified node selector rules.
- If no nodes match the node selector rules, the pod remains unscheduled.
preferredDuringSchedulingIgnoredDuringExecution
- The scheduler will attempt to schedule the pod on a node that matches one of the rules.
- If no nodes match any of the rules, the pod may be scheduled on any node.
You cannot edit the pod on the fly, only through a deployment.
# Priority Class & Preemption
K8s have a feature to prioritize creation of specific pods to make sure they are created first.
# Pod disruption budget
We have an opportunity to keep particular percentage of the pods available with pod disr budget.
# Static pod
is a pod that is managed directly by the kubelet inside of the cluster.
# Cortex
While prometheus keeps the logs only for 6 hours, cortex can store them for more than a year, what is might be required by compliance and regulatory departments.
# Metrics Server
Is a component of Kubernetes that provides container resource metrics for built-in autoscaling pipelines. It collects resource metrics from Kubelets and expose them through the Metrics API in the Kubernetes API server.
We can see cpu, memory consumption.
# Horizontal pod Autoscaling
Ability of k8s to automatically adjust the number of running instances of a specific workload or application based on the current demand or load. Autoscaling helps to ensure that there are enough resources available to handle the workload while also optimizing resource utilization.
# Vertical pod autoscaling
Scaling up and down of CPU and memory.
# ConfigMaps
Are k8s resources that can be used to store configuration data as key-value pairs. You can create a ConfigMap with the desired configuration data, and then reference it in your Deployment or Pod specification using the 'configMapKeyRef'
We can use it with environment variables, and secrets files
# Secrets
Are similar to Config Maps but are used to store sensitive information such as passwords, APIs or tokens. 
We can both encode and decode secrets on the machine that we are working on, so it is not safe to store it there.
So in the companys it should be stored in the Vault, or Secret Manager.

To use a secret in a pod you can mount it as a volume or use it as an environment variable. To update a secret you can use the kubectl edit secret command or edit the yaml file directly and apply the changes. using kubectl edit secret <name-of-secret>

There are several types of secrets in k8s such as:
1. Opaque: default secret type in K8s. Encoded
2. TLS:
3. Docker-registry:
4. SSH:
5. Service Account:
        
Quick reminder: It is better not to create and give an environment variable or config map variable with dash or hyphen to the pod since in linux it is problematic to reference (-) symbol

# initContainer
Is to perform some initialize or setup task that are required for the main container to start running.
- They are always run to completion. 
- Successful complete required before the next one starts.
- Being usually specified in the spec of the Pod.
- Use case: Retrieve the secrets from the vault because only init container have permission to and not usual app containers.
- Use case: Create database schema.
- Use case: Warm up cache. You can preload some frequently used cache to the redis before other container starts.

Assignment: Do the practice on the init containers page of k8s.

# Side car containers.
Is a container that is deployed alongside a main container in a pod. The main container is typically an application that performs some specific action while the sidecar container provdies support or complementary functionality to the main container
Use cases:
- Logging and Monitoring
- Backup and Recovery
- Service mesh: Istio or LInkerd for example. A service mesh provides additional functionality for managing and securing communication between services in k8s.

# Jobs and CronJobs 
Are being used for one or few time jobs. Cron jobs can be scheduled with jobs inside. So for example schedule a Velero sidecar container to be ran every midnight to do the backup and terminate this sidecar container.

# Node maintenance
If you work with the cloud in the company there is no need to maintain it. We go to EKS or GKE dashboard. 

1. You will go to EKS dashboard
2. Upgrade lower environment first.
3. Check application and all API's before upgrade. If they are compatible with newer K8s version.   
4. helm mapkubeapisys to check if they are suitable with the newer version.
5. In the dashboard you will see some warnings about versions.
6. First upgrade the addons for EKS. (e.g csi drivers, cni drivers)
7. cluster k8s version upgrade - one minor version per upgrade.

In GKE you are not gonna have add-ons.












































































































