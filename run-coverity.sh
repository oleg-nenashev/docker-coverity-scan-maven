#!/usr/bin/env sh
set -e

printHelp() {
  echo "Runs Coverity Scan for Maven project."
  echo "Usage: docker run onenashev/coverity-scan-maven <organization> <project> <scm_tag> <email> <token>"
  echo ""
}

#TODO: Good parameter processing
if [ $# -eq 0 ]; then
  printHelp
  exit 0
fi
if [ $# -ne 5 ]; then
  echo "ERROR: wrong number of arguments"
  printHelp
fi

ORGANIZATION=$1
PROJECT=$2
SCM_TAG=$3
EMAIL=$4
TOKEN=$5

# Verify parameters
if [ -z "${EMAIL}" ] ; then
  echo "EMAIL is not specified"
  exit 1;
fi 
if [ -z "${TOKEN}" ] ; then
  echo "TOKEN is not specified"
  exit 1;
fi 
if [ -z "${ORGANIZATION}" ] ; then
  echo "ORGANIZATION is not specified"
  exit 1;
fi 
if [ -z "${PROJECT}" ] ; then
  echo "PROJECT is not specified"
  exit 1;
fi 
if [ -z "${SCM_TAG}" ] ; then
  echo "SCM_TAG is not specified"
  exit 1;
fi 

# Prepare build dir
mkdir build
cd build

# Checkout
# TODO: always determine commit and put it to Description
# TODO: better processing of changesets
git clone https://github.com/${ORGANIZATION}/${PROJECT}.git
cd ${PROJECT}
git checkout ${SCM_TAG}

# Run build with maven
cov-build --dir cov-int mvn -DskipTests=true -Dfindbugs.skip=true compile 

# Prepare the submission archive
echo "Archiving cov-int.tgz"
tar czvf cov-int.tgz cov-int

# Upload to coverity
DESTINATION_URL="https://scan.coverity.com/builds?project=${ORGANIZATION}%2F${PROJECT}"
echo "Uploading results to ${DESTINATION_URL}"
curl --form token="${TOKEN}" \
  --form email="${EMAIL}" \
  --form file=@cov-int.tgz \
  --form version="${SCM_TAG}" \
  --form description="Automatic Coverity Scan build for ${SCM_TAG}" \
  ${DESTINATION_URL}
  