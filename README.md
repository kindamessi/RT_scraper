# RT_scraper

This script will scrape reviews from Rotten Tomatoes.  Use it if you want a formatted CSV of review content, ratings, user, and number of written reviews on a certain piece of media in Rotten Tomatoes.

The elements in the BASH will work out of the box on a Mac.  You might need to install BSD versions of grep/awk/sed (or you can modify switches on those binaries) to make it work on a Linux distribution.

## Prereqs
You'll need to do a bit of manual config to make this work properly.

- Google Chrome: https://www.google.com/chrome/dr/download/
- chromedriver (For you specific version of Chrome): https://chromedriver.chromium.org/downloads


In Terminal:
```sh
sudo mv ~/Downloads/chromedriver /usr/local/bin/
```

Then, in Terminal open /usr/local/bin/ and right-click on chromedriver, and click "Allow"
```sh
open /usr/local/bin/
```

python3 and pip3 (probably doesn't need to be 3.8): https://www.python.org/downloads/release/python-380/





