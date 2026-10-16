# Análisis de hardware y por qué Qwen3 14B (RTX 5070 Ti, 16 GB VRAM)

## Especificaciones detectadas

| Componente | Valor | Relevancia para LLM local |
|---|---|---|
| GPU | NVIDIA GeForce RTX 5070 Ti — 16 GB VRAM, 896 GB/s bandwidth | **Cuello de botella principal**. Determina qué modelo cabe y a qué velocidad genera tokens. |
| CPU | AMD Ryzen 7 9800X3D — 8C/16T, hasta 5.27 GHz | Secundario para inferencia con GPU. Útil solo como fallback de CPU. |
| RAM | 30 GB | Soporta offloading de modelos que no quepan en VRAM, pero es lento (PCIe). |
| Swap | 15 GB | Respaldo, no recomendado para inferencia en caliente. |

## Cálculo de VRAM por modelo (estimado Q4_K_M + contexto)

Un modelo cuantizado Q4 ocupa aproximadamente `0.6 GB por billón de parámetros` en pesos, más el KV cache del contexto.

| Modelo | Pesos Q4 | Contexto OpenCode (128K aprox.) | Total estimado | ¿Cabe en 16 GB? |
|---|---|---|---|---|
| Qwen3 14B | ~8.9 GB | ~2-4 GB | ~11-13 GB | ✅ Sí, con margen |
| Qwen 2.5 Coder 14B | ~8.4 GB | ~2-4 GB | ~10-12 GB | ✅ Sí, con margen |
| Gemma 4 12B | ~7.2 GB | ~2-4 GB | ~9-11 GB | ✅ Sí, holgado |
| Devstral Small 2 24B | ~14.4 GB | ~2-4 GB | ~16-18 GB | ⚠️ Justo / puede no caber |
| Qwen3-Coder 30B (MoE) | ~18-19 GB | +contexto | ~20+ GB | ❌ No cabe |
| Qwen3.8 27B | ~16.4 GB | +contexto | ~18+ GB | ❌ No cabe |
| Gemma 4 31B | ~18.5 GB | +contexto | ~20+ GB | ❌ No cabe |
| Bonsai 27B (1-bit/ternario) | ~3.9-7.2 GB | ~2-4 GB | ~6-11 GB | ✅ Cabe, pero calidad reducida |

## Recomendación de ejecución

Usar Ollama con GPU (CUDA) por defecto. Ollama detecta automáticamente la NVIDIA 5070 Ti si los controladores están instalados.

Verificar antes de instalar:
```bash
nvidia-smi
# Debe mostrar la RTX 5070 Ti, 16303 MiB VRAM, driver CUDA 13.4
```

Velocidad estimada en RTX 5070 Ti (896 GB/s):
- 14B Q4: ~49-54 tok/s (ModelFit)
- 12B Q4: ~56-62 tok/s
- 8B Q4: ~74-87 tok/s

## ¿Por qué no el modelo más grande?

La diferencia entre un modelo que cabe en VRAM y uno que no es de **3 a 11 veces más lento** (offloading a CPU). Para un agente de programación que hace decenas de tool calls por sesión, esa diferencia es crítica. Qwen3 14B da la mejor calidad sin sacrificar velocidad.
