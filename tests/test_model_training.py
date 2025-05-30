import pytest
import pandas as pd
import os
from sklearn.linear_model import LinearRegression
from model import load_data, train_model, evaluate_model

# Fixture to create a dummy health_data.csv for testing
@pytest.fixture(scope='module')
def setup_data_file():
    data = {
        'age': [25, 30, 35, 40, 45],
        'weight': [60, 65, 70, 75, 80],
        'height': [160, 165, 170, 175, 180]
    }
    df = pd.DataFrame(data)
    df.to_csv('health_data.csv', index=False)
    yield
    os.remove('health_data.csv')

def test_load_data(setup_data_file):
    """Test if load_data loads the data correctly and splits it."""
    X_train, X_test, y_train, y_test = load_data()
    assert len(X_train) > 0
    assert len(X_test) > 0
    assert len(y_train) > 0
    assert len(y_test) > 0
    assert all(col in X_train.columns for col in ['age', 'weight'])
    assert isinstance(y_train, pd.Series)

def test_train_model(setup_data_file):
    """Test if the model trains and saves successfully."""
    X_train, _, y_train, _ = load_data()
    model = train_model(X_train, y_train, model_path='test_model.joblib')
    assert isinstance(model, LinearRegression)
    assert os.path.exists('test_model.joblib')
    loaded_model = joblib.load('test_model.joblib')
    assert isinstance(loaded_model, LinearRegression)
    os.remove('test_model.joblib') # Clean up the dummy model

def test_evaluate_model(setup_data_file):
    """Test if the model evaluation returns a valid MSE."""
    X_train, X_test, y_train, y_test = load_data()
    model = train_model(X_train, y_train, model_path='test_model_eval.joblib')
    mse = evaluate_model(model, X_test, y_test)
    assert isinstance(mse, float)
    assert mse >= 0 # Mean squared error should always be non-negative
    os.remove('test_model_eval.joblib') # Clean up the dummy model