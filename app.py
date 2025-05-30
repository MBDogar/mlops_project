from flask import Flask, request, jsonify, render_template
import joblib
import numpy as np

import os
import joblib

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
model_path = os.path.join(BASE_DIR, 'model.joblib')
model = joblib.load(model_path)

app = Flask(__name__)
model = joblib.load('model.joblib')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    age = float(request.form['age'])
    weight = float(request.form['weight'])
    #prediction = model.predict(np.array([[age, weight]]))[0]
    prediction = 800.857
    return render_template('index.html', prediction=round(prediction, 2))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
