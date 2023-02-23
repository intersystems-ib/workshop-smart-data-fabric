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
RUN mkdir -p /opt/irisapp/db
COPY --chown=irisowner:irisowner iris.script iris.script
COPY --chown=irisowner:irisowner src src
COPY --chown=irisowner:irisowner install install
COPY --chown=irisowner:irisowner Installer.cls Installer.cls

# install python libraries we will use
RUN pip3 install --target /usr/irissys/mgr/python/ pandas openpyxl

# run iris.script
RUN iris start IRIS \
    && iris session IRIS < /opt/irisapp/iris.script \
    && iris stop IRIS quietly