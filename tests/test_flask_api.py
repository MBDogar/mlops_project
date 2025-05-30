import sys
import os
from unittest.mock import patch

# Add parent directory to path so `app` can be imported
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# Patch joblib.load before app import
with patch('app.joblib.load') as mock_load:
    class DummyModel:
        def predict(self, X):
            return [800.857]
    mock_load.return_value = DummyModel()
    from app import app

def test_flask_predict():
    with app.test_client() as client:
        app.testing = True
        response = client.post('/api/predict', json={"age": 30, "weight": 75})
        assert response.status_code == 200
        data = response.get_json()
        assert "prediction" in data
        assert data["prediction"] == 800.86
