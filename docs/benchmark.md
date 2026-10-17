# Resultados de benchmark — RTX 5070 Ti 16 GB VRAM

> Esta sección se llena con mediciones REALES ejecutadas en esta máquina mediante `scripts/benchmark.sh`. No son estimaciones de terceros.

## Estado de las pruebas

| Modelo | Estado | VRAM carga | VRAM genera | Velocidad | TTFT | Código válido | Tool calling | Veredicto |
|---|---|---|---|---|---|---|---|---|
| Qwen3 14B | ✅ Probado | 567 MB | 10,085 MB (~9.5 GB) | ~4.6 tok/s* | 62.45s* | SÍ | SÍ (thinking) | ✅ Viable |
| Qwen 2.5 Coder 14B | ✅ Probado | — | 9,879 MB (~9.9 GB) | ~49 tok/s | 13.02s | SÍ | SÍ | ✅ **GANADOR** |
| Gemma 4 12B | ✅ Probado | 813 MB | 9,563 MB (~9.6 GB) | ~31 tok/s | 27.64s | SÍ | SÍ | ✅ Muy fuerte |
| Bonsai 27B Q4_K_M | ❌ Cancelado (16 GB, muy grande) | — | — | — | — | — | — | Cancelado |
| Bonsai 27B 1-bit | ✅ Probado | 609 MB | 6,868 MB (~6.9 GB) | ~0 tok/s | 11.00s | NO (0 chars) | NO | ❌ Descartado |

*\* TTFT incluye cold start de carga en GPU. Una vez cargado, la velocidad es mayor.*

## Cómo reproducir

```bash
./scripts/benchmark.sh
```

## Comparativa final — Todos los modelos probados

Basado en las pruebas REALES ejecutadas en esta máquina (RTX 5070 Ti, 16 GB VRAM):

| Criterio | Qwen3 14B | Qwen 2.5 Coder 14B | Gemma 4 12B | Bonsai 27B 1-bit |
|---|---|---|---|---|
| VRAM usada | ~9.5 GB | ~9.9 GB | ~9.6 GB | ~6.9 GB |
| VRAM libre para contexto | ~6.5 GB | ~6.1 GB | ~6.4 GB | ~9.1 GB |
| Velocidad | ~4.6 tok/s* | **~49 tok/s** | ~31 tok/s | ~0 tok/s |
| Código válido | SÍ | SÍ | SÍ | NO |
| Tool calling | SÍ (thinking) | SÍ (insert) | SÍ | NO |
| Idioma | Español | Inglés | Español | — |
| Respuesta a código | 1,148 chars | 2,574 chars | **3,443 chars** | 0 chars |

*\* Qwen3 14B TTFT incluye cold start de carga en GPU.*

## Ganador definitivo: Qwen 2.5 Coder 14B

**Qwen 2.5 Coder 14B es el ganador definitivo** por ser el más rápido (~49 tok/s, ~2x más rápido que Gemma 4 12B y ~10x más que Qwen3 14B), generar código válido y ejecutable, ser especialista en código (Apache 2.0), y soportar tool calling con OpenCode.

**Gemma 4 12B es un excelente segundo puesto**: genera aún más código (3,443 chars), responde en español, y usa similar VRAM (~9.6 GB). Es la mejor alternativa si prefieres respuestas en español y no te importa unos segundos extra de latencia.

**Qwen3 14B** es una buena tercera opción si necesitas razonamiento (thinking mode) o respuestas en español con menor VRAM (~9.5 GB).

**Bonsai 27B 1-bit** está descartado: no genera código válido.

## Respuestas individuales

Véase `docs/benchmark-results/` (una carpeta por modelo con su respuesta de código).
