Created By: Mike Lee
Created On: 2022-08-06
Description
	Open browser and play youtube video. Persist browser session until video ends.
	Modify PlayYoutubeVideo.py to set new video URL
	
Instructions:
	1. Download and install Python3
		https://www.python.org/downloads/
	2. If first time running, under Resources directory run InstallResources.bat
	3. Run RunPython.bat
	
Note:
	This program uses Google Chrome and ChromeDriver. The included chromedriver.exe 
	is for Chrome version 104. If chrome driver does not launch, download the correct
	version of chrome driver for your machine by:
		1. Open Chrome
		2. On the top right, click the 3 dots and navigate to Settings
		3. On the top left, click the 3 lines and navigate to About Chrome
		4. Check your installed version
			Ex. Version 104.0.5112.81 (Official Build) (64-bit)
		5. Navigate to https://sites.google.com/chromium.org/driver/downloads?authuser=0
		and click on the ChromeDriver hyperlink that applies to you
		6. Download the zip file for your operating system
		7. Copy and replace the chromedriver.exe from zip file into the Selenium directory