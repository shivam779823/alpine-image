# Use the cgr.dev/chainguard/wolfi-base as the base image
FROM cgr.dev/chainguard/wolfi-base

# Install required packages
USER root
RUN apk --no-cache add \
    python3 \
    python3-dev \
    py3-pip \
    git \
    bash \
    nodejs \
    npm \
    curl \
    && rm -rf /var/cache/apk/*

# Install JupyterLab and Jupyter Notebook, add a non-root user, and setup Apache PDFBox jars
RUN pip3 install --no-cache-dir \
    # jupyterhub \
    jupyterlab \
    # 'jupyterhub==4.*' \
    'notebook==7.*' && \
    adduser -D jovyan && \
    mkdir -p /usr/share/java/ && \
    curl https://dlcdn.apache.org/pdfbox/3.0.1/pdfbox-3.0.1.jar -o /usr/share/java/pdfbox.jar && \
    curl https://dlcdn.apache.org/pdfbox/3.0.1/fontbox-3.0.1.jar -o /usr/share/java/fontbox.jar && \
    ln -s /usr/share/java/pdfbox.jar /usr/share/java/pdfbox-3.0.1.jar && \
    ln -s /usr/share/java/fontbox.jar /usr/share/java/fontbox-3.0.1.jar

# Copy and install Python dependencies, create directory for Jupyter
COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    mkdir -p /home/jovyan && \
    chown jovyan:jovyan /home/jovyan && \
    chmod 775 /home/jovyan

# Switch to jovyan user and install npm packages
USER jovyan
RUN npm install -g npm@10.5.2 corepack configurable-http-proxy | true && \
    npm cache clean --force | true && \
    rm -rf ~/.npm 
    # curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz && \
    # tar -C /tmp -xf /tmp/google-cloud-sdk.tar.gz && \
    # /tmp/google-cloud-sdk/install.sh && \
    # rm -rf /tmp/google-cloud-sdk/platform/bundledpythonunix/lib/python3.11/ensurepip/_bundled/*

# Set environment variables and working directory
ENV PATH $PATH:/tmp/google-cloud-sdk/bin
WORKDIR /home/jovyan

# Expose the Jupyter Notebook port and start JupyterLab
# EXPOSE 8888
# CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root"]
# CMD ["jupyterhub-singleuser"]
CMD ["jupyter-lab"]













#-----------------------
# # Use the cgr.dev/chainguard/wolfi-base as the base image
# FROM cgr.dev/chainguard/wolfi-base

# # Install required packages
# USER root
# RUN apk --no-cache add \
#     python3 \
#     python3-dev \
#     py3-pip \
#     git \
#     bash \
#     npm \
#     curl \
#     && rm -rf /var/cache/apk/*

# # Install JupyterLab and Jupyter Notebook, add a non-root user, and setup Apache PDFBox jars
# RUN pip3 install --no-cache-dir \
#     jupyterlab \
#     notebook && \
#     adduser -D jovyan && \
#     mkdir -p /usr/share/java/ && \
#     curl https://dlcdn.apache.org/pdfbox/3.0.1/pdfbox-3.0.1.jar -o /usr/share/java/pdfbox.jar && \
#     curl https://dlcdn.apache.org/pdfbox/3.0.1/fontbox-3.0.1.jar -o /usr/share/java/fontbox.jar && \
#     ln -s /usr/share/java/pdfbox.jar /usr/share/java/pdfbox-3.0.1.jar && \
#     ln -s /usr/share/java/fontbox.jar /usr/share/java/fontbox-3.0.1.jar

# # Copy and install Python dependencies, create directory for Jupyter
# COPY ./requirements.txt /tmp/requirements.txt
# RUN pip3 install --no-cache-dir -r /tmp/requirements.txt && \
#     rm /tmp/requirements.txt && \
#     mkdir -p /home/jupyter && \
#     chown jovyan:jovyan /home/jupyter && \
#     chmod 775 /home/jupyter

# # Switch to jovyan user and install npm packages
# USER jovyan
# RUN npm install -g npm@10.5.2 corepack configurable-http-proxy | true && \
#     npm cache clean --force | true && \
#     rm -rf ~/.npm && \
#     curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz && \
#     tar -C /tmp -xf /tmp/google-cloud-sdk.tar.gz && \
#     /tmp/google-cloud-sdk/install.sh && \
#     rm -rf /tmp/google-cloud-sdk/platform/bundledpythonunix/lib/python3.11/ensurepip/_bundled/*

# # Set environment variables and working directory
# ENV PATH $PATH:/tmp/google-cloud-sdk/bin
# WORKDIR /home/jupyter

# # Expose the Jupyter Notebook port and start JupyterLab
# EXPOSE 8888
# CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root"]
