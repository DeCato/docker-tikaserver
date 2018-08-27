FROM ubuntu:latest
MAINTAINER david@logicalspark.com

COPY startup /opt/startup
COPY sshd_config /etc/ssh/

ENV TIKA_VERSION 1.18
ENV TIKA_SERVER_URL https://www.apache.org/dist/tika/tika-server-$TIKA_VERSION.jar
ENV DEBIAN_FRONTEND noninteractive

RUN 	apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN	apt-get update \
	&& apt-get install apt-utils gnupg openjdk-8-jre-headless curl gdal-bin tesseract-ocr \
		tesseract-ocr-eng tesseract-ocr-ita tesseract-ocr-fra tesseract-ocr-spa tesseract-ocr-deu \
		tesseract-ocr-nld less lsof nano -y \
	&& curl -sSL https://people.apache.org/keys/group/tika.asc -o /tmp/tika.asc \
	&& gpg --import /tmp/tika.asc \
	&& curl -sSL "$TIKA_SERVER_URL.asc" -o /tmp/tika-server-${TIKA_VERSION}.jar.asc \
	&& NEAREST_TIKA_SERVER_URL=$(curl -sSL http://www.apache.org/dyn/closer.cgi/${TIKA_SERVER_URL#https://www.apache.org/dist/}\?asjson\=1 \
		| awk '/"path_info": / { pi=$2; }; /"preferred":/ { pref=$2; }; END { print pref " " pi; };' \
		| sed -r -e 's/^"//; s/",$//; s/" "//') \
	&& echo "Nearest mirror: $NEAREST_TIKA_SERVER_URL" \
	&& curl -sSL "$NEAREST_TIKA_SERVER_URL" -o /tika-server-${TIKA_VERSION}.jar \
	&& apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------
# SSH Server support
# ------------------------
RUN 	apt-get update \
    	&& apt-get install -y --no-install-recommends openssh-server \
    	&& echo "root:Docker!" | chpasswd

RUN 	chmod 755 /opt/startup/init_container.sh

EXPOSE 2222 9998
ENTRYPOINT ["/opt/startup/init_container.sh"]
