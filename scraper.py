import json
import os
import time
import logging
from urllib.parse import urlparse
from selenium import webdriver
from selenium.webdriver.safari.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException

logging.basicConfig(level=logging.INFO)

def load_selectors():
    try:
        with open('selectors.json', 'r') as file:
            return json.load(file)
    except Exception as e:
        logging.error(f"Error loading selectors: {e}")
        raise

def get_domain(url):
    normalized_url = url.replace('http://', '').replace('https://', '').replace('www.', '').rstrip('/')
    domain = normalized_url.split('/')[0].lower()
    return domain

# function for app.py
def callable_function(username, password, url, action):
    return first_step(url, username, password, action)

# pop ups are browser specific (or could be iframes), so it was too difficult to automatically take care of them
# def handle_pop_up(browser, popup_selector):
#     try:
#         WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, popup_selector))).click()
#         logging.info("Pop-up handled successfully")
#     except Exception as e:
#         logging.warning(f"No pop-up to handle or error handling pop-up: {e}")

# instead we ask the user to take care of them
def show_notification(browser, message, display_time=4):
    script = f"""
    var banner = document.createElement("div");
    banner.innerText = "{message}";
    banner.style.position = "fixed";
    banner.style.top = "10px";
    banner.style.left = "50%";
    banner.style.transform = "translateX(-50%)";
    banner.style.backgroundColor = "lightblue";
    banner.style.padding = "10px";
    banner.style.zIndex = "1000";
    banner.style.border = "1px solid black";
    document.body.appendChild(banner);
    setTimeout(function() {{ banner.remove(); }}, {display_time * 1000});
    """
    browser.execute_script(script)

def handle_login(browser, selectors, domain, username, password):
    try:
        # handle pop ups if necessary
        # popup_selector = selectors[domain].get('popup_selector')
        # if popup_selector:
        #    handle_pop_up(browser, popup_selector)

        # insert credentials
        WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, selectors[domain]['username_field']))).send_keys(username)
        WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, selectors[domain]['password_field']))).send_keys(password)
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, selectors[domain]['login_button']))).click()

        logging.info("Login successful")
    except Exception as e:
        logging.error(f"Error handling login for {domain}: {e}")
        raise

def get_second_level_domain(url):
    parsed_url = urlparse(url)
    domain_parts = parsed_url.netloc.split('.')
    # Get the last two parts of the domain (SLD and TLD)
    sld = '.'.join(domain_parts[-2:])
    return sld

def first_step(weblink, username, old_password, new_password, action):
    selectors = load_selectors()
    sld = get_second_level_domain(weblink)
    domain_key = next((key for key in selectors if sld in key), None)
    
    if domain_key is None:
        return "Website not supported, check the URL or the domain key in selectors."

    safari_options = Options()

    try:
        browser = webdriver.Safari(options=safari_options)
        browser.get(weblink)
        handle_login(browser, selectors[domain_key], domain_key, username, old_password)  # Use domain_key

        show_notification(browser, "Please accept/decline any cookies", 4)

        if action == "change_password":
            return change_password(browser, domain_key, username, old_password, new_password)  # Use domain_key
        elif action == "delete_account":
            # Implement delete_account logic
            pass
        elif action == "delete_subscription":
            # Implement delete_subscription logic
            pass
        else:
            return "Action not recognized"
    except Exception as e:
        return f"Error during action {action}: {e}"
    finally:
        browser.quit()

def change_password(browser, domain_key, username, old_password, new_password):
    selectors = load_selectors()
    
    if domain_key in selectors:
        domain_selectors = selectors[domain_key]

        try:
            # Use domain_selectors instead of selectors[domain]
            WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['save_info_button']))).click()
        except TimeoutException:
            pass
        
        try:
            WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['notification_button']))).click()
        except TimeoutException:
            pass

        # Continue using domain_selectors for the rest of the function
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['account_button']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['setting_button']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['setting_and_privacy']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['box_to_click']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['account_center']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['privacy_and_security']))).click()
        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['change_password_button']))).click()
        
        WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, domain_selectors['current_password']))).send_keys(old_password)
        WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, domain_selectors['new_password']))).send_keys(new_password)
        WebDriverWait(browser, 5).until(EC.presence_of_element_located((By.XPATH, domain_selectors['repeat_new_password']))).send_keys(new_password)

        WebDriverWait(browser, 5).until(EC.element_to_be_clickable((By.XPATH, domain_selectors['save_button']))).click()
        
        return "Password change process completed"
    else:
        return "Domain not supported or not found in selectors"
    
def delete_account(browser, domain, username, password):
    
    selectors = load_selectors()
    handle_login(browser, selectors, domain, username, password)
    
    #if domain == 'instagram.com':
        
    #elif domain == 'twitter.com':
    
    #elif domain == 'github.com':
    
    #elif domain == 'facebook.com':
    
    return "Delete account functionality not implemented yet"

def delete_subscription(browser, domain, username, password):
    
    selectors = load_selectors()
    handle_login(browser, selectors, domain, username, password)
    
    #if domain == 'instagram.com':
        
    #elif domain == 'twitter.com':
    
    #elif domain == 'github.com':
    
    #elif domain == 'facebook.com':
    
    return "Delete subscription functionality not implemented yet"
