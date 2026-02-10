#!/bin/sh
# setup-credentials.sh
# Bootstrap n8n credential JSON files from environment variables.
# Requires: GITHUB_PAT, NOTION_API_KEY, N8N_ENCRYPTION_KEY
set -eu

CRED_DIR="${CRED_DIR:-$(pwd)/credentials}"
mkdir -p "$CRED_DIR"

# Validate required environment variables
for var in GITHUB_PAT NOTION_API_KEY; do
  eval val="\${$var:-}"
  if [ -z "$val" ]; then
    printf 'ERROR: %s environment variable is not set\n' "$var" >&2
    exit 1
  fi
done

# Generate GitHub PAT credential
cat > "$CRED_DIR/github_pat.json" <<GITHUB_EOF
{
  "id": "1",
  "name": "github_pat",
  "type": "githubApi",
  "data": {
    "accessToken": "${GITHUB_PAT}",
    "server": "https://api.github.com"
  }
}
GITHUB_EOF

# Generate Notion integration credential
cat > "$CRED_DIR/notion_integration.json" <<NOTION_EOF
{
  "id": "2",
  "name": "notion_integration",
  "type": "notionApi",
  "data": {
    "apiKey": "${NOTION_API_KEY}"
  }
}
NOTION_EOF

printf 'Credentials written to %s\n' "$CRED_DIR"
ls -la "$CRED_DIR"
