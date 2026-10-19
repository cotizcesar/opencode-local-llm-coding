#!/usr/bin/env bash
# =============================================================================
# benchmark.sh — Pruebas reales de llama.cpp
# Compara velocidad y calidad de código
# Repositorio: https://github.com/cotizcesar/opencode-local-llm-coding
# =============================================================================
set -uo pipefail

PORT="${PORT:-8080}"
MODEL="${MODEL:-qwen2.5-coder-14b}"
RESULTS_FILE="benchmarks/results-$(date +%Y%m%d-%H%M%S).md"

mkdir -p benchmarks

PROMPT_CODE="Escribe una función en Python que implemente un LRU Cache con get y put, con complejidad O(1), incluyendo docstrings, type hints y un ejemplo de uso. Responde solo con el código completo y listo para ejecutar."

echo "# Benchmark llama.cpp — $(date)" > "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"
echo "| Métrica | Valor |" >> "$RESULTS_FILE"
echo "|---|---|" >> "$RESULTS_FILE"

echo ""
echo "============================================================"
echo "  Verificando que el servidor esté en línea"
echo "============================================================"

if ! curl -s http://127.0.0.1:$PORT/v1/models >/dev/null 2>&1; then
  echo "  ❌ El servidor no responde en http://127.0.0.1:$PORT/v1/models"
  echo "  Inicia el servidor primero: ./scripts/server.sh"
  exit 1
fi

echo "  ✅ Servidor en línea"

echo ""
echo "============================================================"
echo "  Prueba de generación de código"
echo "============================================================"

START_TS=$(date +%s%N)
RESPONSE=$(curl -s http://127.0.0.1:$PORT/v1/chat/completions \
  -d "{\"model\":\"$MODEL\",\"messages\":[{\"role\":\"user\",\"content\":\"$PROMPT_CODE\"}],\"stream\":false}" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('choices',[{}])[0].get('message',{}).get('content',''))" 2>/dev/null || true)
END_TS=$(date +%s%N)

ELAPSED_S=$(awk "BEGIN{printf \"%.2f\", ($END_TS - $START_TS) / 1000000000}")
CHARS=${#RESPONSE}
TOKS_PER_S=$(awk "BEGIN{printf \"%.1f\", $CHARS/4/$ELAPSED_S}")

echo "  Tiempo: ${ELAPSED}s"
echo "  Chars: $CHARS"
echo "  Tok/s aprox: $TOKS_PER_S"

echo "| Tiempo generación (s) | $ELAPSED_S |" >> "$RESULTS_FILE"
echo "| Tok/s aprox | $TOKS_PER_S |" >> "$RESULTS_FILE"
echo "| Chars generados | $CHARS |" >> "$RESULTS_FILE"

if echo "$RESPONSE" | grep -qE "def |class |__init__"; then
  echo "  ✅ Código válido detectado"
  echo "| Código válido | SÍ |" >> "$RESULTS_FILE"
else
  echo "  ⚠️  Código no válido o incompleto"
  echo "| Código válido | NO |" >> "$RESULTS_FILE"
fi

echo ""
echo "--- Respuesta (primeras 15 líneas) ---"
echo "$RESPONSE" | head -15

echo ""
echo "============================================================"
echo "  RESULTADOS GUARDADOS EN: $RESULTS_FILE"
echo "============================================================"
