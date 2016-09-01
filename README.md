Coverity Scan for Maven. In Docker
===

Contains an image, which allows running Coverity Scan in Docker 
and uploading results to the [Coverity Scan](https://scan.coverity.com) server.

Currently the repository is in the project state. 
The command-line interface may change in an incompatible way.

## Usage

Command line:

```
docker run onenashev/coverity-scan-maven <organization> <project> <version> <email> <token>
```

Arguments:

* _organization_ - GitHub organization or username
* _project_ - Project name
* _version_ - Tag or label to be built (no special handling of master by now)
* _email_ - E-mail of the account for Coverity Scan
* _token_ - Upload token

Example:

```
docker run onenashev/coverity-scan-maven jenkinsci remoting remoting-2.62  "o.v.nenashev@gmail.com" "$MY_TOKEN" 
```