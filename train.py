from model import load_data, train_model, evaluate_model
X_train, X_test, y_train, y_test = load_data()
model = train_model(X_train, y_train)
mse = evaluate_model(model, X_test, y_test)
print(f"Model trained. MSE: {mse:.2f}")
