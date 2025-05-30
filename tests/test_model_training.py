import os
import sys
import joblib
import json

# Ensure app and model modules are accessible
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from model import load_data, train_model
from app import app

def test_model_training():
    X_train, X_test, y_train, y_test = load_data()
    model = train_model(X_train, y_train, model_path='model.joblib')
    assert os.path.exists('model.joblib'), "❌ model.joblib was not created"

def test_flask_predict():
    with app.test_client() as client:
        # Trigger model lazy load
        app.testing = True
        response = client.post('/predict', json={"age": 30, "weight": 75})
        assert response.status_code == 200
        data = response.get_json()
        assert "prediction" in data
