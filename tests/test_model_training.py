# tests/test_flask_api.py
import json
import sys
import os

# Add the parent directory of 'tests' to the path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import app  # Now this should work



def test_predict_route():
    with app.test_client() as client:
        payload = {
            "age": 30,
            "weight": 75
        }
        response = client.post('/predict', data=json.dumps(payload), content_type='application/json')
        
        assert response.status_code == 200
        data = response.get_json()
        assert "prediction" in data
        assert isinstance(data["prediction"], (float, int))