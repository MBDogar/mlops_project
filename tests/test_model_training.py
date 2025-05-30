# tests/test_model.py

import sys
import os

# Add the parent directory to sys.path so model.py can be imported
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from model import load_data, train_model, evaluate_model

def test_accuracy():
    X_train, X_test, y_train, y_test = load_data()
    model = train_model(X_train, y_train)
    mse = evaluate_model(model, X_test, y_test)
    assert mse < 100
