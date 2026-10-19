#!/usr/bin/env bash
# =============================================================================
# download.sh — Descargar modelo GGUF para llama.cpp
# Repositorio: https://github.com/cotizcesar/opencode-local-llm-coding
# =============================================================================
set -euo pipefail

MODEL_DIR="models"
MODEL_NAME="qwen2.5-coder-14b-q4_k_m.gguf"
MODEL_URL="https://huggingface.co/bartowski/Qwen2.5-Coder-14B-GGUF/resolve/main/Qwen2.5-Coder-14B-Q4_K_M.gguf"

mkdir -p "$MODEL_DIR"

echo "============================================================"
echo "  Descargando modelo para llama.cpp"
echo "  Modelo: $MODEL_NAME"
echo "============================================================"

if [ -f "$MODEL_DIR/$MODEL_NAME" ]; then
  echo "  El modelo ya existe: $MODEL_DIR/$MODEL_NAME"
  echo "  Tamaño: $(du -h "$MODEL_DIR/$MODEL_NAME" | cut -f1)"
  exit 0
fi

echo "  Descargando desde: $MODEL_URL"
echo "  Esto puede tardar varios minutos (modelo de ~9 GB)..."

curl -L -C - -o "$MODEL_DIR/$MODEL_NAME" "$MODEL_URL"

echo ""
echo "============================================================"
echo "  DESCARGA COMPLETA"
echo "  Modelo: $MODEL_DIR/$MODEL_NAME"
echo "  Tamaño: $(du -h "$MODEL_DIR/$MODEL_NAME" | cut -f1)"
echo "============================================================"
echo ""
echo "  Para iniciar el servidor:"
echo "    ./scripts/server.sh"
echo ""
