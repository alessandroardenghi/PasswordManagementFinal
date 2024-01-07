import json
import logging
import string
import random
from urllib.parse import urlparse
from selenium import webdriver
from selenium.webdriver.safari.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException

logging.basicConfig(level=logging.INFO)

# load the webpages with their respective data from the json file
# for simplicity during the development, only instagram.com was left
def load_selectors():
    try:
        with open('selectors.json', 'r') as file:
            return json.load(file)
    except Exception as e:
        logging.error(f"Error loading selectors: {e}")
        raise

# from whatever url, only the domain would be left, i.e. "instagram.com"
def get_domain(url):
    normalized_url = url.replace('http://', '').replace('https://', '').replace('www.', '').rstrip('/')
    domain = normalized_url.split('/')[0].lower()
    return domain

# pop ups are browser specific (or could be iframes), so it was too difficult to automatically take care of them
# def handle_pop_up(browser, popup_selector):
#     try:
#         WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, popup_selector))).click()
#         logging.info("Pop-up handled successfully")
#     except Exception as e:
#         logging.warning(f"No pop-up to handle or error handling pop-up: {e}")

def handle_login(browser, selectors, domain, username, password):
    try:
        # this was deprecated, but if it worked, cookies would have been handled automatically
        # then, the bot would have filled in the username and password fields wuth the user's data from the app
        # popup_selector = selectors[domain].get('popup_selector')
        # if popup_selector:
        #    handle_pop_up(browser, popup_selector)

        WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, selectors[domain]['username_field']))).send_keys(username)
        WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, selectors[domain]['password_field']))).send_keys(password)
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, selectors[domain]['login_button']))).click()
        logging.info("Login successful")
    
    except Exception as e:
        logging.error(f"Error handling login for {domain}: {e}")
        raise

def get_base_domain(url):
    parsed_url = urlparse(url)
    domain_parts = parsed_url.netloc.split('.')
    base_domain = domain_parts[-2] if len(domain_parts) >= 2 else domain_parts[0]
    print("domain parts:", domain_parts)
    print("base domain:", base_domain)
    return base_domain

def change_password(browser, domain_key, username, oldPassword, password):
    selectors = load_selectors()
    base_domain = get_base_domain(browser)
    domain_key = selectors.get(base_domain)

    if domain_key is None:
        return "Website not supported, check the URL or the domain key in selectors."

    safari_options = Options()

    try:
        browser = webdriver.Safari(options=safari_options)
        browser.get(browser)
        handle_login(browser, selectors[domain_key], domain_key, username, oldPassword)  
    except Exception as e:
        return f"Error during action {change_password}: {e}"
    
    if domain_key in selectors:
        domain_selectors = selectors[domain_key]

        try:
            WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['save_info_button']))).click()
        except TimeoutException:
            pass
        
        try:
            WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['notification_button']))).click()
        except TimeoutException:
            pass
        
        # navigate all throught the website pages until you land on the "change password" view
        # the XPATH is the most secure way to land on the exact page, however it may be outdated quite fast
        # the new release would use CSS selectors instead of the XPATH in order to be more "flexible"
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['account_button']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['setting_button']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['setting_and_privacy']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['box_to_click']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['account_center']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['privacy_and_security']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['change_password_button']))).click()
        
        # the bot autofills the old password field and then inserts the new generated password in "Create new password" and "Repeat new password" fields
        WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, domain_selectors['current_password']))).send_keys(oldPassword)
        WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, domain_selectors['new_password']))).send_keys(password)
        WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, domain_selectors['repeat_new_password']))).send_keys(password)

        # the bot clicks on the "Save" button and then the browser closes
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['save_button']))).click()        
        return "Password change process completed"
    else:
        return "Domain not supported or not found in selectors"
    browser.quit()
    
def delete_account(browser, domain, username, password):
    return "Delete account functionality not implemented yet"
def delete_subscription(browser, domain, username, password):
    return "Delete subscription functionality not implemented yet"
