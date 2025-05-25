import requests

def test_api():
    res = requests.post('http://localhost:5000/predict', data={'age': 25, 'weight': 70})
    assert res.status_code == 200
