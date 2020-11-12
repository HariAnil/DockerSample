# demoBuild
FROM openshift/base-centos7
FROM java:8
MAINTAINER Hari <hari@conflowenc.com>

ENV MULE_VERSION 4.3.0
ENV GRADLE_VERSION 6.8

WORKDIR /opt
RUN wget https://s3.amazonaws.com/new-mule-artifacts/mule-ee-distribution-standalone-${MULE_VERSION}.tar.gz && \
	tar xvzf mule-ee-distribution-standalone-${MULE_VERSION}.tar.gz && \
	rm -rf mule-ee-distribution-standalone-${MULE_VERSION}.tar.gz && \
	mv /opt/mule-enterprise-standalone-${MULE_VERSION} /opt/mule
	
#RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
	#mkdir /opt/gradle && \
	#unzip -d /opt/gradle gradle-${GRADLE_VERSION}-bin.zip && \
	#rm gradle-${GRADLE_VERSION}-bin.zip && \
	#ln -s /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle /usr/local/bin/gradle
	
LABEL io.k8s.description="Platform for building Mule ${MULE_VERSION} CE applications" \
	io.k8s.display-name="Mule ${MULE_VERSION} builder 1.0" \
	io.openshift.expose-services="8081:http" \
	io.openshift.tags="builder, gradle, mule-${MULE_VERSION}"
	
LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i
COPY ./s2i/bin/ /usr/libexec/s2i

RUN chmod -R 777 /usr/libexec/s2i
RUN chown -R 1001:1001 /opt && chmod -R 777 /opt



# TODO: Put the maintainer name in the image metadata
# LABEL maintainer="Your Name <your@email.com>"

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
#LABEL io.k8s.description="Platform for building xyz" \
#      io.k8s.display-name="builder x.y.z" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,x.y.z,etc."

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
#RUN yum install -y rubygems && yum clean all -y
#RUN gem install asdf

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
#COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8081
EXPOSE 7777

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
