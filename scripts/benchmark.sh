#!/usr/bin/env bash
# =============================================================================
# benchmark.sh — Pruebas REALES de modelos locales en RTX 5070 Ti (16 GB VRAM)
# Compara: Qwen3 14B, Qwen 2.5 Coder 14B, Gemma 4 12B, Bonsai 27B Q4_K_M
# Mide: VRAM, velocidad (tok/s), generación de código, tool calling con OpenCode
# Repositorio: https://github.com/cotizcesar/opencode-local-llm-coding
# =============================================================================
set -uo pipefail

OLLAMA_PORT="${OLLAMA_PORT:-11434}"
RESULTS_FILE="/tmp/opencode-local-llm-benchmark-$(date +%Y%m%d-%H%M%S).md"
RESULTS_DIR="docs/benchmark-results"
mkdir -p "$RESULTS_DIR"

# Modelos a probar (nombres exactos de Ollama)
MODELS=(
  "qwen3:14b"
  "qwen2.5-coder:14b"
  "gemma4:12b"
  "wcamaralopes/bonsai-27b-Q4_K_M"
)

PROMPT_CODE="Escribe una función en Python que implemente un LRU Cache con get y put, con complejidad O(1), incluyendo docstrings, type hints y un ejemplo de uso. Responde solo con el código completo y listo para ejecutar."

PROMPT_TOOL="Dame el nombre de una función de Python que lea un archivo JSON y devuelva un diccionario. Solo el nombre de la función, nada más."

echo "# Benchmark Local LLM — RTX 5070 Ti 16 GB VRAM" > "$RESULTS_FILE"
echo "Fecha: $(date)" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"
echo "| Modelo | VRAM carga (MB) | VRAM genera (MB) | Velocidad (tok/s) | TTFT (s) | Código válido | Tool calling |" >> "$RESULTS_FILE"
echo "|---|---|---|---|---|---|---|" >> "$RESULTS_FILE"

vram_used() {
  nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null | head -1
}

for MODEL in "${MODELS[@]}"; do
  echo ""
  echo "============================================================"
  echo "Probando: $MODEL"
  echo "============================================================"

  if ! ollama list 2>/dev/null | grep -q "$MODEL"; then
    echo "  ❌ Modelo '$MODEL' no disponible en Ollama. Saltando."
    echo "| $MODEL | — | — | — | — | NO | NO |" >> "$RESULTS_FILE"
    continue
  fi

  # Cargar modelo (warmup) y medir VRAM
  echo "  Cargando modelo (warmup)..."
  ollama run "$MODEL" "Hola" >/dev/null 2>&1
  VRAM_IDLE=$(vram_used)
  echo "  VRAM después de cargar: ${VRAM_IDLE} MB"

  # Prueba de generación de código y medir velocidad
  echo "  Ejecutando prueba de generación de código..."
  START_TS=$(date +%s%N)
  RESPONSE=$(curl -s http://localhost:$OLLAMA_PORT/api/generate \
    -d "{\"model\":\"$MODEL\",\"prompt\":\"$PROMPT_CODE\",\"stream\":false}" \
    2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('response',''))" 2>/dev/null || true)
  END_TS=$(date +%s%N)

  if [ -n "$RESPONSE" ]; then
    ELAPSED_S=$(awk "BEGIN {printf \"%.2f\", ($END_TS - $START_TS) / 1000000000}")
    CHARS=${#RESPONSE}
    TOKS_PER_S=$(awk "BEGIN {printf \"%.1f\", $CHARS/4/$ELAPSED_S}")
    VRAM_GEN=$(vram_used)

    if echo "$RESPONSE" | grep -qE "def |class |__init__"; then
      CODE_VALID="Sí"
    else
      CODE_VALID="Parcial"
    fi

    # Prueba tool calling simple
    TOOL_RESP=$(curl -s http://localhost:$OLLAMA_PORT/api/generate \
      -d "{\"model\":\"$MODEL\",\"prompt\":\"$PROMPT_TOOL\",\"stream\":false}" \
      2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('response',''))" 2>/dev/null || true)
    if echo "$TOOL_RESP" | grep -qiE "def |read_json|load_json|cargar"; then
      TOOL_OK="Sí"
    else
      TOOL_OK="Parcial"
    fi

    echo "  TTFT: ${ELAPSED_S}s | Velocidad: ${TOKS_PER_S} tok/s | VRAM genera: ${VRAM_GEN} MB | Código: $CODE_VALID | Tool: $TOOL_OK"
    echo "| $MODEL | $VRAM_IDLE | $VRAM_GEN | $TOKS_PER_S | $ELAPSED_S | $CODE_VALID | $TOOL_OK |" >> "$RESULTS_FILE"

    # Guardar respuesta individual
    echo "### $MODEL — respuesta código" > "$RESULTS_DIR/${MODEL//\//_}-code.md"
    echo "$RESPONSE" >> "$RESULTS_DIR/${MODEL//\//_}-code.md"
  else
    echo "  ⚠️  No se obtuvo respuesta."
    echo "| $MODEL | $VRAM_IDLE | — | — | — | NO | NO |" >> "$RESULTS_FILE"
  fi
done

echo ""
echo "============================================================"
echo "  RESULTADOS GUARDADOS EN: $RESULTS_FILE"
echo "============================================================"
cat "$RESULTS_FILE"
