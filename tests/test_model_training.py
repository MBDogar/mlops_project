# tests/test_flask_api.py
import json
from app import app  # Import your Flask app

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