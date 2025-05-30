from unittest.mock import patch
import pytest

@pytest.fixture(autouse=True)
def mock_model_load():
    with patch('app.joblib.load') as mock_load:
        class DummyModel:
            def predict(self, X):
                return [800.857]
        mock_load.return_value = DummyModel()
        yield

from app import app

def test_api():
    client = app.test_client()
    response = client.post('/predict', data={'age': 25, 'weight': 70})
    assert response.status_code == 200
    assert b"800.86" in response.data  # check if prediction rendered in response
