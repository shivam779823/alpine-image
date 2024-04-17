
# Use Alpine Linux 3.19.1 as the base image
FROM alpine:3.19.1

# Install system dependencies
# RUN apk --no-cache add \
#     bash \
#     nodejs \
#     npm \
#     git \
#     openssl \
#     sudo \
#     build-base \
#     python3-dev \
#     py3-pip \
#     libffi-dev \
#     openssl-dev \
#     musl-dev \
#     linux-headers \
#     libaio



RUN apk --no-cache add \
    g++ \
    gcc \
    gfortran \
    musl-dev \
    lapack-dev \
    gfortran \
    openblas-dev \
    python3-dev \
    py3-pip \
    build-base \
    libffi-dev \
    openssl-dev \
    libxml2-dev \
    libxslt-dev \
    libjpeg-turbo-dev \
    zlib-dev \
    freetype-dev \
    libpng-dev


RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Jupyter Notebook
RUN pip3 install notebook 

# Install Python dependencies
RUN pip3 install --no-cache-dir \
    numpy==1.23.2 \
    scipy==1.9.3
RUN pip install darts pandas-gbq db-dtypes
RUN pip3 install torch torchvision torchaudio -f https://download.pytorch.org/whl/torch_stable.html
# Install PyTorch (CPU version)
#RUN pip3 install torch==1.10.0+cpu torchvision==0.11.1+cpu torchaudio==0.10.0+cpu -f https://download.pytorch.org/whl/torch_stable.html

# Install Oracle Database drivers
# Note: You'll need to replace the URL with the appropriate version of the Oracle Instant Client for your environment
# Install Oracle Database drivers
# Note: You'll need to replace the URL with the appropriate version of the Oracle Instant Client for your environment
RUN mkdir -p /opt/oracle && \
    wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip -O /opt/oracle/instantclient-basic-linux.x64-21.1.0.0.0.zip && \
    unzip /opt/oracle/instantclient-basic-linux.x64-21.1.0.0.0.zip -d /opt/oracle/ && \
    rm /opt/oracle/instantclient-basic-linux.x64-21.1.0.0.0.zip && \
    ln -sf /opt/oracle/instantclient_21_1/libclntsh.so.21.1 /usr/lib/libclntsh.so && \
    ln -sf /opt/oracle/instantclient_21_1/lib* /usr/lib/ && \
    ln -sf /opt/oracle/instantclient_21_1/sqlplus /usr/bin/sqlplus && \
    pip3 install cx_Oracle


# Install psutil
RUN pip3 install psutil

# Create a non-root user
RUN adduser -D jupyter

# Set up sudo for the non-root user
RUN echo "jupyter ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jupyter

# Switch to the non-root user
USER jupyter

# Set the working directory
WORKDIR /home/jupyter

# Expose the Jupyter Notebook port
EXPOSE 8888

# Start Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--allow-root"]





































# # FROM alpine:3.19.0
# # LABEL maintainer="shivam"
# # WORKDIR /home/jupyterhub
# # RUN apk --no-cache add \
# #     python3 \
# #     py3-pip \
# #     build-base \
# #     python3-dev \
# #     openssl-dev \
# #     libffi-dev \
# #     git \
# #     curl-dev \
# #     && python3 -m venv /opt/venv

# # ENV PATH="/opt/venv/bin:$PATH"

# # COPY ./requirements.txt .
# # COPY ./jupyterhub_config.py .

# # RUN apk add py-spy --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
# #  && pip3 install --no-cache-dir -r requirements.txt \
# #  && pip3 install --no-cache-dir git+https://github.com/jupyterhub/jupyterhub-dummy-authenticator.git \
# #  && pip3 cache purge \
# #  && adduser -D jupyterhub \
# #  && rm -rf /var/cache/apk/*

# # USER jupyterhub
# # EXPOSE 8000

# # CMD ["jupyterhub", "--ip=0.0.0.0", "--port=8000", "--config", "jupyterhub_config.py"]
# FROM alpine:3.19.0
# LABEL maintainer="shivam"
# WORKDIR /home/jupyterhub

# COPY ./requirements.txt .
# COPY ./jupyterhub_config.py .

# RUN apk --no-cache add \
#     python3 \
#     py3-pip \
#     build-base \
#     python3-dev \
#     openssl-dev \
#     libffi-dev \
#     git \
#     curl-dev \
#     && python3 -m venv /opt/venv \
#     && export PATH="/opt/venv/bin:$PATH" \
#     && apk add py-spy --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
#     && pip3 install --no-cache-dir -r requirements.txt \
#     && pip3 install --no-cache-dir git+https://github.com/jupyterhub/jupyterhub-dummy-authenticator.git \
#     && pip3 cache purge \
#     && adduser -D jupyterhub \
#     && rm -rf /var/cache/apk/*

# USER jupyterhub
# EXPOSE 8000

# CMD ["jupyterhub", "--ip=0.0.0.0", "--port=8000", "--config", "jupyterhub_config.py"]




# FROM alpine:3.19.0
# LABEL maintainer="shivam"
# WORKDIR /home/jupyterhub
# RUN apk --no-cache add \
#     python3 \
#     py3-pip \
#     build-base \
#     python3-dev \
#     openssl-dev \
#     libffi-dev \
#     nodejs \
#     npm \
#     git \
#     curl-dev \
#     linux-pam-dev # Install libpam-dev for PAM integration

# RUN python3 -m venv /opt/venv
# ENV PATH="/opt/venv/bin:$PATH"

# COPY ./requirements.txt .
# Copy ./jupyterhub_config.py .

# RUN npm install -g configurable-http-proxy
# RUN apk add py-spy --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
#     && pip3 install --no-cache-dir -r requirements.txt \
#     && pip3 cache purge 

# RUN adduser -D jupyterhub
# # Set the password for the jupyterhub user
# RUN echo "jupyterhub:12345" | chpasswd
# USER jupyterhub

# # Expose port and set default command
# EXPOSE 8000
# CMD ["jupyterhub", "--ip=0.0.0.0", "--port=8000", "--config", "jupyterhub_config.py"]


# #with pam
# # Configuration file for jupyterhub.
# c = get_config()

# # Use the PAM Authenticator
# from jupyterhub.auth import PAMAuthenticator
# c.JupyterHub.authenticator_class = PAMAuthenticator

# # Configure the spawner
# c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'

# # Set the IP and port for the JupyterHub server
# c.JupyterHub.bind_url = 'http://0.0.0.0:8000/'

# # Set the log level (optional)
# #c.Application.log_level = 'INFO'

# # Specify admin users (optional)
# c.Authenticator.admin_users = {'jupyterhub'}

# # Specify allowed users (optional)
# c.Authenticator.allowed_users = {'jupyterhub', 'brenda', 'cory', 'daniel'}

