Utilidades para trabajar con la base de datos de Firestore
IMPORTANTE: antes de utilizar activar el entorno de python (./firestore_seed_env/Scripts/activate)
IMPORTANTEx2: ambas utilidades necesitan un .json de configuración de Firebase. Este .json NO DEBE APARECER EN GITHUB. Si
vas a utilizar estas aplicaciones o bien pide que te manden el archivo de configuración o, si tienes acceso al proyecto,
que deberías, puedes generar uno en Firebase -> Configuración del proyecto -> Cuentas de Servicio -> Generar nueva clave privada

-firestore_clear.py: elimina todos los documentos de la colección "products". Si más adelante se crean otras colecciones,
es fácil modificarlo añadiendo argparse por ejemplo y recogiendo el nombre de la colección como argumento

-firestore_seed.py: genera un número determinado de documentos en la colección "products" con campos aleatorios. Ejemplo
de uso: python firestore_seed.py 100 (genera 100 productos aleatorios)