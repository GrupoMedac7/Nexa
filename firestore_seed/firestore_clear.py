import firebase_admin
from firebase_admin import credentials, firestore

if __name__ == "__main__":
  cred = credentials.Certificate("nexa-80d73-firebase-adminsdk-fbsvc-88026975f0.json")
  firebase_admin.initialize_app(cred)
  db = firestore.client()
  products_ref = db.collection("products")

  products = products_ref.stream()
  for product in products:
    product.reference.delete()