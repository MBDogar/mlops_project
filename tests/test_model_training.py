import joblib
import numpy as np

def test_model_prediction():
    # Load your trained model
    model = joblib.load('model.joblib')

    # Prepare example input data (age, weight)
    X_test = np.array([[30, 70]])

    # Run prediction
    prediction = model.predict(X_test)[0]

    # Example assertion, adjust threshold based on your expected output
    assert prediction < 1000  # or some other condition that makes sense for your model
