# Configuration file for jupyterhub.
c = get_config()

# Disable authentication and allow access without login
from jupyterhub.auth import DummyAuthenticator
c.JupyterHub.authenticator_class = DummyAuthenticator

# Configure the spawner
c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'

# Set the IP and port for the JupyterHub server
c.JupyterHub.bind_url = 'http://0.0.0.0:8000/'

# Set the log level (optional)
#c.Application.log_level = 'INFO'
