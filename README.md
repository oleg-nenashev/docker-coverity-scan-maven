Coverity Scan for Maven. In Docker
===

Contains an image, which allows running Coverity Scan in Docker 
and uploading results to the [Coverity Scan](https://scan.coverity.com) server.

Currently the repository is in the alpha state. 
The command-line interface may change in an incompatible way.

## Usage

### Command Line

Command line:

```shell
docker run --rm onenashev/coverity-scan-maven <organization> <project> <version> <email> <token>
```

Arguments:

* _organization_ - GitHub organization or username
* _project_ - Project name
* _version_ - Tag or label to be built (no special handling of master by now)
* _email_ - E-mail of the account for Coverity Scan
* _token_ - Upload token

Example:

```shell
docker run --rm onenashev/coverity-scan-maven jenkinsci remoting remoting-2.62  "o.v.nenashev@gmail.com" "$MY_TOKEN" 
```

### Attaching external Maven repository

The project is based on [Docker-Maven](https://github.com/carlossg/docker-maven), 
and all custom features from that project apply to this image.

Maven repository can be passed as a path or as a named volume.

```shell
# Local path (or a path on the Docker host)
docker run --rm -v /Users/oleg-nenashev/.m2:/root/.m2 onenashev/coverity-scan-maven jenkinsci remoting remoting-2.60 "o.v.nenashev@gmail.com" "$MY_TOKEN"
```

```shell
# Named volume
docker run --rm -v maven-repo:/root/.m2 onenashev/coverity-scan-maven jenkinsci remoting remoting-2.60 "o.v.nenashev@gmail.com" "$MY_TOKEN"
```

## Building image

Image takes Coverity installer from the internet, hence it requires specification of credentials (organization, project name, token) for a successful run.

```shell
docker build --build-arg ORGANIZATION=jenkinsci --build-arg  PROJECT=remoting --build-arg TOKEN="$MY_TOKEN" -t onenashev/coverity-scan-maven .
```
