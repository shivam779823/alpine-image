#!/bin/bash

# Set up configurations for the single-user Jupyter notebook server
# For example, setting default URL, authentication, resource limits, etc.
# This script can be customized to include additional functionalities or configurations as needed.

# Start the Jupyter notebook server with the configured settings
# This includes specifying the IP address, port, authentication tokens, etc.
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root "$@"
