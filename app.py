from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
import os
import scraper
from scraper import first_step

app = Flask(__name__)
CORS(app)
logging.basicConfig(level=logging.INFO)

@app.route('/run-script', methods=['POST'])
@app.route('/change_password', methods=['POST'])
def change_password_route():
    print("Change password route called.")
    data = request.json
    print(f"Received data: {data}")

    username = data.get('username')
    oldPassword = data.get('oldPassword')
    newPassword = data.get('password')
    url = data.get('url')

    missing_parameters = []
    for param in ['username', 'oldPassword', 'password', 'url']:
        if param not in data or not data[param]:
            missing_parameters.append(param)
    print(f"Missing parameters: {missing_parameters}")

    if missing_parameters:
        return jsonify({'status': 'error', 'message': f'Missing required parameters: {missing_parameters}'}), 400

    try:
        print(f"Calling first_step with URL: {url}")
        result = first_step(url, username, oldPassword, newPassword, 'change_password')
        print(f"Result from first_step: {result}")
        return jsonify({'status': 'success', 'result': result})
    except Exception as e:
        logging.error(f"Error in change_password_route: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/delete_account', methods=['POST'])
def delete_account_route():
    data = request.json
    username = data.get('username')
    password = data.get('password')
    new_password = data.get('new_password')
    url = data.get('url')
    result = scraper.delete_account(url, username, password, new_password)
    return jsonify({'result': result})

@app.route('/delete_subscription', methods=['POST'])
def delete_subscription_route():
    data = request.json
    username = data.get('username')
    password = data.get('password')
    new_password = data.get('new_password')
    url = data.get('url')
    result = scraper.delete_subscription(url, username, password, new_password)
    return jsonify({'result': result})

def run_script():
    print("Run script route called.")
    if not request.is_json:
        print("No JSON in request.")
        logging.error("Missing JSON in request")
        return jsonify({"status": "error", "message": "Missing JSON in request"}), 400
    
    data = request.get_json(force=True)
    print(f"Data from JSON request: {data}")
    required_fields = ['username', 'password', 'oldPassword', 'url', 'action']
    
    if not all(field in data for field in required_fields):
        print("Missing required data fields.")
        logging.error("Missing required data fields")
        return jsonify({"status": "error", "message": "Missing required data fields"}), 400
    
    try:
        print(f"Calling callable_function with data: {data}")
        result = scraper.callable_function(data['username'], data['password'], data['oldPassword'], data['url'], data['action'])
        print(f"Result from callable_function: {result}")
        return jsonify({"status": "success", "message": result}), 200
    except Exception as e:
        print(f"Error caught in run_script: {str(e)}")
        logging.error(f"Error in run_script: {str(e)}")
        return jsonify({"status": "error", "message": str(e)}), 500
    
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=True, port=port)
