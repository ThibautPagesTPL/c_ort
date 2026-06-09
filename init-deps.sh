#!/usr/bin/env bash
# init-deps.sh
# Initialise les dépendances du projet sous forme de sous-modules Git.
# Usage : bash init-deps.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPS_DIR="${SCRIPT_DIR}/deps"

echo "=== Initialisation des dépendances ==="

mkdir -p "${DEPS_DIR}"
cd "${SCRIPT_DIR}"

# Initialise le dépôt Git si nécessaire
if [ ! -d ".git" ]; then
    git init
fi

# --------------------------------------------------------------------------
# Fonction utilitaire
# --------------------------------------------------------------------------
add_submodule() {
    local url="$1"
    local path="$2"
    local ref="$3"   # tag ou commit SHA

    if [ ! -d "${path}/.git" ] && [ ! -f "${path}/.git" ]; then
        echo "[+] Ajout : ${path} (${ref})"
        git submodule add --force "${url}" "${path}" 2>/dev/null || true
    fi

    echo "[~] Checkout ${path} → ${ref}"
    (
        cd "${path}"
        git fetch --tags --quiet
        git checkout "${ref}" --quiet
    )
}

# --------------------------------------------------------------------------
# 1. CMSIS-device-u5  v1.4.2
# --------------------------------------------------------------------------
add_submodule \
    "https://github.com/STMicroelectronics/cmsis-device-u5.git" \
    "deps/cmsis-device-u5" \
    "v1.4.2"

# --------------------------------------------------------------------------
# 2. CMSIS_5  5.9.0
# --------------------------------------------------------------------------
add_submodule \
    "https://github.com/ARM-software/CMSIS_5.git" \
    "deps/CMSIS_5" \
    "5.9.0"

# --------------------------------------------------------------------------
# 3. stm32u5xx-hal-driver  v1.6.2
# --------------------------------------------------------------------------
add_submodule \
    "https://github.com/STMicroelectronics/stm32u5xx-hal-driver.git" \
    "deps/stm32u5xx-hal-driver" \
    "v1.6.2"

# --------------------------------------------------------------------------
# 4. CMSIS-FreeRTOS  v11.2.0
# --------------------------------------------------------------------------
add_submodule \
    "https://github.com/ARM-software/CMSIS-FreeRTOS.git" \
    "deps/CMSIS-FreeRTOS" \
    "v11.2.0"

# --------------------------------------------------------------------------
# 5. BTstack  1.6.1  (tag : v1.6.1)
# --------------------------------------------------------------------------
add_submodule \
    "https://github.com/bluekitchen/btstack.git" \
    "deps/btstack" \
    "v1.6.1"

# --------------------------------------------------------------------------
# 6. TinyUSB  commit 9c8c5c1
# --------------------------------------------------------------------------
add_submodule \
    "https://github.com/hathach/tinyusb.git" \
    "deps/tinyusb" \
    "9c8c5c1"

# --------------------------------------------------------------------------
# 7. NNoM  commit 91e4b00
# --------------------------------------------------------------------------
add_submodule \
    "https://github.com/majianjia/nnom.git" \
    "deps/nnom" \
    "91e4b00"

# --------------------------------------------------------------------------
# Génération du .gitmodules final
# --------------------------------------------------------------------------
echo ""
echo "=== Dépendances initialisées avec succès ==="
echo "Sous-modules actifs :"
git submodule status
