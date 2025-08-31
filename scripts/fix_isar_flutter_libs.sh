#!/bin/bash

# Path to the isar_flutter_libs build.gradle file
ISAR_GRADLE_FILE=~/.pub-cache/hosted/pub.dev/isar_flutter_libs-3.1.0+1/android/build.gradle

# Check if the file exists
if [ -f "$ISAR_GRADLE_FILE" ]; then
    echo "Found isar_flutter_libs build.gradle file at $ISAR_GRADLE_FILE"
    
    # Check if namespace is already added
    if grep -q "namespace" "$ISAR_GRADLE_FILE"; then
        echo "Namespace already exists in the file. No changes needed."
    else
        # Create a backup of the original file
        cp "$ISAR_GRADLE_FILE" "${ISAR_GRADLE_FILE}.bak"
        
        # Add namespace to the android block
        sed -i '/android {/a \    namespace "dev.isar.isar_flutter_libs"' "$ISAR_GRADLE_FILE"
        
        echo "Added namespace to isar_flutter_libs build.gradle file."
    fi
else
    echo "Error: Could not find isar_flutter_libs build.gradle file at $ISAR_GRADLE_FILE"
    exit 1
fi