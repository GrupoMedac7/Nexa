import 'package:flutter/foundation.dart';

final String ENV = kDebugMode ? 'debug' : 'production';

const String GITHUB_URL = 'https://raw.githubusercontent.com/GrupoMedac7/Nexa/';
const String BRANCH = kDebugMode ? 'dev' : 'main';
const String DEFAULT_PRODUCT_IMAGE_REF = '$GITHUB_URL$BRANCH/assets/images/products/Default_image.png';