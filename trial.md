user16 [ ~/volumes ]$ ls
pod.yaml  sc1.yaml  sc.yaml
user16 [ ~/volumes ]$ kubectl delete all --all
pod "mypod" deleted
service "kubernetes" deleted
user16 [ ~/volumes ]$ kubectl apply -f .
pod/mypod created
Warning: resource storageclasses/azurefile-csi is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
persistentvolumeclaim/my-azurefile unchanged
The StorageClass "azurefile-csi" is invalid: parameters: Forbidden: updates to parameters are forbidden.
user16 [ ~/volumes ]$ kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
mypod   0/1     Pending   0          13s
user16 [ ~/volumes ]$ kubectl get sc
NAME                    PROVISIONER          RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
azurefile               file.csi.azure.com   Delete          Immediate              true                   174m
azurefile-csi           file.csi.azure.com   Delete          Immediate              true                   174m
azurefile-csi-premium   file.csi.azure.com   Delete          Immediate              true                   174m
azurefile-premium       file.csi.azure.com   Delete          Immediate              true                   174m
default (default)       disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   174m
managed                 disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   174m
managed-csi             disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   174m
managed-csi-premium     disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   174m
managed-premium         disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   174m
user16 [ ~/volumes ]$ kubectl describe pods my
Name:             mypod
Namespace:        default
Priority:         0
Service Account:  default
Node:             <none>
Labels:           <none>
Annotations:      <none>
Status:           Pending
IP:               
IPs:              <none>
Containers:
  mypod:
    Image:      mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine
    Port:       <none>
    Host Port:  <none>
    Limits:
      cpu:     250m
      memory:  256Mi
    Requests:
      cpu:        100m
      memory:     128Mi
    Environment:  <none>
    Mounts:
      /mnt/azure from volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-ldfpj (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  volume:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  my-azurefile
    ReadOnly:   false
  kube-api-access-ldfpj:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/memory-pressure:NoSchedule op=Exists
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  76s   default-scheduler  0/1 nodes are available: pod has unbound immediate PersistentVolumeClaims. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling.

user16 [ ~/volumes ]$ kubectl get nodes
NAME                              STATUS   ROLES    AGE    VERSION
aks-default-37898022-vmss000000   Ready    <none>   173m   v1.31.7
user16 [ ~/volumes ]$ kubectl get po,pv,pvc
NAME        READY   STATUS    RESTARTS   AGE
pod/mypod   0/1     Pending   0          7m5s

NAME                                 STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/my-azurefile   Pending                                      my-azurefile   <unset>                 14m
user16 [ ~/volumes ]$ kubectl get sc
NAME                    PROVISIONER          RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
azurefile               file.csi.azure.com   Delete          Immediate              true                   3h
azurefile-csi           file.csi.azure.com   Delete          Immediate              true                   3h
azurefile-csi-premium   file.csi.azure.com   Delete          Immediate              true                   3h
azurefile-premium       file.csi.azure.com   Delete          Immediate              true                   3h
default (default)       disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h
managed                 disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h
managed-csi             disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h
managed-csi-premium     disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h
managed-premium         disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h
user16 [ ~/volumes ]$ ls
pod.yaml  sc1.yaml  sc.yaml
user16 [ ~/volumes ]$ cat sc1.yaml 
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-azurefile
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: my-azurefile
  resources:
    requests:
      storage: 100Gi
user16 [ ~/volumes ]$ kubectl apply -f sc1.yaml 
persistentvolumeclaim/my-azurefile unchanged
user16 [ ~/volumes ]$ kubectl get sc
NAME                    PROVISIONER          RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
azurefile               file.csi.azure.com   Delete          Immediate              true                   3h1m
azurefile-csi           file.csi.azure.com   Delete          Immediate              true                   3h1m
azurefile-csi-premium   file.csi.azure.com   Delete          Immediate              true                   3h1m
azurefile-premium       file.csi.azure.com   Delete          Immediate              true                   3h1m
default (default)       disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h1m
managed                 disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h1m
managed-csi             disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h1m
managed-csi-premium     disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h1m
managed-premium         disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h1m
user16 [ ~/volumes ]$ nano sc2.yaml
user16 [ ~/volumes ]$ kubectl apply -f sc2.yaml 
storageclass.storage.k8s.io/my-azurefile created
user16 [ ~/volumes ]$ kubectl get sc
NAME                    PROVISIONER          RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
azurefile               file.csi.azure.com   Delete          Immediate              true                   3h2m
azurefile-csi           file.csi.azure.com   Delete          Immediate              true                   3h2m
azurefile-csi-premium   file.csi.azure.com   Delete          Immediate              true                   3h2m
azurefile-premium       file.csi.azure.com   Delete          Immediate              true                   3h2m
default (default)       disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h2m
managed                 disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h2m
managed-csi             disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h2m
managed-csi-premium     disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h2m
managed-premium         disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   3h2m
my-azurefile            file.csi.azure.com   Delete          Immediate              true                   9s
user16 [ ~/volumes ]$ kubectl get pv,po,pvc
NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
persistentvolume/pvc-6ae1f23b-c3b2-490a-a364-3d3a4fa379db   100Gi      RWX            Delete           Bound    default/my-azurefile   my-azurefile   <unset>                          24s

NAME        READY   STATUS    RESTARTS   AGE
pod/mypod   1/1     Running   0          9m38s

NAME                                 STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/my-azurefile   Bound    pvc-6ae1f23b-c3b2-490a-a364-3d3a4fa379db   100Gi      RWX            my-azurefile   <unset>                 17m
user16 [ ~/volumes ]$ ls
pod.yaml  sc1.yaml  sc2.yaml  sc.yaml
user16 [ ~/volumes ]$ cat pod.yaml 
kind: Pod
apiVersion: v1
metadata:
  name: mypod
spec:
  containers:
    - name: mypod
      image: mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
        limits:
          cpu: 250m
          memory: 256Mi
      volumeMounts:
        - mountPath: /mnt/azure
          name: volume
          readOnly: false
  volumes:
   - name: volume
     persistentVolumeClaim:
       claimName: my-azurefile
user16 [ ~/volumes ]$ kubectl exec -it mypod -- /bin/sh
/ # cd /mnt/azure
/mnt/azure # mkdir UST
/mnt/azure # cd UST/
/mnt/azure/UST # echo "volumes are working" >> vol.txt
/mnt/azure/UST # exit