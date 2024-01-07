from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
import os
import scraper
from scraper import handle_login

app = Flask(__name__)
CORS(app)
logging.basicConfig(level=logging.INFO)

# as the swift code has been changed after the development of this code,
# the variables oldPassword and newPassword do not reflect entirely the data that should be used
# a temporary/secondary variable would be used to store the password before a new one would be
# generated. then both variables would be passed to the scraper.change_password() function
@app.route('/change_password', methods=['POST'])
def change_password_route():
    data = request.json
    username = data.get('username')
    oldPassword = data.get('oldPassword')
    # the new password would have been the one created by the generator
    # following the user's preferences in length and special characters
    newPassword = data.get('password')
    url = data.get('url')
    
    # check for missing parameters and why the request doesn't work
    missing_parameters = []
    for param in ['username', 'oldPassword', 'newPassword', 'url']:
        if param not in data or not data[param]:
            missing_parameters.append(param)
    if missing_parameters:
        return jsonify({'status': 'error', 'message': f'Missing required parameters: {missing_parameters}'}), 400

    try:
        # Call the function to change password
        new_password = scraper.change_password(url, username, oldPassword, newPassword)
        return jsonify({'status': 'success', 'newPassword': new_password})
    except Exception as e:
        logging.error(f"Error in change_password_route: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

# similar implementation would have been used for these actions
# the functions called would have been scraper.delete_account() and scraper.delete_subscription()
@app.route('/delete_account', methods=['POST'])
def delete_account_route():
    pass
@app.route('/delete_subscription', methods=['POST'])
def delete_subscription_route():
    pass

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=True, port=port)
