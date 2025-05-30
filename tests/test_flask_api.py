import os
import joblib

app = Flask(__name__)

try:
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    model_path = os.path.join(BASE_DIR, 'model.joblib')
    model = joblib.load(model_path)
except FileNotFoundError:
    model = None  # or raise an informative warning if preferred
