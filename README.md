# OpenCode + Modelo Local para Programar

> Mejor modelo local para correr en tu PC y dejarlo listo para programar con [OpenCode](https://opencode.ai). Todo trazable en este repositorio público.

[![GitHub repo](https://img.shields.io/badge/GitHub-cotizcesar%2Fopencode--local--llm--coding-blue)](https://github.com/cotizcesar/opencode-local-llm-coding)

---

## 🎯 Objetivo

Configurar OpenCode con un **modelo de lenguaje local (LLM)** especializado en programación, corriendo 100% en tu hardware, sin que tu código salga de tu máquina, con la mejor relación capacidad / VRAM disponible.

## 🖥️ Hardware detectado (esta máquina)

| Componente | Especificación |
|---|---|
| CPU | AMD Ryzen 7 9800X3D — 8C/16T, hasta 5.27 GHz |
| GPU | **NVIDIA GeForce RTX 5070 Ti — 16 GB VRAM** |
| RAM | 30 GB (≈8.9 GB libre) |
| Swap | 15 GB |
| SO | Linux (x86_64) |

## 🏆 Modelo seleccionado: Qwen 2.5 Coder 14B

Tras comparar las mejores opciones locales para código de 2026, el modelo ganador para tu RTX 5070 Ti (16 GB VRAM) es:

| Modelo | Parámetros | VRAM aprox. (Q4) | Contexto | Licencia | Veredicto |
|---|---|---|---|---|---|
| **Qwen 2.5 Coder 14B** | 14B denso | **≈9 GB** | 32K | Apache 2.0 | ✅ **GANADOR** — Cabe sobrado en 16GB, deja espacio para contexto (KV cache), excelente para código y agentic loops |
| Qwen 2.5 Coder 32B | 32B denso | ≈20 GB | 32K | Apache 2.0 | No cabe cómodo en 16GB |
| Qwen3-Coder 30B (MoE) | 30.5B / 3.3B activo | ≈19 GB | 256K | Apache 2.0 | No cabe en 16GB (Q4) |
| DeepSeek-Coder-V2 Lite | 16B / 2.4B activo | ≈9 GB | 128K | DeepSeek | Buena alternativa (MoE) |
| Codestral 22B | 22B | ≈13 GB | 256K | Propietaria | Cerca del límite, licencia restrictiva |

### ¿Por qué Qwen 2.5 Coder 14B y no el más grande?

La **VRAM es el cuello de botella**, no la CPU. Un modelo más grande que no quepa en 16 GB se swappea a RAM del sistema y colapsa la velocidad de generación (tokens/segundo), haciendo inútil a un agente de programación. Qwen 2.5 Coder 14B deja **≈7 GB libres** para el contexto de la conversación, archivos abiertos y KV cache —fundamental para que OpenCode pueda leer tu repositorio entero sin truncar.

**Referencias:**
- [Best Local LLMs for Coding in 2026 (AI Intel Report)](https://aiintelreport.com/enterprise-ai/best-local-llms-for-coding-2026)
- [Best Local AI for Coding 2026 (LocalAIMaster)](https://localaimaster.com/blog/best-local-ai-models-programming)

## 📦 Estructura del repositorio

```
opencode-local-llm-coding/
├── README.md                      # Esta guía
├── opencode.json                  # Configuración de OpenCode (proveedor Ollama)
├── Modelfile                      # Modelo personalizado de Ollama optimizado para código
├── .gitignore
├── scripts/
│   ├── install.sh                 # Instalación automática (Ollama + modelo + OpenCode)
│   └── verify.sh                  # Verificación de conexión y velocidad
└── docs/
    ├── hardware-analysis.md       # Análisis de tu hardware y por qué este modelo
    ├── model-selection.md         # Comparativa de modelos locales para código
    └── benchmark.md               # Resultados de pruebas (tokens/s, contexto)
```

## 🚀 Instalación rápida

```bash
# 1. Clonar este repositorio
git clone https://github.com/cotizcesar/opencode-local-llm-coding.git
cd opencode-local-llm-coding

# 2. Ejecutar el instalador (instala Ollama, baja el modelo, configura OpenCode)
chmod +x scripts/install.sh
./scripts/install.sh

# 3. Verificar que todo funciona
./scripts/verify.sh

# 4. Iniciar OpenCode con el modelo local
opencode
```

### Paso a paso manual

Si prefieres hacerlo a mano:

1. **Instala Ollama:**
   ```bash
   curl -fsSL https://ollama.com/install.sh | sh
   ```

2. **Inicia el servicio de Ollama:**
   ```bash
   ollama serve &
   # o en otra terminal
   ollama serve
   ```

3. **Descarga el modelo:**
   ```bash
   ollama pull qwen2.5-coder:14b
   ```

4. **Crea el modelo personalizado optimizado para código:**
   ```bash
   ollama create qwen-coder-local -f Modelfile
   ```

5. **Configura OpenCode** (`~/.config/opencode/opencode.json`) — ver `opencode.json` en este repo.

6. **Ejecuta OpenCode:**
   ```bash
   opencode
   ```
   Luego usa `/models` y selecciona `ollama/qwen-coder-local`.

## ⚙️ Configuración de OpenCode (`opencode.json`)

El archivo `opencode.json` de este repo configura Ollama como proveedor local con el modelo `qwen-coder-local`, contexto de 128K y salida de 8K tokens. Copia el bloque `provider.ollama` a tu `~/.config/opencode/opencode.json`.

Puntos clave:
- `baseURL`: `http://localhost:11434/v1` (endpoint OpenAI-compatible de Ollama)
- `limit.context`: 128000 (OpenCode requiere ≥64K; 128K da margen de sobra)
- `limit.output`: 8192 (suficiente para archivos grandes y refactors)

## 🧪 Verificación

Ejecuta `./scripts/verify.sh` para comprobar:
1. Que Ollama responde en `localhost:11434`
2. Que el modelo `qwen-coder-local` está disponible
3. Velocidad de generación (tokens/segundo)
4. Que OpenCode puede hacer tool calls correctamente

## 📊 Benchmarks y resultados

Véase `docs/benchmark.md`. Se irán llenando con mediciones reales en esta máquina (RTX 5070 Ti, 16GB VRAM).

## 🔁 Modelo de respaldo

Si por cualquier motivo Qwen 2.5 Coder 14B no funciona, la alternativa inmediata es **DeepSeek-Coder-V2 Lite 16B** (`deepseek-coder-v2:16b`), mismo script, solo cambia el nombre del modelo en `Modelfile` y `opencode.json`.

---

**Hecho con ❤️ para trazabilidad total.** Cada paso queda registrado en este repositorio público.
