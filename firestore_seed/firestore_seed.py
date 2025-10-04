import firebase_admin
from firebase_admin import credentials, firestore
import random
import argparse

cred = credentials.Certificate("nexa-80d73-firebase-adminsdk-fbsvc-88026975f0.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

def seed_data(n_samples: int = 10):
  products_ref = db.collection("products")

  CATEGORIES = {
    "Lavadoras": [
      {"name": "lavadora", "article": "una"},
      {"name": "secadora", "article": "una"}
    ],
    "Frigoríficos": [
      {"name": "frigorífico", "article": "un"},
      {"name": "nevera portátil", "article": "una"}
    ],
    "Hornos": [
      {"name": "horno", "article": "un"},
      {"name": "horno tostador", "article": "un"},
      {"name": "horno de convección", "article": "un"}
    ],
    "Pequeños Electrodomésticos": [
      {"name": "tostadora", "article": "una"},
      {"name": "cafetera", "article": "una"},
      {"name": "licuadora", "article": "una"},
      {"name": "batidora", "article": "una"},
      {"name": "exprimidor", "article": "un"},
      {"name": "sandwichera", "article": "una"}
    ],
    "Climatización": [
      {"name": "ventilador", "article": "un"},
      {"name": "aire acondicionado", "article": "un"},
      {"name": "purificador de aire", "article": "un"},
      {"name": "calentador eléctrico", "article": "un"}
    ],
    "Cocina": [
      {"name": "estufa eléctrica", "article": "una"},
      {"name": "cocina de inducción", "article": "una"},
      {"name": "robot de cocina", "article": "un"},
      {"name": "lavavajillas", "article": "un"}
    ]
  }

  ADJECTIVES = [
    ["bueno", "buena"],
    ["rápido", "rápida"],
    ["moderno", "moderna"],
    ["eficiente", "eficiente"],
    ["grande", "grande"],
    ["pequeño", "pequeña"],
    ["potente", "potente"],
    ["económico", "económica"],
    ["práctico", "práctica"],
    ["versátil", "versátil"]
  ]

  BRANDS = [
    "Electronix", "Fragor", "LG/TB", "A.C.M.E.", "NovaTech",
    "HomeWave", "Kinetix", "Froston", "Zaptron", "Maxellium",
    "ElectroNova", "QuickCool", "BrightHome", "TurboChef", "Voltix",
      "NexaHome", "PowerPlus", "OptiCook", "Airis", "Glacio"
  ]

  VERSION_MODIFIERS = ["Deluxe", "Prime", "Ultra", "Pro", "Max"]

  def getVersion():
    mode = random.randint(0, 3)
    if mode == 0:
      return str(random.randint(1, 9) * 1000)
    elif mode == 1:
      return f"{random.randint(1, 3)}.0"
    elif mode == 2:
      return random.choice(VERSION_MODIFIERS)
    else:
      return f"{random.choice(VERSION_MODIFIERS)} {random.randint(1,3)}.0"

  for _ in range(n_samples):
    category_name = random.choice(list(CATEGORIES.keys()))
    item = random.choice(CATEGORIES[category_name])
    name = item["name"]
    article = item["article"]

    adj1, adj2 = random.sample(ADJECTIVES, 2)
    adj1 = adj1[0] if article == "un" else adj1[1]
    adj2 = adj2[0] if article == "un" else adj2[1]

    product_data = {
      "name": f"{name} {getVersion()}",
      "category": category_name,
      "description": f"{article} {name} {adj1} y {adj2}",
      "price": round(random.uniform(0.5, 20000.0), 2),
      "stock": random.randint(1, 420),
      "brand": random.choice(BRANDS)
    }
    products_ref.document().set(product_data)
    print(f"Inserted product: {product_data['name']}")

if __name__ == "__main__":
  parser = argparse.ArgumentParser(
    description="Seed Firestore with random electronic products"
  )
  parser.add_argument(
    "n_products", type=int, help="Number of products to insert"
  )
  args = parser.parse_args()

  try:
    seed_data(args.n_products)
  except Exception as e:
    print(e)