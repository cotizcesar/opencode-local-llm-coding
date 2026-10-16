#!/usr/bin/env bash
# =============================================================================
# verify.sh — Verificación de conexión y velocidad del modelo local
# Repositorio: https://github.com/cotizcesar/opencode-local-llm-coding
# =============================================================================
set -euo pipefail

OLLAMA_PORT="${OLLAMA_PORT:-11434}"
MODEL="${1:-qwen-coder-local}"

echo "============================================================"
echo "  Verificación del modelo local para OpenCode"
echo "============================================================"

# 1. Ollama responde
echo ""
echo "[1/4] Comprobando que Ollama responde en http://localhost:$OLLAMA_PORT ..."
if curl -s http://localhost:$OLLAMA_PORT/api/tags >/dev/null 2>&1; then
  echo "  ✅ Ollama está en línea."
else
  echo "  ❌ Ollama no responde. Ejecuta: ollama serve"
  exit 1
fi

# 2. Modelo disponible
echo ""
echo "[2/4] Comprobando que el modelo '$MODEL' está disponible..."
if ollama list | grep -q "^$MODEL "; then
  echo "  ✅ Modelo '$MODEL' encontrado."
else
  echo "  ⚠️  Modelo '$MODEL' no encontrado en Ollama. Modelos disponibles:"
  ollama list
  echo ""
  echo "  Intenta: ./scripts/install.sh"
  exit 1
fi

# 3. Prueba de generación (velocidad)
echo ""
echo "[3/4] Prueba de generación (tokens/segundo)..."
START=$(date +%s%N)
RESPONSE=$(curl -s http://localhost:$OLLAMA_PORT/api/generate \
  -d "{\"model\":\"$MODEL\",\"prompt\":\"Escribe una función en Python que calcule la sucesión de Fibonacci de forma eficiente y explíquela en una línea. Responde solo el código y la explicación.\",\"stream\":false}" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('response',''))" 2>/dev/null || true)
END=$(date +%s%N)

if [ -n "$RESPONSE" ]; then
  ELAPSED_MS=$(( (END - START) / 1000000 ))
  echo "  ✅ Respuesta generada en ${ELAPSED_MS} ms."
  echo ""
  echo "  --- Respuesta del modelo ---"
  echo "$RESPONSE"
  echo "  ----------------------------"
else
  echo "  ⚠️  No se pudo obtener respuesta del modelo."
fi

# 4. OpenCode configurado
echo ""
echo "[4/4] Comprobando configuración de OpenCode..."
CONFIG_FILE="$HOME/.config/opencode/opencode.json"
if [ -f "$CONFIG_FILE" ]; then
  if python3 -c "import json; d=json.load(open('$CONFIG_FILE')); print('ollama' in d.get('provider',{}))" 2>/dev/null | grep -q True; then
    echo "  ✅ OpenCode tiene proveedor Ollama configurado."
  else
    echo "  ⚠️  OpenCode no tiene proveedor Ollama. Ejecuta: ./scripts/install.sh"
  fi
else
  echo "  ⚠️  No se encontró $CONFIG_FILE. Ejecuta: ./scripts/install.sh"
fi

echo ""
echo "============================================================"
echo "  Verificación completada."
echo "  Inicia OpenCode con: opencode"
echo "============================================================"
