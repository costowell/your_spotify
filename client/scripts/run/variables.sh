#!/bin/sh

if [[ "$NODE_ENV" == "development" ]]
then
    # Modify the dev file
    VAR_PATH="/app/public"
else
    # Modify the built file
    VAR_PATH="/app/build"
fi

