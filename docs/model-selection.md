# Selección de modelo para llama.cpp

## Contexto

Este repositorio empieza desde 0 con **llama.cpp** como motor de inferencia local.

## Modelo seleccionado: Qwen 2.5 Coder 14B (Q4_K_M)

| Criterio | Valor |
|---|---|
| Parámetros | 14B |
| Quantización | Q4_K_M |
| Tamaño GGUF | ~9 GB |
| Contexto | 32K |
| Licencia | Apache 2.0 |
| VRAM (si GPU) | ~9.8 GB |
| RAM (CPU) | ~9.8 GB + overhead |

## ¿Por qué este modelo?

- Especializado en código (Qwen 2.5 Coder)
- Cabe en 16 GB VRAM con margen para contexto
- Buena calidad de generación de código
- Licencia Apache 2.0 permisiva

## Alternativas probadas anteriormente

Véase el historial del repositorio en GitHub para los resultados de Qwen3 14B, Gemma 4 12B, DeepSeek Coder V2 Lite 16B y Bonsai 27B 1-bit.
