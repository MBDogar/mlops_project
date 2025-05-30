import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import app

def test_api():
    client = app.test_client()
    response = client.post('/predict', data={'age': 25, 'weight': 70})
    assert response.status_code == 200
