SOURCE_ORG="ApplicationM01"  #"source-org"
#TARGET_ORG="ApplicationMT01" #"target-org"
#GITHUB_TOKEN="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"  # Personal access token

API_URL="https://api.github.com/orgs/$GITHUB_TOKEN/installations"

response = $(curl -s -H "Authorization: token $GITHUB_TOKEN"
                     -H "Accept: application/vnd.github.v3+json" "$API_URL")

echo "$response" | jq '.installations[] | {app_name: .app_slug, app_id: .id}'
