from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
import pandas as pd
import joblib

def load_data(path='health_data.csv'):
    df = pd.read_csv(path)
    X = df[['age', 'weight']]
    y = df['height']
    return train_test_split(X, y, test_size=0.2, random_state=42)

def train_model(X_train, y_train, model_path='model.joblib'):
    model = LinearRegression()
    model.fit(X_train, y_train)
    joblib.dump(model, model_path)
    return model

def evaluate_model(model, X_test, y_test):
    predictions = model.predict(X_test)
    return mean_squared_error(y_test, predictions)
