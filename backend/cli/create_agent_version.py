"""
Creates a new immutable version of a Bedrock Agent from its current DRAFT state
and prints the version number to stdout. Called from CI/CD after prepare-agent.

Usage: AGENT_ID=<id> python3 create_agent_version.py
"""
import boto3
import os
import sys

agent_id = os.environ.get("AGENT_ID")
if not agent_id:
    print("ERROR: AGENT_ID environment variable not set", file=sys.stderr)
    sys.exit(1)

client = boto3.client("bedrock-agent", region_name="us-east-1")
resp = client.create_agent_version(agentId=agent_id)
print(resp["agentVersion"]["agentVersion"])
