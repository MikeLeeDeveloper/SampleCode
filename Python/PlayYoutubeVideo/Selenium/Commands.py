import os
import time, datetime
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC

#Global Variables
localDirectory = os.getcwd()

def launchChrome(url):
	#Navigate to URL
	browser = webdriver.Chrome(localDirectory + "\Selenium\chromedriver.exe")
	#browser.maximize_window()
	browser.get(url)

	#Wait for play button to load, then click
	WebDriverWait(browser, 15).until(EC.element_to_be_clickable(
    (By.XPATH, "//button[@aria-label='Play']"))).click()

	#Get video length
	getDuration = browser.find_element(By.CLASS_NAME,"ytp-time-duration").text
	durationToTime = time.strptime(getDuration, '%M:%S')
	durationToSeconds = datetime.timedelta(minutes=durationToTime.tm_min, 
		seconds=durationToTime.tm_sec).total_seconds()

    #Persist browser until video ends
	time.sleep(durationToSeconds + 5)
	browser.quit()