#!/bin/bash

# Variables
SOURCE_ORG="ApplicationM01"  #"source-org"
TARGET_ORG="ApplicationMT01" #"target-org"
#GITHUB_TOKEN="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"  # Personal access token

# Function to make API calls
function call_api() {
    local method="$1"
    local endpoint="$2"
    curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.v3+json" \
         -X "$method" "https://api.github.com$endpoint"
}

# Step 1: List installed GitHub Apps
echo "Listing installed GitHub Apps for $SOURCE_ORG..."
apps=$(call_api GET "/orgs/$SOURCE_ORG/installations")

# Step 2: Iterate over installed apps
for app_id in $(echo "$apps" | jq -r '.[].id'); do
    echo "Processing app with ID: $app_id"

    # Step 3: Uninstall the app from the source organization
    echo "Uninstalling app from $SOURCE_ORG..."
    call_api DELETE "/orgs/$SOURCE_ORG/installations/$app_id"

    # Step 4: Install the app in the target organization
    echo "Installing app in $TARGET_ORG..."
    response=$(call_api POST "/orgs/$TARGET_ORG/installations" \
        -d "{\"app_id\": $app_id}")

    echo "Response: $response"
done

echo "Migration complete!"
