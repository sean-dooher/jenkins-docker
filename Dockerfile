FROM jenkins/jenkins:lts
ARG docker_gid=999

USER root

RUN groupadd docker -g $docker_gid
RUN usermod -aG docker jenkins

RUN apt-get update \
     && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common \
     && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
     && add-apt-repository \
 	"deb [arch=amd64] https://download.docker.com/linux/debian \
   	$(lsb_release -cs) \
  	 stable" \
    && apt-get update

RUN apt-get install -y docker-ce python3-pip

RUN pip3 install docker-compose

USER jenkins