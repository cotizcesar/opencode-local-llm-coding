#!/usr/bin/env bash
# =============================================================================
# server.sh — Iniciar servidor llama.cpp (OpenAI-compatible)
# Repositorio: https://github.com/cotizcesar/opencode-local-llm-coding
# =============================================================================
set -uo pipefail

MODEL_FILE="${1:-models/qwen2.5-coder-14b-q4_k_m.gguf}"
PORT="${PORT:-8080}"
CTX="${CTX:-131072}"
NGPU="${NGPU:-0}"  # 0 = CPU. Poner >0 si tienes CUDA compilado

echo "============================================================"
echo "  Iniciando servidor llama.cpp"
echo "  Modelo: $MODEL_FILE"
echo "  Puerto: $PORT"
echo "  Contexto: $CTX"
echo "  GPU layers: $NGPU (0 = CPU)"
echo "============================================================"

if [ ! -f "$MODEL_FILE" ]; then
  echo "  ERROR: No se encontró el modelo: $MODEL_FILE"
  echo "  Ejecuta primero: ./scripts/download.sh"
  exit 1
fi

# Verificar que llama-server exista
LLAMA_SERVER="./llama.cpp/llama-server"
if [ ! -f "$LLAMA_SERVER" ]; then
  # Buscar en build
  LLAMA_SERVER="./llama.cpp/build/bin/llama-server"
  if [ ! -f "$LLAMA_SERVER" ]; then
    echo "  ERROR: No se encontró llama-server"
    echo "  Compila llama.cpp primero:"
    echo "    cd llama.cpp && cmake -B build && cmake --build build"
    exit 1
  fi
fi

echo "  Servidor: $LLAMA_SERVER"
echo ""
echo "  Luego configura OpenCode con baseURL: http://127.0.0.1:$PORT/v1"
echo "  Y selecciona el modelo en OpenCode con: /models"
echo ""

exec "$LLAMA_SERVER" \
  --model "$MODEL_FILE" \
  --port "$PORT" \
  --ctx-size "$CTX" \
  --n-gpu-layers "$NGPU" \
  --host 127.0.0.1
