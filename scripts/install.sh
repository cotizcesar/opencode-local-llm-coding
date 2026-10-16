#!/usr/bin/env bash
# =============================================================================
# install.sh — Instalación automática: Ollama + Qwen 2.5 Coder 14B + OpenCode
# Repositorio: https://github.com/cotizcesar/opencode-local-llm-coding
# =============================================================================
set -euo pipefail

MODEL_NAME="qwen2.5-coder:14b"
LOCAL_MODEL_NAME="qwen-coder-local"
OLLAMA_PORT="11434"

echo "============================================================"
echo "  OpenCode + Modelo Local para Programar — Instalador"
echo "  Modelo: $MODEL_NAME  →  $LOCAL_MODEL_NAME"
echo "============================================================"

# --- 0. Requisitos -------------------------------------------------------------
need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Falta el comando '$1'. Instálalo antes de continuar."
    exit 1
  fi
}
need_cmd curl

# --- 1. Instalar Ollama --------------------------------------------------------
if ! command -v ollama >/dev/null 2>&1; then
  echo "[1/5] Instalando Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
else
  echo "[1/5] Ollama ya está instalado: $(ollama --version)"
fi

# --- 2. Levantar servicio de Ollama -------------------------------------------
echo "[2/5] Levantando servicio de Ollama (puerto $OLLAMA_PORT)..."
if ! pgrep -x ollama >/dev/null 2>&1; then
  nohup ollama serve >/tmp/ollama.log 2>&1 &
  # Esperar a que responda
  for i in $(seq 1 30); do
    if curl -s http://localhost:$OLLAMA_PORT/api/tags >/dev/null 2>&1; then
      echo "  Ollama listo en http://localhost:$OLLAMA_PORT"
      break
    fi
    sleep 1
  done
  if ! curl -s http://localhost:$OLLAMA_PORT/api/tags >/dev/null 2>&1; then
    echo "  ERROR: Ollama no responde. Revisa /tmp/ollama.log"
    exit 1
  fi
else
  echo "  Ollama ya está corriendo."
fi

# --- 3. Descargar modelo base --------------------------------------------------
echo "[3/5] Descargando modelo base '$MODEL_NAME' (puede tardar varios minutos)..."
if ollama list | grep -q "^$MODEL_NAME "; then
  echo "  Modelo '$MODEL_NAME' ya está descargado."
else
  ollama pull "$MODEL_NAME"
fi

# --- 4. Crear modelo personalizado optimizado para código ----------------------
echo "[4/5] Creando modelo personalizado '$LOCAL_MODEL_NAME'..."
if [ -f Modelfile ]; then
  ollama create "$LOCAL_MODEL_NAME" -f Modelfile
else
  echo "  ADVERTENCIA: No se encontró Modelfile. Se usará el modelo base tal cual."
  LOCAL_MODEL_NAME="$MODEL_NAME"
fi

# --- 5. Configurar OpenCode ----------------------------------------------------
echo "[5/5] Configurando OpenCode..."
CONFIG_DIR="$HOME/.config/opencode"
mkdir -p "$CONFIG_DIR"
CONFIG_FILE="$CONFIG_DIR/opencode.json"

# Si ya existe, hacer backup
if [ -f "$CONFIG_FILE" ]; then
  cp "$CONFIG_FILE" "${CONFIG_FILE}.bak.$(date +%s)"
  echo "  Backup de configuración existente guardado."
fi

# Escribir configuración con proveedor Ollama
cat > "$CONFIG_FILE" <<JSON
{
  "\$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:$OLLAMA_PORT/v1",
        "apiKey": "ollama"
      },
      "models": {
        "$LOCAL_MODEL_NAME": {
          "name": "Qwen 2.5 Coder 14B (local)",
          "modalities": {
            "input": ["text"],
            "output": ["text"]
          },
          "limit": {
            "context": 131072,
            "output": 8192
          }
        }
      }
    }
  },
  "model": "ollama/$LOCAL_MODEL_NAME"
}
JSON

echo "  Configuración escrita en $CONFIG_FILE"

# --- Resumen -------------------------------------------------------------------
echo ""
echo "============================================================"
echo "  INSTALACIÓN COMPLETA"
echo "============================================================"
echo "  Modelo local:     $LOCAL_MODEL_NAME (base: $MODEL_NAME)"
echo "  Endpoint Ollama:  http://localhost:$OLLAMA_PORT/v1"
echo "  Config OpenCode:  $CONFIG_FILE"
echo "  Modelo OpenCode:  ollama/$LOCAL_MODEL_NAME"
echo ""
echo "  Para iniciar OpenCode:"
echo "    opencode"
echo "  Luego selecciona el modelo con: /models"
echo "============================================================"
