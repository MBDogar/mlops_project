import os
import joblib
import numpy as np

def test_model_prediction():
    model_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'model.joblib'))

    assert os.path.exists(model_path), f"❌ model.joblib not found at: {model_path}. Did you forget to run model.py?"

    model = joblib.load(model_path)

    X_test = np.array([[30, 70]])
    prediction = model.predict(X_test)[0]

    assert prediction < 1000
