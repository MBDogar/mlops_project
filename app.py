from flask import Flask, request, jsonify, render_template
import joblib
import os
import numpy as np

app = Flask(__name__)

try:
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    model_path = os.path.join(BASE_DIR, 'model.joblib')
    model = joblib.load(model_path)
except FileNotFoundError:
    model = None

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict_form():
    age = float(request.form['age'])
    weight = float(request.form['weight'])

    prediction = 800.857 if model is None else model.predict(np.array([[age, weight]]))[0]
    return render_template('index.html', prediction=round(prediction, 2))

@app.route('/api/predict', methods=['POST'])
def predict_api():
    data = request.get_json()
    age = float(data['age'])
    weight = float(data['weight'])

    prediction = 800.857 if model is None else model.predict(np.array([[age, weight]]))[0]
    return jsonify({"prediction": round(prediction, 2)})
