# rm -rf /usr/local/amazon/var/acme/cache/
rm -rfv $HOME/Library/Application\ Support/Slack/logs/
rm -rfv $HOME/.gradle/caches/
rm -rfv ~/Library/Developer/Xcode/DerivedData/*
rm -rfv ~/Library/Developer/CoreSimulator/Caches/*
rm -rfv $HOME/Library/Messages/Caches/*
npm cache clean --force --verbose
# this cleans remote / private packages for some reason?
brew cleanup --prune=all --verbose
brazil-package-cache stop
echo -n "Cleaning pkg cache ..." && brazil-package-cache clean --debug --days 0 --keepCacheHours 0 --percent 0 2>/dev/null
# rm -frv /local/home/${USER}/brazil-pkg-cache/s3BinaryFiles/*
echo -n "Cleaning toolbox ..." && toolbox clean 2>&1

# delete things from the ~/Library directory if over a size
# MB
threshold_size=2500

# Path where to search directories. Change this to the path where you want to search.
search_path="$HOME/Library/Caches"

# Find directories larger than the specified threshold and delete them
find "$search_path" -type d -mindepth 1 -maxdepth 1 -exec du -sm {} + | while read size path; do
    if [ "$size" -gt $threshold_size ]; then
        echo "Deleting directory $path which is $size MB"
        rm -rf "$path"
    fi
done

