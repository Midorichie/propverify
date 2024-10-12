from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/properties', methods=['GET'])
def get_properties():
    # Placeholder for fetching properties from the blockchain
    return jsonify({"message": "Property listing endpoint"})