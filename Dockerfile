FROM alpine:3.19.0
LABEL maintainer="shivam"
WORKDIR /home/jupyterhub
RUN apk --no-cache add \
    python3 \
    py3-pip \
    build-base \
    python3-dev \
    openssl-dev \
    libffi-dev \
    git \
    curl-dev 

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY ./requirements.txt .
Copy ./jupyterhub_config.py .

RUN apk add py-spy --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
 && pip3 install --no-cache-dir -r requirements.txt \
 && pip3 install --no-cache-dir git+https://github.com/jupyterhub/jupyterhub-dummy-authenticator.git \
 && pip3 cache purge

RUN adduser -D jupyterhub
USER jupyterhub

# Expose port and set default command
EXPOSE 8000
CMD ["jupyterhub", "--ip=0.0.0.0", "--port=8000", "--config", "jupyterhub_config.py"]
