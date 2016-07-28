from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.support.ui import WebDriverWait # available since 2.4.0
from selenium.webdriver.support import expected_conditions as EC # available since 2.26.0

driver = webdriver.Remote(command_executor='http://selenium:4444/wd/hub',
   desired_capabilities=DesiredCapabilities.CHROME)

driver.get("http://nginx/login")
try:
    WebDriverWait(driver, 120).until(EC.title_contains("MyTardis"))

    print driver.title
    assert "MyTardis" in driver.title

    elem = driver.find_element_by_id("id_username")
    elem = driver.find_element_by_id("id_password")
finally:
    driver.quit()

