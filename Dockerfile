# The MIT License
#
#  Copyright (c) 2016, Oleg Nenashev
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

# Default image location: onenashev/coverity-scan-maven 
FROM maven:3.3.9-jdk-8
MAINTAINER Oleg Nenashev <o.v.nenashev@gmail.com>
LABEL Description="This image is used to run Coverity Scan with Maven on a clean environment" Vendor="Oleg Nenashev" Version="0.  "

ARG EMAIL=o.v.nenashev@gmail.com
ARG TOKEN
ARG PROJECT
#TODO: Support master as a default version (fetch changeset)
ARG VERSION
ARG ORGANIZATION=jenkinsci
ARG COVERITY_SCAN_VERSION=8.5.0.3

RUN useradd -c "Coverity Scan user" -d /home/sauser/ -m sauser

# Install Development Tools
RUN apt-get install git

# Install Coverity Scan Tool
WORKDIR /home/sauser/
RUN wget https://scan.coverity.com/download/linux64 --post-data "token=${TOKEN}&project=${ORGANIZATION}%2F${PROJECT}" -O coverity_tool.tgz
RUN tar zxf coverity_tool.tgz
ENV PATH "$PATH:/home/sauser/cov-analysis-linux64-$COVERITY_SCAN_VERSION/bin"

# Propagate build script
COPY run-coverity.sh /usr/local/bin/run-analysis
RUN chmod +x /usr/local/bin/run-analysis

USER sauser

ENTRYPOINT ["run-analysis"]