import sys
import os
from unittest.mock import patch

# Add parent directory to path so `app` can be imported
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# Patch model loading before importing app
with patch('app.joblib.load') as mock_load:
    class DummyModel:
        def predict(self, X):
            return [800.857]
    mock_load.return_value = DummyModel()
    from app import app

def test_api():
    client = app.test_client()
    response = client.post('/predict', data={"age": 25, "weight": 70})
    assert response.status_code == 200
    assert b"800.86" in response.data  # optional: check if prediction is in HTML
