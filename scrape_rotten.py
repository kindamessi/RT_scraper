#!/Library/Frameworks/Python.framework/Versions/3.8/bin/python3

##add something to pull the movie title

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

    #print(raw_user)
    #print(raw_date)
    
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
    # with open ("/tmp/reviews.txt","a") as o:
    #     for review in text_review:
    #         number = str(revnum)
    #         review = str(review)
    #         o.write("revNum ")
    #         o.write(number)
    #         o.write(review)
    #         #o.write(string_full)
    #         revnum = revnum + 1
    # with open ("/tmp/starFile.txt","a") as o:
    #     for star in starfinder:
    #         number = str(starnum)
    #         star = str(star)
    #         o.write(number)
    #         o.write(star)
    #         starnum = starnum + 1
    # with open ("/tmp/userFile.txt","a") as o:
    #     for user in raw_user:
    #         number = str(usernum)
    #         user = str(user)
    #         o.write(number)
    #         o.write(user)
    #         usernum = usernum + 1
    # with open ("/tmp/dateFile.txt","a") as o:
    #     for date in raw_date:
    #         number = str(datenum)
    #         date = str(date)
    #         o.write(number)
    #         o.write(date)
    #         datenum = datenum + 1


    next_buttons = driver.find_element(By.XPATH, "//button[@class='js-prev-next-paging-next btn prev-next-paging__button prev-next-paging__button-right']")
    next_buttons.click()
    test_str=str(next_buttons)
    time.sleep(1)
