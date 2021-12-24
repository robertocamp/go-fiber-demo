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
- `docker run -p 3000:3000 fiber-demo`  (3000 is the container port ; 8080 is the browswer port)
- test container connectivity `localhost:3000`
## Cloud Deployment
## links
https://www.digitalocean.com/community/tutorials/how-to-use-go-modules
https://go.dev/blog/using-go-modules
https://zetcode.com/golang/env/
https://tutorialedge.net/golang/working-with-environment-variables-in-go/