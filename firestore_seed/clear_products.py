import firebase_admin
from firebase_admin import credentials, firestore

# Path to your service account JSON file
SERVICE_ACCOUNT_PATH = "nexa-80d73-firebase-adminsdk-fbsvc-10f6fd5b9d.json"

# Initialize Firebase Admin SDK
cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
firebase_admin.initialize_app(cred)

db = firestore.client()

# Reference to the 'products' collection
products_ref = db.collection('products')

# Get all documents
docs = products_ref.stream()

# Delete each document
for doc in docs:
    print(f"Deleting document {doc.id}")
    doc.reference.delete()

print("All documents in 'products' collection have been deleted.")
