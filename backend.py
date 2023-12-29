from flask import Flask, request, jsonify
import scraper 

app = Flask(__name__)

@app.route('/run-script', methods=['POST'])
def run_script():
    data = request.json
    try:
        # Call the callable_function from scraper.py
        result = scraper.callable_function(data['username'], data['password'], data['url'], data['action'])
        return jsonify({"status": "success", "message": result}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
