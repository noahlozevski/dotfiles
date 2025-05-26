#!/bin/bash

# Define the base directory
WORKPLACE_DIR=~/workplace

# Iterate over each subdirectory in WORKPLACE_DIR
for dir in "$WORKPLACE_DIR"/*/ ; do
    # Check if it's a directory
    if [ -d "$dir" ]; then
        echo "Processing directory: $dir"
        
        # Change into the directory
        cd "$dir" || { echo "Failed to enter directory $dir"; continue; }

        # Check if the 'src' directory exists, and platformInfo file exists
        if [ ! -d "src" ]; then
            echo "'src' directory not found in $dir, skipping..."
            continue
        fi

        echo "cleaning brazil ws"
        brazil ws clean

        # Change into the 'src' directory
        cd src || { echo "Failed to enter src directory in $dir"; continue; }

        # Iterate over each subdirectory in 'src'
        for src_subdir in */ ; do
            # Check if it's a directory
            if [ -d "$src_subdir" ]; then
                echo "Processing src subdirectory: $src_subdir in $dir/src"

                # Remove the 'build' directory inside the src subdirectory
                rm -rf "$src_subdir/build/*"
                
                # Check if the 'rm' command was successful
                if [ $? -ne 0 ]; then
                    echo "Failed to remove build directory in $src_subdir, continuing..."
                    continue
                else
                    echo "Successfully removed build directory in $src_subdir"
                fi
            fi
        done

        # Go back to the original directory
        cd "$WORKPLACE_DIR" || { echo "Failed to return to $WORKPLACE_DIR"; exit 1; }
    fi
done

echo "Finished processing all directories."

