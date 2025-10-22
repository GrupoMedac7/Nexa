from dataclasses import dataclass
import random

@dataclass
class CategorySettings:
  n_img: int
  gen: str
  cat_name: str
  pl: str

CATEGORIES: dict[str, CategorySettings] = {
  'aspiradora':      CategorySettings(n_img=2, gen='f', cat_name='Aspiradora',      pl='Aspiradoras'),
  'batidora':        CategorySettings(n_img=2, gen='f', cat_name='Batidora',        pl='Batidoras'),
  'cafetera':        CategorySettings(n_img=2, gen='f', cat_name='Cafetera',        pl='Cafeteras'),
  'frigorífico':     CategorySettings(n_img=1, gen='m', cat_name='Frigorifico',     pl='Frigoríficos'),
  'horno':           CategorySettings(n_img=1, gen='m', cat_name='Horno',           pl='Hornos'),
  'lavadora':        CategorySettings(n_img=1, gen='f', cat_name='Lavadora',        pl='Lavadoras'),
  'microondas':      CategorySettings(n_img=1, gen='m', cat_name='Microondas',      pl='Microondas'),
  'plancha':         CategorySettings(n_img=1, gen='f', cat_name='Plancha',         pl='Planchas'),
  'robot de cocina': CategorySettings(n_img=1, gen='m', cat_name='RobotCocina',     pl='Robots de cocina'),
  'secador':         CategorySettings(n_img=1, gen='m', cat_name='Secador',         pl='Secadores'),
  'televisión':      CategorySettings(n_img=1, gen='f', cat_name='Television',      pl='Televisiones'),
  'tostadora':       CategorySettings(n_img=1, gen='f', cat_name='Tostadora',       pl='Tostadoras'),
  'ventilador':      CategorySettings(n_img=1, gen='m', cat_name='Ventilador',      pl='Ventiladores'),
}

ADJECTIVES: list[dict[str, str]] = [
    {'m': 'bueno',        'f': 'buena'},
    {'m': 'fiable',       'f': 'fiable'},
    {'m': 'seguro',       'f': 'segura'},
    {'m': 'ergonómico',   'f': 'ergonómica'},
    {'m': 'rápido',       'f': 'rápida'},
    {'m': 'duradero',     'f': 'duradera'},
    {'m': 'elegante',     'f': 'elegante'},
    {'m': 'moderno',      'f': 'moderna'},
    {'m': 'compacto',     'f': 'compacta'},
    {'m': 'resistente',   'f': 'resistente'},
    {'m': 'ligero',       'f': 'ligera'},
    {'m': 'silencioso',   'f': 'silenciosa'},
    {'m': 'potente',      'f': 'potente'},
    {'m': 'versátil',     'f': 'versátil'},
    {'m': 'económico',    'f': 'económica'},
    {'m': 'eficiente',    'f': 'eficiente'},
    {'m': 'sofisticado',  'f': 'sofisticada'},
    {'m': 'innovador',    'f': 'innovadora'},
    {'m': 'práctico',     'f': 'práctica'},
    {'m': 'robusto',      'f': 'robusta'},
    {'m': 'inteligente',  'f': 'inteligente'},
    {'m': 'rápido',       'f': 'rápida'},
    {'m': 'versátil',     'f': 'versátil'},
    {'m': 'compacto',     'f': 'compacta'},
    {'m': 'duradero',     'f': 'duradera'},
    {'m': 'económico',    'f': 'económica'},
    {'m': 'resistente',   'f': 'resistente'},
    {'m': 'eficiente',    'f': 'eficiente'},
    {'m': 'silencioso',   'f': 'silenciosa'},
    {'m': 'potente',      'f': 'potente'},
    {'m': 'innovador',    'f': 'innovadora'},
    {'m': 'ergonómico',   'f': 'ergonómica'},
    {'m': 'inteligente',  'f': 'inteligente'},
    {'m': 'sofisticado',  'f': 'sofisticada'},
    {'m': 'ligero',       'f': 'ligera'},
    {'m': 'práctico',     'f': 'práctica'},
    {'m': 'elegante',     'f': 'elegante'},
    {'m': 'robusto',      'f': 'robusta'},
    {'m': 'moderno',      'f': 'moderna'},
    {'m': 'compacto',     'f': 'compacta'},
    {'m': 'fiable',       'f': 'fiable'},
    {'m': 'resistente',   'f': 'resistente'},
    {'m': 'duradero',     'f': 'duradera'},
    {'m': 'económico',    'f': 'económica'},
    {'m': 'versátil',     'f': 'versátil'},
    {'m': 'eficiente',    'f': 'eficiente'},
    {'m': 'innovador',    'f': 'innovadora'},
    {'m': 'silencioso',   'f': 'silenciosa'},
    {'m': 'potente',      'f': 'potente'},
    {'m': 'ergonómico',   'f': 'ergonómica'},
]

ARTICLES: dict[dict[str]]= {
    'm': {
      'defined': 'el',
      'undefined': 'un',
    },
    'f': {
       'defined': 'la',
       'undefined': 'una',
    },
}

BRANDS: list[str] = [
    "ElectroMax",
    "HomeNova",
    "TechWise",
    "CasaPlus",
    "GigaHome",
    "NeoAppliances",
    "SmartEase",
    "PowerCore",
    "LumiHome",
    "OptiTech",
    "UrbanEase",
    "MegaGear",
    "NovaLiving",
    "ElectroZen",
    "PureHome",
    "AeroTech",
    "ZenithHome",
    "FlexiGear",
    "BrightHouse",
    "HomeSphere",
    "Voltix",
    "EcoNova",
    "PrimeHome",
    "TechNest",
    "UltraGear",
    "NeoLife",
    "SmartLiving",
    "HomeFusion",
    "Voltana",
    "InnovoHome"
]

PRODUCT_NAMES: list[str] = [
    "TurboDome",
    "EngiProVX",
    "PowerNova",
    "UltraFlex",
    "NeoSpark",
    "EcoVolt",
    "MaxiClean",
    "AeroPulse",
    "BrightWave",
    "SmartFlow",
    "PureAirX",
    "FlexiCore",
    "ZenithGear",
    "LumiTech",
    "OptiMove",
    "MegaBoost",
    "NovaGlide",
    "QuickZap",
    "TurboEase",
    "PowerSphere",
    "ElectroZen",
    "HomeFusion",
    "Voltana",
    "AirNova",
    "SmartNest",
    "NeoClean",
    "TechSphere",
    "EcoWave",
    "UltraVolt",
    "FlexiHome",
    "MaxiPulse",
    "BrightHome",
    "PureFlow",
    "NeoDome",
    "TurboWave",
    "ZenAir",
    "OptiHome",
    "MegaWave",
    "LumiSphere",
    "SmartCore",
    "PowerGlide",
    "QuickAir",
    "UltraHome",
    "EcoSpark",
    "NeoVolt",
    "AirFlex",
    "TurboCore",
    "MaxiHome",
    "BrightPulse",
    "ZenSpark"
]

def getRandomProduct() -> dict[str, any]:
  category: str = random.choice(list(CATEGORIES.keys()))
  brand: str = random.choice(BRANDS)
  n_img: int = CATEGORIES[category].n_img
  cat_name: str = CATEGORIES[category].cat_name
  image_number: int = n_img if n_img == 1 else random.randint(1, n_img)
  image_folder: str = "https://raw.githubusercontent.com/GrupoMedac7/Nexa/dev/assets/images/products/"

  def getProductVersion() -> str:
      year_version = str(random.randint(1, 6) * 1000)
      numeric_version = f"{random.randint(1, 10)}.{random.randint(0, 9)}"
      suffix_version = random.choice(["Pro", "Max", "Ultra", "X", "Plus"])

      return random.choice([year_version, numeric_version, suffix_version])

  def getProductName(category: str) -> str:
    version: str = getProductVersion()
    return f"{category.capitalize()} {random.choice(PRODUCT_NAMES)} {version}"

  def getDescription(category: str) -> str:
    gender = CATEGORIES[category].gen
    defined_art = ARTICLES[gender]['defined']
    undefined_art = ARTICLES[gender]['undefined']
    adjectives = random.choices([adj[gender] for adj in ADJECTIVES], k=2)

    version1: str = f"{undefined_art.capitalize()} {category} {adjectives[0]} y {adjectives[1]}"
    version2 = f"{defined_art.capitalize()} mejor {category} {random.choice([
      'del mercado.',
      'que el dinero puede comprar.',
      'en años.',
      'de su categoría.',
      'para toda la familia.',
      'con garantía de calidad.',
      'que supera a la competencia.',
      'que todos recomiendan.',
      'para uso diario.',
      'con diseño innovador.'
    ])}"

    return random.choice([version1, version2])

  return {
    'name': getProductName(category),
    'category': CATEGORIES[category].pl,
    'brand': brand,
    'description': getDescription(category),
    'stock': random.randint(0, 500),
    'price': round(random.randint(25, 1000) - random.choice([0, 0.01, 0.51]), 2),
    'imageRef': f"{image_folder}{cat_name}{image_number}.png"
  }