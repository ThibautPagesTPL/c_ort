# ORT Vulnerability Analysis – Test Project (STM32U5 / C)

Projet de test pour l'analyse de vulnérabilités avec l'[OSS Review Toolkit (ORT)](https://github.com/oss-review-toolkit/ort).

## Dépendances déclarées

| Bibliothèque | Version / Commit | Source |
|---|---|---|
| cmsis-device-u5 | v1.4.2 | [STMicroelectronics/cmsis-device-u5](https://github.com/STMicroelectronics/cmsis-device-u5) |
| CMSIS-5 | 5.9.0 | [ARM-software/CMSIS_5](https://github.com/ARM-software/CMSIS_5) |
| stm32u5xx-hal-driver | v1.6.2 | [STMicroelectronics/stm32u5xx-hal-driver](https://github.com/STMicroelectronics/stm32u5xx-hal-driver) |
| CMSIS-FreeRTOS | v11.2.0 | [ARM-software/CMSIS-FreeRTOS](https://github.com/ARM-software/CMSIS-FreeRTOS) |
| btstack | 1.6.1 | [bluekitchen/btstack](https://github.com/bluekitchen/btstack) |
| tinyusb | commit 9c8c5c1 | [hathach/tinyusb](https://github.com/hathach/tinyusb) |
| nnom | commit 91e4b00 | [majianjia/nnom](https://github.com/majianjia/nnom) |

## Structure du projet

```
ort-test-project/
├── src/
│   └── main.c                  # Code applicatif (stub embarqué)
├── include/
│   └── FreeRTOSConfig.h        # Configuration FreeRTOS STM32U5
├── deps/                       # Sous-modules Git (créés par init-deps.sh)
│   ├── cmsis-device-u5/
│   ├── CMSIS_5/
│   ├── stm32u5xx-hal-driver/
│   ├── CMSIS-FreeRTOS/
│   ├── btstack/
│   ├── tinyusb/
│   └── nnom/
├── .ort/
│   └── config.yml              # Configuration ORT (advisors, reporters…)
├── .gitmodules                 # Déclaration des sous-modules Git
├── CMakeLists.txt              # Système de build (CMake)
├── deps.gradle                 # Déclaration alternative lisible par ORT
├── init-deps.sh                # Initialise les sous-modules
└── run-ort.sh                  # Lance l'analyse ORT complète
```

## Utilisation

### 1. Initialiser les dépendances

```bash
chmod +x init-deps.sh
./init-deps.sh
```

### 2. Lancer l'analyse ORT

#### Prérequis
- Java 17+ dans le PATH
- ORT installé : `brew install ort` (macOS) ou télécharger le binaire sur [GitHub Releases](https://github.com/oss-review-toolkit/ort/releases)

#### Analyse complète (Analyze → Scan → Advise → Report)

```bash
chmod +x run-ort.sh
./run-ort.sh
```

#### Ou étape par étape

```bash
# Analyze
ort analyze -i . -o ort-results -f JSON --package-managers GitSubmodules,Unmanaged

# Scan (licences)
ort scan --ort-file ort-results/analyzer-result.json -o ort-results -f JSON

# Advise (vulnérabilités via OSS Index)
ort advise --ort-file ort-results/scan-result.json -o ort-results --advisors OssIndex

# Report
ort report --ort-file ort-results/advisor-result.json -o ort-results/reports -f WebApp,CycloneDX,SpdxDocument
```

### 3. Consulter les résultats

- **WebApp** : ouvrir `ort-results/reports/index.html` dans un navigateur
- **CycloneDX** : SBOM exploitable par d'autres outils (Dependency-Track, etc.)
- **SPDX** : format standard SPDX 2.3

## Notes sur les dépendances épinglées sur un commit

TinyUSB (`9c8c5c1`) et NNoM (`91e4b00`) sont référencés par SHA de commit sans tag de version.
ORT les analysera correctement via le resolver `GitSubmodules`, mais la détection de
vulnérabilités dans OSS Index peut être partielle si la version sémantique n'est pas connue.

**Recommandation** : utiliser des tags de version dès que possible pour une meilleure
couverture par les bases CVE.
