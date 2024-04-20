FROM cgr.dev/chainguard/wolfi-base

USER root
RUN apk --no-cache add \
    python3 \
    python3-dev \
    py3-pip \
    git \
    bash \
    npm


    
# Install Jupyter Notebook and Python dependencies

RUN pip3 install --no-cache-dir \
    notebook \
    jupyterlab \
    && adduser -D jovyan
    # -r /tmp/requirements.txt \
    # && rm /tmp/requirements.txt

RUN mkdir -p /usr/share/java/ && \
    curl https://dlcdn.apache.org/pdfbox/3.0.1/pdfbox-3.0.1.jar -o /usr/share/java/pdfbox.jar && \
    curl https://dlcdn.apache.org/pdfbox/3.0.1/fontbox-3.0.1.jar -o /usr/share/java/fontbox.jar

RUN cd /usr/share/java/ && \
    ln -s pdfbox.jar pdfbox-3.0.1.jar && \
    ln -s fontbox.jar fontbox-3.0.1.jar
 
USER jovyan
# COPY npmrc /home/jovyan/.npmrc
# RUN cat /home/jovyan/.npmrc
RUN npm install -g npm@10.5.2 corepack configurable-http-proxy | true
RUN npm cache clean -force | true 
    
#gcloud setuup
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz && \
    tar -C /tmp -xf /tmp/google-cloud-sdk.tar.gz && \
    /tmp/google-cloud-sdk/install.sh && \
    rm -rf /tmp/google-cloud-sdk/platform/bundledpythonunix/lib/python3.11/ensurepip/_bundled/*

ENV PATH $PATH:/tmp/google-cloud-sdk/bin

USER root
COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r  /tmp/requirements.txt

# # Create sudoers directory and set permissions
# RUN mkdir -p /etc/sudoers.d \
#     && chmod 750 /etc/sudoers.d

# # Set up sudo for the non-root user
# RUN echo "jupyter ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jupyter

# Switch to the non-root user
USER jovyan

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

