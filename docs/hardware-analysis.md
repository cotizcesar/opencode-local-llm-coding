# Hardware Analysis — llama.cpp (CPU)

## Especificaciones detectadas

| Componente | Valor |
|---|---|
| CPU | AMD Ryzen 7 9800X3D — 8C/16T, hasta 5.27 GHz |
| GPU | NVIDIA GeForce RTX 5070 Ti — 16 GB VRAM |
| RAM | 30 GB |

## Limitación actual

Este sistema (Bazzite/Fedora Atomic) no tiene CUDA Toolkit (`nvcc`) instalado. Por lo tanto:

- **llama.cpp compila en modo CPU** (sin aceleración GPU)
- Los modelos correrán en CPU, no en GPU
- La velocidad será menor que con CUDA

## Para usar GPU (opcional)

Si instalas CUDA Toolkit y recompilas llama.cpp con `GGML_CUDA=ON`, podrías aprovechar los 16 GB VRAM de la RTX 5070 Ti para inferencia mucho más rápida.

## Estimación de VRAM/RAM por modelo

| Modelo | Tamaño Q4 | Cabe en 16 GB VRAM? | Cabe en 30 GB RAM? |
|---|---|---|---|
| Qwen 2.5 Coder 14B Q4 | ~9 GB | ✅ Sí | ✅ Sí |
| Qwen3 14B Q4 | ~9.3 GB | ✅ Sí | ✅ Sí |
| Gemma 4 12B Q4 | ~8 GB | ✅ Sí | ✅ Sí |
| Qwen3 32B Q4 | ~20 GB | ❌ No | ✅ Sí (en RAM) |
| Qwen 2.5 Coder 32B Q4 | ~19 GB | ❌ No | ✅ Sí (en RAM) |
