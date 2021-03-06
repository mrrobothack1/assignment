# PROCESS

1. Automating the build of the container

2. Setting up the TLS Offloading load balancer

3. Defining the whole infrastructure as code

## Research the technologies you plan to use

The technologies and resources that have been used as Google Kubernetes engine, Kind clusters, cert-manager, ingress-nginx-controller, Let's Encrypt, Cloud DNS(GCP), Freenom, and finally Golang hello world application for testing the certificate generation.

### SOLUTIONS:


### 1 . Application creation and Automating the build of the Golang Web App Container

   We have a Golang file called main.go which prints “Hello World”. For creating a docker image out of it, I have created a dockerfile including the path or the source file.
   
   This process is automated by using the docker build stage which I have mentioned inside the GitLab pipeline. This job will be creating a dockerfile and will be pushing it to the registry so that we can pull it inside our Kubernetes deployment.
   
   <img width="210" alt="image" src="https://user-images.githubusercontent.com/46847735/170844210-1ccdf7a7-f149-4835-b62e-b54cb35544ae.png">


###########################################################

### 2. Setting up the TLS Offloading load balancer in GKE and kind clusters.

   Iam using cert-manager for setting up the TLS process.
   
   **Cert-manager** lives inside the Kubernetes cluster and connects it with a certificate authority like Let’s Encrypt. Then we can ask for a certificate using a yaml file. In the yaml file, we mention the domain that needs the certificate and the secret where the certificate is to be stored.
   
   The cert-manager will talk to the certificate authority and will place the new certificate in the Kubernetes secret. When a certificate is about to expire, the cert-manager will replace it with a new one. This eliminates the need for manual renewal.
   
   Cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates. It will ensure certificates are valid and up to date, and attempt to renew certificates at a configured time before expiry.
   
   <img width="892" alt="image" src="https://user-images.githubusercontent.com/46847735/170844277-cf1ecea8-4ae0-49c9-9971-9d71e38f1d42.png">

 
## Cert Manager Resources

The best way to install a cert-manager into a Kubernetes cluster is to download the yaml file as it has more than 26000 lines of concluding all necessary components. But in this demo we are using helm chart for this resources creation.

```  
curl -LO https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.yaml

# install cert-manager 

kubectl apply --validate=false -f cert-manager-1.0.4.yaml
```

If we want to see the the resources which has been created, do the following commands,
<img width="645" alt="image" src="https://user-images.githubusercontent.com/46847735/170844461-1e63e09c-c264-44b7-9327-f37a7090f71a.png">



## Ingress Controller

In kubernetes cluster, we have a ingress controller which recives public traffic. We will be using it to expect incoming traffic for the Let's Encrypt challange. 

Bu using the helm charts of ingress-nginx, we will be creating the namespaces and other resources which are needed for the nginx-ingress.

<img width="952" alt="image" src="https://user-images.githubusercontent.com/46847735/170844950-d03689c0-c71e-492b-a4de-1428c709b25d.png">



## Setup my DNS

For creating the domian url where I have to point the IP of ingress-nginx-controller, I have used freenom.com

<img width="633" alt="image" src="https://user-images.githubusercontent.com/46847735/170844967-6cdb6961-8598-4e2f-9835-5a0cd4c62efb.png">


To make it work, I have created a cloud DNS in GCP, where i created a DNS, with multiple record-sets which concludes my loadbalancer IP and CNAME.

<img width="526" alt="image" src="https://user-images.githubusercontent.com/46847735/170844993-0d8e8fea-0fb8-4844-9127-c9359a851385.png">


To make the domain url live, I have added the nameservers which were created inside the CLOUD DNS in GCP.

<img width="654" alt="image" src="https://user-images.githubusercontent.com/46847735/170845023-e07cd650-f674-4181-a73c-3358826b4db0.png">


## Create Let's Encrypt Issuer for our cluster

Now we have kubernetes cluster with a ingress controller which takes traffic, also we have cert-manager. Now we have to create a cluster issuer. We have a helm chart under cert-manager for this resources.

<img width="401" alt="image" src="https://user-images.githubusercontent.com/46847735/170845114-a0ec405b-c10d-4340-be95-8dda670c6173.png">
<img width="586" alt="image" src="https://user-images.githubusercontent.com/46847735/170845130-2c5a9f29-d7e2-4ee4-887c-bcc21c81c425.png">


We have to create a certificate where we will be mentioning the clusterIssuer which we created earlier, with the DNS name and the secret name where the tls has to be stored.

<img width="382" alt="image" src="https://user-images.githubusercontent.com/46847735/170845331-318ff1b7-dd55-4335-b2d4-29cfa10dcac0.png">


Also in certifcate which we created earlier, will have the renewal data and when it will be renewed automatically.

<img width="516" alt="image" src="https://user-images.githubusercontent.com/46847735/170862265-94accf4e-05f5-459f-b8cf-dd1d8883ecac.png">


## Deploy a pod that uses SSL

Now as everything is ready to go, we can deploy an example application which was created in the STEP1. (The hello_world program)

Under helm chart we have a deployment.yaml  and service.yaml file where we have mentioned the image name and all the necessary details.

<img width="624" alt="image" src="https://user-images.githubusercontent.com/46847735/170845186-f8038169-a4bb-4823-a1b6-518af7cf4cc2.png">


## Deploy a ingress that route traffic to application service

Now to expose a application via an ingress, we have to an ingress object. So we have a ingress.yaml file inside the helm charts of cert-manager, where we have mentioned the host name and the path where the http should go for. 
 
<img width="570" alt="image" src="https://user-images.githubusercontent.com/46847735/170845342-f1fb10d4-7d65-4016-a4d2-ba17b2bc677c.png">



### RESULT

Now the ingress will be able to pickup traffic and for making it sure, we have to just hit https://golang-demo.ml/ in the browser. 

<img width="698" alt="image" src="https://user-images.githubusercontent.com/46847735/170845361-629bdfd8-65c5-4495-94a2-294c857163be.png">

<img width="321" alt="image" src="https://user-images.githubusercontent.com/46847735/170845374-b6af6215-3aff-4511-814e-11583c21bae8.png">

<img width="460" alt="image" src="https://user-images.githubusercontent.com/46847735/170845392-47b94813-d98e-48b7-b549-57484479ab6f.png">


From the above Pictures, we can understand that we have a secure website and valid certificate which is given from Let's Encrypt Organization.


###########################################################


### 3. Automate the whole process using Gitlab.


write a simple build and deployment pipeline for the docker and helm charts Gitlab CI.

## SOLUTION
We have a .gitlab folder under it, we have

1. templates.yaml file

This file is like a global module that can be used at an organizational level. Once we create any format, we can use it N number of application repos for doing scanning and testing on applications.

I have added a few scans such as yamllint, helm lint, trivy to scan yaml's, and dockerfile for any discrepancies.

There is a job called .gcloud_auth: &gcloud_authand .helm_deploy: &helm_deploy inside templates.yaml file which is used for deploying the helm charts which we have created earlier. And we have which will be deleteing all helm charts which have been created



## HELM-CHART

Helm chart for the whole process.

```
1. Cert-manager
In this chart, we are creating all components of cert-manager which is needed to in use of creating and renewing certificates. This is created under cert-manager namespaces.

2. nginx-controller
Ingress-nginx is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer. This is created under ingress-nginx namespaces.

3. app
In here we are creating issuer and certificate which will be hooking up with the cert-manager which we have created. Also in top of that, it wil automatically create the a secret where the TLS certificate is stored.

Also, we will be creating ingress to route traffic to the applications which be created using the deployment.yaml and service.yaml file.
```



## gitlab-ci.yaml.

To fetch the jobs from templates.yaml file, I have used "include" to fetch it.

Under it we have several stages, each will be described below

```
1. lint

under here we have jobs to check the format and health of the yaml and helm charts

2. build

Under this, we are building the docker image by using kankio. kaniko is a tool to build container images from a Dockerfile, inside a container or Kubernetes cluster. It will build and push the docker images to the container registry which is mentioned by us.

3. scan

Once the image is developed, we will be scanning both dockerfile and image to find any kind of vulnerabilities which will cause us in a production-level environment. These jobs do their scan based on CVE and MISCONF.

4. cert-manager

This is the stage where we create the cert-manager using the curl and helm charts. Also will be creating an issuer which will define certificate Authority, in our case it's let’s Encrypt.

5. ingress-nginx-deploy

Will be deploying an ingress controller which recives public traffic

6. application-deploy

This stage will be deploying the docker images whiwhc we created earlier.

7. destroy

In here we can delete all the helm charts which we have created earlier. This will be a manual prrocess as it's a destroy job.

```
<img width="1413" alt="image" src="https://user-images.githubusercontent.com/46847735/170845678-965639ba-d9ec-45f9-9a15-0407a1fd3c60.png">

