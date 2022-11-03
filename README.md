# RT_scraper

This script will scrape reviews from Rotten Tomatoes.  Use it if you want a formatted CSV of review content, ratings, user, and number of written reviews on a certain piece of media in Rotten Tomatoes.

The elements in the BASH will work out of the box on a Mac.  You might need to install BSD versions of grep/awk/sed (or you can modify switches on those binaries) to make it work on a Linux distribution.

## Prereqs
You'll need to do a bit of manual config to make this work properly.

- Google Chrome: https://www.google.com/chrome/dr/download/
- chromedriver: https://chromedriver.chromium.org/downloads
    - For your specific version of Chrome
    - To find your version of Chrome run this command in Terminal
```sh
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --version | awk '{ print $3 }'
``` 
- python3 and pip3 (probably doesn't need to be 3.8): https://www.python.org/ftp/python/3.8.0/python-3.8.0-macosx10.9.pkg
    - Run the package after it's downloaded.

### Necessary manual configuration items

To make chromedriver work appropriately, we'll need to move it to the proper location.  
You might need to do this whenever Google Chrome updates
```sh
sudo mv ~/Downloads/chromedriver /usr/local/bin/
sudo export PATH="/usr/local/bin/chromedriver:$PATH"
```

Then, in Terminal run the following command and right-click on chromedriver, and click "Allow"
```sh
open /usr/local/bin/
```

### Validate pip, and install python dependencies

```sh
python3 -m ensurepip --upgrade

pip install bs4
pip install selenium
```





