FROM alpine:latest
LABEL maintainer="shivam"

RUN apk --no-cache add \
    python3 \
    py3-pip \
    build-base \
    python3-dev \
    openssl-dev \
    libffi-dev \
    nodejs \
    npm \
    git \
    bash

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip3 install jupyterhub
RUN npm install -g configurable-http-proxy

RUN pip3 install git+https://github.com/jupyterhub/jupyterhub-dummy-authenticator.git
RUN adduser -D jupyterhub
USER jupyterhub
RUN mkdir ~/.jupyterhub
WORKDIR /home/jupyterhub

EXPOSE 8000

CMD ["jupyterhub", "--ip=0.0.0.0", "--port=8000"]
