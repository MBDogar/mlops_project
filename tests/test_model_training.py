# tests/test_flask_api.py

import requests
import json

def test_predict_api():
    url = "http://10.106.32.20:5000/predict"  # or your IP/port
    payload = {
        "age": 30,
        "weight": 75
    }
    headers = {
        "Content-Type": "application/json"
    }

    response = requests.post(url, data=json.dumps(payload), headers=headers)

    # Make sure API returns 200
    assert response.status_code == 200

    # Make sure response contains a prediction
    data = response.json()
    assert "prediction" in data
    assert isinstance(data["prediction"], (int, float))
