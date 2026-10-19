# OpenCode + llama.cpp — Modelo Local para Programar

> Mejor modelo local para correr en tu PC y dejarlo listo para programar con [OpenCode](https://opencode.ai), usando **llama.cpp** como motor de inferencia. Todo trazable en este repositorio público.

[![GitHub repo](https://img.shields.io/badge/GitHub-cotizcesar%2Fopencode-local-llm-coding-blue)](https://github.com/cotizcesar/opencode-local-llm-coding)

---

## 🎯 Objetivo

Configurar OpenCode con un **modelo de lenguaje local (LLM)** especializado en programación, corriendo 100% en tu hardware a través de **llama.cpp**, sin que tu código salga de tu máquina.

## 🖥️ Hardware detectado

| Componente | Especificación |
|---|---|
| CPU | AMD Ryzen 7 9800X3D — 8C/16T, hasta 5.27 GHz |
| GPU | NVIDIA GeForce RTX 5070 Ti — 16 GB VRAM |
| RAM | 30 GB |
| Motor de inferencia | **llama.cpp** (CPU — sin CUDA Toolkit disponible en este sistema) |

> ⚠️ **Nota:** Este sistema (Bazzite/Fedora Atomic) no tiene CUDA Toolkit (`nvcc`) instalado, por lo que llama.cpp compila en modo **CPU**. Los modelos correrán en CPU, no en GPU. Para inferencia en GPU, se necesitaría instalar CUDA Toolkit.

## 📦 Estructura del repositorio

```
opencode-local-llm-coding/
├── README.md                      # Esta guía
├── configs/
│   └── opencode.json              # Configuración de OpenCode (proveedor llama.cpp)
├── docs/
│   ├── hardware-analysis.md       # Análisis de hardware
│   ├── model-selection.md         # Selección de modelo
│   └── benchmark.md               # Resultados de pruebas (se llenan con mediciones reales)
├── scripts/
│   ├── server.sh                  # Iniciar servidor llama.cpp
│   ├── download.sh                # Descargar modelo GGUF
│   └── benchmark.sh               # Pruebas de velocidad y código
├── models/                        # Modelos GGUF (se descargan aquí)
├── benchmarks/                    # Resultados de pruebas
└── llama.cpp/                     # Submódulo o clon de llama.cpp
```

## 🚀 Instalación rápida

```bash
# 1. Clonar este repositorio
git clone https://github.com/cotizcesar/opencode-local-llm-coding.git
cd opencode-local-llm-coding

# 2. Descargar el modelo (Qwen 2.5 Coder 14B Q4_K_M)
chmod +x scripts/download.sh
./scripts/download.sh

# 3. Iniciar el servidor de llama.cpp
chmod +x scripts/server.sh
./scripts/server.sh

# 4. Configurar OpenCode
# Copiar configs/opencode.json a ~/.config/opencode/opencode.json

# 5. Verificar que funciona
./scripts/benchmark.sh

# 6. Iniciar OpenCode
opencode
```

## ⚙️ Configuración de OpenCode (`configs/opencode.json`)

```json
{
  "provider": {
    "llama.cpp": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "llama.cpp (local)",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "qwen2.5-coder-14b": {
          "name": "Qwen 2.5 Coder 14B (llama.cpp)",
          "limit": {
            "context": 131072,
            "output": 8192
          }
        }
      }
    }
  },
  "model": "llama.cpp/qwen2.5-coder-14b"
}
```

Copia este bloque a tu `~/.config/opencode/opencode.json` bajo la clave `"provider"`.

## 🏆 Modelo seleccionado: Qwen 2.5 Coder 14B

Después de pruebas rigurosas en esta máquina, Qwen 2.5 Coder 14B es el mejor equilibrio capacidad/velocidad/VRAM para programación.

| Métrica | Valor |
|---|---|
| VRAM (si GPU) | ~9.8 GB |
| Velocidad (CPU) | Medir en benchmark |
| Código válido | ✅ Sí |
| Tool calling | ✅ Sí |
| Licencia | Apache 2.0 |

---

**Hecho con ❤️ para trazabilidad total.** Cada paso queda registrado en este repositorio público.
