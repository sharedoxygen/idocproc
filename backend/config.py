import os
from dotenv import load_dotenv

# Load environment variables from the .env file
load_dotenv(os.path.abspath(os.path.join(os.path.dirname(__file__), '../deployments/.env')))  # Absolute path 