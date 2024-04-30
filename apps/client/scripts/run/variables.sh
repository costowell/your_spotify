#!/bin/sh

if [[ "$NODE_ENV" == "development" ]]
then
    # Modify the dev file
    VAR_PATH="/app/apps/client/public"
else
    # Modify the built file
    VAR_PATH="/app/apps/client/build"
fi

# Restricting connect-src to API_ENDPOINT with a trailing /, or to * if hostname has an _
CSP_CONNECT_SRC=$API_ENDPOINT
if [[ "$CSP_CONNECT_SRC" == *_*.*.* ]]
then
    echo "It seems that your subdomain has an underscore in it, falling back to less strict CSP"
    CSP_CONNECT_SRC="*"
elif ! echo "$CSP_CONNECT_SRC" | grep -q "/$"
then
    CSP_CONNECT_SRC="$CSP_CONNECT_SRC/"
fi

sed -i "s#connect-src \(.*\);#connect-src 'self' $CSP_CONNECT_SRC;#g" "$VAR_PATH/index.html"

# Handling frame-ancestors preferences
SERVE_CONFIG_PATH="/app/apps/client/scripts/run/serve.json"

if [[ -z "$FRAME_ANCESTORS" ]]
then
    FRAME_ANCESTORS="'none'"
elif [[ "$FRAME_ANCESTORS" == "i-want-a-security-vulnerability-and-want-to-allow-all-frame-ancestors" ]]
then
    FRAME_ANCESTORS="*"
else
    FRAME_ANCESTORS=${FRAME_ANCESTORS//,/ }
fi

sed -i "s#frame-ancestors \(.*\);#frame-ancestors $FRAME_ANCESTORS;#g" "$SERVE_CONFIG_PATH"
