import sys
import os
from unittest.mock import patch

# Add parent dir to path so 'app' can be imported
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# Mock model loading before import
with patch('app.joblib.load') as mock_load:
    mock_load.return_value = None
    from app import app

def test_api():
    client = app.test_client()
    response = client.post('/predict', data={'age': 25, 'weight': 70})
    assert response.status_code == 200
