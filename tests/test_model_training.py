# tests/test_flask_api.py

import pytest
from app import app  # adjust import to your Flask app module

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_predict(client):
    # Prepare form data
    form_data = {
        'age': '30',
        'weight': '70'
    }

    # POST to /predict with form data
    response = client.post('/predict', data=form_data)

    # Assert the response is successful
    assert response.status_code == 200

    # Assert the response HTML contains the predicted value (rounded)
    assert b'800.86' in response.data  # bytes literal since response.data is bytes
