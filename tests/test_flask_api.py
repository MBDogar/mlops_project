import pytest
from your_flask_app import app  # import your Flask app object

def test_api():
    client = app.test_client()
    response = client.post('/predict', data={'age': 25, 'weight': 70})
    assert response.status_code == 200