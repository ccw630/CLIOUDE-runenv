FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

COPY build/java_policy /etc

COPY jdt-language-server /opt

SHELL ["/bin/bash", "-c"]

RUN buildDeps='software-properties-common git libtool cmake python-dev python3-pip libseccomp-dev wget curl zip' && \
    apt-get update && apt-get install -y python python3 python-pkg-resources python3-pkg-resources gcc g++ socat openjdk-11-jdk vim strace ccls $buildDeps

RUN mkdir -p /etc/nodejs && cd /etc/nodejs && \
	curl -sSL https://nodejs.org/dist/latest-v12.x/node-v12.18.0-linux-x64.tar.xz | tar x --xz --strip-components=1 && \
	ln -s /etc/nodejs/bin/node /usr/bin/node && \
    npm i -g flow-bin && \
    npm i -g bash-language-server

RUN	curl -s https://get.sdkman.io | bash && source /root/.sdkman/bin/sdkman-init.sh && \
	sdk install kotlin 1.3.50 && sdk install scala 2.13.0 && \
	mkdir -p /etc/sdkman && \
	cp -r /root/.sdkman/candidates /etc/sdkman/candidates && \
    chmod -R 755 /etc/sdkman/candidates && \
	ln -s /etc/sdkman/candidates/kotlin/1.3.50/bin/kotlinc /usr/bin/kotlinc && ln -s /etc/sdkman/candidates/scala/2.13.0/bin/scalac /usr/bin/scalac && \
    cp -r /etc/sdkman/candidates/kotlin/1.3.50/lib /usr/lib/kotlin && \
    cp -r /etc/sdkman/candidates/scala/2.13.0/lib /usr/lib/scala && \
    rm -rf /root/.sdkman

RUN	cd /tmp && git clone --depth 1 https://github.com/pocmo/Python-Brainfuck.git && mv Python-Brainfuck /usr/bin/brainfuck

RUN pip3 install --no-cache-dir python-language-server