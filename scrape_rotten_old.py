#!/Library/Frameworks/Python.framework/Versions/3.8/bin/python3

####################################################################
## Script will pull review content from Rotten Tomatoes           ##
## Raw content will be placed into a folder you name in /tmp      ##
## Script runs in tandem with a BASH script included in repo      ##
##                                                                ##
## Text/regex could definitely have been done with Python         ##
## Please write that in, if you want.  Will probably be more      ##
## efficient than the BASH                                        ##
##                                                                ##
## Nick Plank                                                     ##
## St. Norbert College                                            ##
## 11/7/2022                                                      ##
####################################################################


from bs4 import BeautifulSoup
from selenium import webdriver
import time
from selenium.webdriver.common.by import By
import os
import os.path

revnum = 1
starnum = 1
usernum = 1
datenum = 1

movieURL = input('URL of reviews: ')
movieName = input('Name of movie: ')

options = webdriver.ChromeOptions()
options.add_argument('--ignore-certificate-errors')
options.add_argument("--test-type")
#options.binary_location = "/usr/bin/chromium"
driver = webdriver.Chrome(chrome_options=options)
#driver = webdriver.Chrome()



url = str(movieURL)
movie = str(movieName)
driver.get(url)

next_buttons = driver.find_element(By.XPATH, "//button[@class='js-prev-next-paging-next btn prev-next-paging__button prev-next-paging__button-right']")
test_str = str(next_buttons)
tester = 'selenium.webdriver.remote.webelement.WebElement'
stuff = 1

revDir = os.path.join ('/tmp', movie)
revFile = os.path.join('/tmp', movie, 'reviews.txt')
rateFile = os.path.join('/tmp', movie, 'starFile.txt')
usersFile = os.path.join('/tmp', movie, 'userFile.txt')
datesFile = os.path.join('/tmp', movie, 'dateFile.txt')

os.mkdir(revDir)

while tester in test_str:
    html =  BeautifulSoup(driver.page_source, "html.parser")
    text_review = html.find_all("p",{"class":"audience-reviews__review js-review-text clamp clamp-8 js-clamp"})
    starfinder = html.find_all("span",{"class":"star-display"})
    raw_user = html.find_all("div", {"class": "audience-reviews__user-wrap"})
    raw_date = html.find_all("span",{"class":"audience-reviews__duration"})

    
#pull date of review
    with open (revFile,"a") as o:
        for review in text_review:
            number = str(revnum)
            review = str(review)
            o.write("revNum ")
            o.write(number)
            o.write(review)
            revnum = revnum + 1
    with open (rateFile,"a") as o:
        for star in starfinder:
            number = str(starnum)
            star = str(star)
            o.write(number)
            o.write(star)
            starnum = starnum + 1
    with open (usersFile,"a") as o:
        for user in raw_user:
            number = str(usernum)
            user = str(user)
            o.write(number)
            o.write(user)
            usernum = usernum + 1
    with open (datesFile,"a") as o:
        for date in raw_date:
            number = str(datenum)
            date = str(date)
            o.write(number)
            o.write(date)
            datenum = datenum + 1

    next_buttons = driver.find_element(By.XPATH, "//button[@class='js-prev-next-paging-next btn prev-next-paging__button prev-next-paging__button-right']")
    next_buttons.click()
    test_str=str(next_buttons)

    ## if you notice the script doesn't let the Rotten Tomatoes page load, you might need to make it sleep longer.
    time.sleep(1)
