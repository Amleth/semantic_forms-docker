# inspiration: https://github.com/hseeberger/scala-sbt/blob/master/Dockerfile

FROM openjdk:8
RUN apt-get update
RUN apt-get upgrade -y

ENV SCALA_VERSION 2.12.5
ENV SBT_VERSION 1.1.2

RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
	echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc

RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
	sbt sbtVersion

WORKDIR /root

RUN cd /root && git clone https://github.com/deductions/banana-rdf
RUN cd banana-rdf && sbt compile && sbt publishLocal
RUN cd /root && git clone https://github.com/jmvanel/semantic_forms.git
RUN cd semantic_forms/scala && sbt run
