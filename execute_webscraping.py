import os
import getpass
from ChromeDriver import ChromeDriver

# the following if statement 
if getpass.getuser()=="Tom Bearpark":
    file_folder = r"C:/Users/Tom Bearpark/Documents/Data_Task/tom_epic_task/raw_data"
    # copy the path after typing "which chromedriver" into your command-line
    chromedriver_path = r"C:/Users/Tom Bearpark/.anaconda/chromedriver" 
files = ["demographics.txt","house_age.txt","house_chars1.txt","house_chars2.txt","house_type.txt"]
data_url = "http://www.jasmiths.com/data_project"
driverObj = ChromeDriver(file_folder, chromedriver_path, files, data_url)
driverObj.get_data()
