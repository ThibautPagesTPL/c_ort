#!/usr/bin/env bash
# run-ort.sh
# Lance l'analyse ORT complète sur le projet.
# Prérequis : ORT installé (https://github.com/oss-review-toolkit/ort)
#             Java 17+ dans le PATH
#             Dépendances initialisées via init-deps.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORT_RESULTS_DIR="${SCRIPT_DIR}/ort-results"
ORT_CMD="${ORT_CMD:-ort}"  # Peut être surchargé : ORT_CMD=/opt/ort/bin/ort ./run-ort.sh

mkdir -p "${ORT_RESULTS_DIR}"

echo "======================================================"
echo " OSS Review Toolkit - Analyse de vulnérabilités"
echo " Projet : ${SCRIPT_DIR}"
echo "======================================================"
echo ""

# --------------------------------------------------------------------------
# 1. ANALYZE - Découverte des dépendances
# --------------------------------------------------------------------------
echo "[1/4] Analyze : découverte des dépendances..."
${ORT_CMD} \
    --info \
    analyze \
    --input-dir  "${SCRIPT_DIR}" \
    --output-dir "${ORT_RESULTS_DIR}" \
    --output-formats JSON \
    --package-managers GitSubmodules,Unmanaged

echo "  -> ${ORT_RESULTS_DIR}/analyzer-result.json"

# --------------------------------------------------------------------------
# 2. SCAN - Détection de licences (ScanCode)
# --------------------------------------------------------------------------
echo ""
echo "[2/4] Scan : détection de licences..."
${ORT_CMD} \
    --info \
    scan \
    --ort-file    "${ORT_RESULTS_DIR}/analyzer-result.json" \
    --output-dir  "${ORT_RESULTS_DIR}" \
    --output-formats JSON \
    --scanners    ScanCode

echo "  -> ${ORT_RESULTS_DIR}/scan-result.json"

# --------------------------------------------------------------------------
# 3. ADVISE - Analyse de vulnérabilités
# --------------------------------------------------------------------------
echo ""
echo "[3/4] Advise : analyse des vulnérabilités (OSS Index)..."
${ORT_CMD} \
    --info \
    advise \
    --ort-file    "${ORT_RESULTS_DIR}/scan-result.json" \
    --output-dir  "${ORT_RESULTS_DIR}" \
    --output-formats JSON \
    --advisors    OssIndex

echo "  -> ${ORT_RESULTS_DIR}/advisor-result.json"

# --------------------------------------------------------------------------
# 4. REPORT - Génération des rapports
# --------------------------------------------------------------------------
echo ""
echo "[4/4] Report : génération des rapports..."
${ORT_CMD} \
    --info \
    report \
    --ort-file    "${ORT_RESULTS_DIR}/advisor-result.json" \
    --output-dir  "${ORT_RESULTS_DIR}/reports" \
    --report-formats WebApp,CycloneDX,SpdxDocument

echo ""
echo "======================================================"
echo " Analyse terminée !"
echo " Rapports disponibles dans : ${ORT_RESULTS_DIR}/reports/"
echo "   - WebApp       : ouvrir index.html dans un navigateur"
echo "   - CycloneDX    : SBOM au format CycloneDX XML"
echo "   - SpdxDocument : SBOM au format SPDX 2.3"
echo "======================================================"
