From centos:centos7

RUN echo 'Hello World'

LABEL maintainer="sboddu@ebi.ac.uk"


RUN yum update -y \
  && yum install -y bzip2 curl file gcc gcc-c++ git make ruby patch sudo which wget openssh \
  && yum groupinstall 'Development Tools' -y \
  && yum clean all

RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
	&& useradd -m -s /bin/bash ens_adm \
	&& echo 'ens_adm ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers


USER ens_adm


ARG PROJECT_ROOT=/home/ens_adm


WORKDIR ${PROJECT_ROOT}

ENV WEBCODE_LOCATION=${PROJECT_ROOT}/ensweb/ \
    WEB_SOFTWARE_DEPENDENCIES_LOCATION=${PROJECT_ROOT}/ensweb-software/ \
    WEB_TMP_DIR=${PROJECT_ROOT}/ensweb-tmp/ \
    HOMEBREW_NO_ANALYTICS=1 \
    HOMEBREW_NO_AUTO_UPDATE=1 \
    DISABLE_USER_INPUT_PROMPTS=1

RUN mkdir -p ${WEBCODE_LOCATION} ${WEB_SOFTWARE_DEPENDENCIES_LOCATION} ${WEB_TMP_DIR}

WORKDIR ${WEB_SOFTWARE_DEPENDENCIES_LOCATION}


#######################

#RUN wget https://github.com/Ensembl/linuxbrew-automation/archive/1.0.0.tar.gz \
#    && tar -xvzf 1.0.0.tar.gz

#WORKDIR ${WEB_SOFTWARE_DEPENDENCIES_LOCATION}/linuxbrew-automation-1.0.0

RUN git clone https://github.com/Ensembl/linuxbrew-automation.git
WORKDIR ${WEB_SOFTWARE_DEPENDENCIES_LOCATION}/linuxbrew-automation
RUN git checkout docker && /bin/bash -c "source 01-base.sh"
#######################


CMD ["/bin/bash"] 
