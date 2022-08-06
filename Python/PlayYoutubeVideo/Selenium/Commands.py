import os
import time, datetime
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as Ec

#Global Variables
currentDirectory = os.getcwd()

def launchChrome(url):
	#Navigate to URL
	browser = webdriver.Chrome(currentDirectory + "\Selenium\chromedriver.exe")
	#browser.maximize_window()
	browser.get(url)

	#Wait for play button to load, then click
	WebDriverWait(browser, 15).until(Ec.element_to_be_clickable(
    (By.XPATH, "//button[@aria-label='Play']"))).click()

	#Get video length
	durationToTime = time.strptime(browser.find_element(
		By.CLASS_NAME,"ytp-time-duration").text, '%M:%S')
	videoLength = datetime.timedelta(minutes=durationToTime.tm_min, 
		seconds=durationToTime.tm_sec).total_seconds()

    #Persist browser until video ends
	time.sleep(videoLength + 5)
	browser.quit()