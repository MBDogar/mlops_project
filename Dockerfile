FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY . .

RUN python3 train.py
CMD ["python3", "app.py"]