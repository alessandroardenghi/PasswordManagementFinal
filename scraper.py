import json
from urllib.parse import urlparse
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import time

def load_selectors():
    with open('selectors.json', 'r') as file:
        return json.load(file)

def get_domain(url):
    return urlparse(url).netloc

def handle_login(browser, selectors, domain, username, password):
    # Handle pop-up if present
    popup_selector = selectors[domain].get('popup_selector')
    if popup_selector:
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, popup_selector))).click()

    # Fill in username and password
    WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, selectors[domain]['username_field'])))
    browser.find_element_by_xpath(selectors[domain]['username_field']).send_keys(username)
    browser.find_element_by_xpath(selectors[domain]['password_field']).send_keys(password)
    browser.find_element_by_xpath(selectors[domain]['login_button']).click()

def first_step(weblink, username, password, action=None):
    selectors = load_selectors()
    domain = get_domain(weblink)
    if domain not in selectors:
        return "Website not supported, you might have misspelled the website's link"

    browser = webdriver.Safari()
    try:
        browser.get(weblink)
        handle_login(browser, selectors, domain, username, password)
        
        if action == "change_password":
            change_password(browser)
        elif action == "delete_account":
            delete_account(browser)
        elif action == "delete_subscription":
            delete_subscription(browser)
            
        return "Action performed successfully: " + action

    except Exception as e:
        return f"Error during action {action}: {e}"

    finally:
        time.sleep(10)
        browser.quit()

def change_password(browser):
    # Implement the steps to change password
    pass

def delete_account(browser):
    # Implement the steps to delete the account
    pass

def delete_subscription(browser):
    # Implement the steps to delete the subscription
    pass

# callable function for the backend --> app.py
def callable_function(username, password, url, action):
    return first_step(url, username, password, action)
