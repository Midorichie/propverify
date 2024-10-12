from flask import Flask, jsonify, request
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)

STACKS_API_URL = "https://stacks-node-api.testnet.stacks.co/v2/contracts/call-read"

def call_contract_function(contract_address, contract_name, function_name, function_args):
    payload = {
        "contract_address": contract_address,
        "contract_name": contract_name,
        "function_name": function_name,
        "function_args": function_args
    }
    response = requests.post(STACKS_API_URL, json=payload)
    return response.json()

@app.route('/properties', methods=['GET'])
def get_properties():
    total_properties = call_contract_function(
        "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
        "property-registry",
        "get-total-properties",
        []
    )
    
    properties = []
    for i in range(int(total_properties['result'])):
        property_data = call_contract_function(
            "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
            "property-registry",
            "get-property",
            [f"u{i}"]
        )
        if property_data['result']:
            properties.append({
                "id": i,
                "owner": property_data['result']['owner'],
                "status": property_data['result']['status'],
                "price": int(property_data['result']['price']),
                "description": property_data['result']['description']
            })
    
    return jsonify(properties)

@app.route('/property/<int:property_id>', methods=['GET'])
def get_property(property_id):
    property_data = call_contract_function(
        "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
        "property-registry",
        "get-property",
        [f"u{property_id}"]
    )
    
    if property_data['result']:
        return jsonify({
            "id": property_id,
            "owner": property_data['result']['owner'],
            "status": property_data['result']['status'],
            "price": int(property_data['result']['price']),
            "description": property_data['result']['description']
        })
    else:
        return jsonify({"error": "Property not found"}), 404

if __name__ == '__main__':
    app.run(debug=True)