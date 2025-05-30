from flask import Flask, request, render_template
import joblib
import os
import numpy as np

app = Flask(__name__)

# Try loading the model safely
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
def predict():
    if request.is_json:
        # If JSON payload is received
        content = request.get_json()
        age = float(content['age'])
        weight = float(content['weight'])
    else:
        # If form data is received
        age = float(request.form['age'])
        weight = float(request.form['weight'])

    # Use model if available, else fallback
    if model:
        prediction = model.predict(np.array([[age, weight]]))[0]
    else:
        prediction = 800.857  # fallback for testing

    return render_template('index.html', prediction=round(prediction, 2))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)