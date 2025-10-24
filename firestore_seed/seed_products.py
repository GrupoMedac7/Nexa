import firebase_admin
from firebase_admin import credentials, firestore
import argparse
from templates import getRandomProduct

# Path to your service account JSON file
SERVICE_ACCOUNT_PATH = "nexa-80d73-firebase-adminsdk-fbsvc-10f6fd5b9d.json"

# Initialize Firebase Admin SDK
cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
firebase_admin.initialize_app(cred)

db = firestore.client()

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("n_products", help="number of products to create")
  args = parser.parse_args()

  products: list[dict[str, any]] = []
  for _ in range(int(args.n_products)):
     products.append(getRandomProduct())

  # Add each product to Firestore
  for product in products:
      doc_ref = db.collection("products").add(product)
      print(f"Created product '{product['name']}' with ID: {doc_ref[1].id}")

  print("All products created successfully!")