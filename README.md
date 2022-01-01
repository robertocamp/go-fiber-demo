# go-fiber-demo
project to explore the go fiber framework and deploy to cloud
## setup
### go modules
> Go modules were added in response to a growing need to make it easier for developers to maintain various versions of their dependencies, as well as add more flexibility in the way developers organize their projects on their computer.
- A module is a collection of Go packages stored in a file tree with a go.mod file at its root.
- The go.mod file defines the module’s module path, which is also the import path used for the root directory, and its dependency requirements, which are the other modules needed for a successful build.
- Each dependency requirement is written as a module path and a specific semantic version.
### setup-steps
1. cd to the root of the Project
2. `go mod init`  :creates a go.mod file in the Project
3. `go get github.com/gofiber/fiber/v2` :creates dependency in the Project for gofiber; go.mod is updated
4.  create **main.go**:  use the "hello-world" examle from the "https://github.com/gofiber/recipes" repo
5.  `cp /Users/robert/Documents/CODE/recipes/hello-world/main.go .`
6.  smoke test tehe app:  `go run main.go` :this should standup the basic http endpoint at `localhost:3000`
## Dockerfile
### create two Dockerfile versions: one using `go mod download` and one not using the download method
  1. `go mod download`
  2. without `go mod download`
### Docker build
- `docker build -t fiber-demo .`
- docker build -t fiber-demo-certs-added .
### Docker run
- `docker run -p 3000:3000 fiber-demo`  (3000 is the container port ; 3000 is the browswer port)
- `docker run -p 8080:3000 fiber-demo` (3000 is the container port ; 8080 is the browswer port)
- test container connectivity `localhost:3000` (or `localhost:8080`)

## Prometheus metrics
- Prometheus has an official Go client library that you can use to instrument Go applications.
- To expose Prometheus metrics in a Go application, you need to provide a /metrics HTTP endpoint.
- You can install the prometheus, promauto, and promhttp libraries necessary for the guide using go get:
```
go get github.com/prometheus/client_golang/prometheus
go get github.com/prometheus/client_golang/prometheus/promauto
go get github.com/prometheus/client_golang/prometheus/promhttp
```
### fiberprometheus
- support for Prometheus can be added as a middleware to fiber:
- https://github.com/ansrivas/fiberprometheus
- `go get -u github.com/ansrivas/fiberprometheus/v2`
- 

## Cloud Deployment
### IAM user
> When you create an Amazon EKS cluster, the AWS Identity and Access Management (IAM) entity user or role, such as a federated user that creates the cluster, is automatically granted system:masters permissions in the cluster's role-based access control (RBAC) configuration in the Amazon EKS control plane.
- Initially, only the creator of the Amazon EKS cluster has system:masters permissions to configure the cluster.
- this IAM user does not appear in any visible configuration
- make sure to keep track of which IAM entity created the cluster
- To grant additional AWS users or roles the ability to interact with your cluster, you must edit the *aws-auth ConfigMap* within Kubernetes
- The ConfigMap allows other IAM entities, such as users and roles, to access the Amazon EKS cluster
  + It's a best practice to avoid adding cluster_creator to the ConfigMap
  + improperly modifying the ConfigMap can cause all IAM users and roles (including cluster_creator) to permanently lose access to the Amazon EKS cluster
  + You don't need to add cluster_creator to the aws-auth ConfigMap to get admin access to the Amazon EKS cluster
#### Identify the IAM user or role for the cluster creator ("master access")
- To identify the cluster creator, search for the **CreateCluster** API call in AWS CloudTrail, and then check the **userIdentity** section of the API call.
-  `aws cloudtrail lookup-events --region us-east-2 --lookup-attributes AttributeKey=EventName,AttributeValue=CreateCluster`
-  once you have identified the IAM user from the CreateCluster API call, if that is the user who will be deploying the container manifest(s) with `kubectl` , we should be OK
#### AWS CloudTrail
- AWS CloudTrail is an AWS service that helps you enable governance, compliance, and operational and risk auditing of your AWS account
- CloudTrail is enabled on your AWS account when you create it.
- You can easily view recent events in the CloudTrail console by going to Event history
- When activity occurs in your AWS account, that activity is recorded in a CloudTrail event.
### docker container
#### multi-stage docker builds
- Each instruction in the Dockerfile adds a layer to the image
- best practice is to clean up any artifacts you don’t need before moving on to the next layer
- goal is that each layer has the artifacts it needs from the previous layer and nothing else.
- https://docs.docker.com/develop/develop-images/multistage-build/
- https://blog.bitsrc.io/a-guide-to-docker-multi-stage-builds-206e8f31aeb8
- https://blog.alexellis.io/mutli-stage-docker-builds/
- The general syntax involves adding FROM additional times within your Dockerfile - whichever is the last FROM statement is the final base image.
- To copy artifacts and outputs from intermediate images use COPY --from=<base_image_number>
#### docker image repositories
- https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html

### kubernetes deployment
### test the app
## links
https://www.digitalocean.com/community/tutorials/how-to-use-go-modules
https://go.dev/blog/using-go-modules
https://zetcode.com/golang/env/
https://tutorialedge.net/golang/working-with-environment-variables-in-go/
https://github.com/aws-samples/eks-aws-auth-configmap
https://aws.amazon.com/premiumsupport/knowledge-center/amazon-eks-cluster-access/
https://bobbyhadz.com/blog/aws-cli-turn-off-pager