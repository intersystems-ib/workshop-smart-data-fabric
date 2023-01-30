ARG IMAGE=intersystemsdc/irishealth-ml-community:2022.2.0.368.0-zpm
FROM $IMAGE

USER root

# install additional packages (python)
RUN apt-get update && apt-get install -y \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*

# create directory to copy files into image
WORKDIR /opt/irisapp
RUN chown -R irisowner:irisowner /opt/irisapp

USER irisowner

# copy files to image
WORKDIR /opt/irisapp
COPY --chown=irisowner:irisowner iris.script iris.script
COPY --chown=irisowner:irisowner src src
COPY --chown=irisowner:irisowner install install

# install python libraries we will use
RUN pip3 install --target /usr/irissys/mgr/python/ pandas openpyxl

# -- datapipe download
# download RESTForms2 (requirement). use this version, latest on intersystems-community have some breaking differences on OperErrorsJson fields, etc.
WORKDIR /tmp 
RUN wget https://github.com/isc-afuentes/RESTForms2/archive/master.tar.gz -O restforms2.tar.gz
RUN tar -zxvf restforms2.tar.gz
RUN rm restforms2.tar.gz
# download datapipe
RUN wget https://github.com/intersystems-ib/iris-datapipe/tarball/master -O datapipe.tar.gz
RUN tar -zxvf datapipe.tar.gz
RUN mv intersystems-ib-iris-datapipe-* iris-datapipe-master
RUN rm datapipe.tar.gz

# run iris.script
RUN iris start IRIS \
    && iris session IRIS < /opt/irisapp/iris.script \
    && iris stop IRIS quietly