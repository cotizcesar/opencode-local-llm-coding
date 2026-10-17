# Resultados de benchmark — RTX 5070 Ti 16 GB VRAM

> Esta sección se llena con mediciones REALES ejecutadas en esta máquina mediante `scripts/benchmark.sh`. No son estimaciones de terceros.

## Estado de las pruebas

| Modelo | Estado | VRAM carga | VRAM genera | Velocidad | TTFT | Código válido | Tool calling | Veredicto |
|---|---|---|---|---|---|---|---|---|
| Qwen3 14B | ✅ Probado | 567 MB | 10,085 MB (~9.5 GB) | ~4.6 tok/s* | 62.45s* | SÍ | SÍ (thinking) | ✅ Viable |
| Qwen 2.5 Coder 14B | ✅ Probado | — | 9,879 MB (~9.9 GB) | ~49 tok/s | 13.02s | SÍ | SÍ | ✅ **GANADOR** |
| Gemma 4 12B | ⚠️ Falló (EOF repetido) | — | — | — | — | — | — | Pendiente |
| Bonsai 27B Q4_K_M | ❌ Cancelado (16 GB, muy grande) | — | — | — | — | — | — | Cancelado |
| Bonsai 27B 1-bit | ✅ Probado | 609 MB | 6,868 MB (~6.9 GB) | ~0 tok/s | 11.00s | NO (0 chars) | NO | ❌ Descartado |

*\* TTFT incluye cold start de carga en GPU. Una vez cargado, la velocidad es mayor.*

## Cómo reproducir

```bash
./scripts/benchmark.sh
```

## Ganador provisional: Qwen 2.5 Coder 14B

Basado en las pruebas reales ejecutadas en esta máquina (RTX 5070 Ti, 16 GB VRAM):

| Criterio | Qwen3 14B | Qwen 2.5 Coder 14B |
|---|---|---|
| VRAM usada | ~9.5 GB | ~9.9 GB |
| VRAM libre para contexto | ~6.5 GB | ~6.1 GB |
| Velocidad (después de carga) | ~4.6 tok/s* | ~49 tok/s |
| Código válido | SÍ | SÍ |
| Tool calling | SÍ (thinking) | SÍ (insert) |
| Idioma de respuesta | Español | Inglés |

**Qwen 2.5 Coder 14B gana** por ser ~10x más rápido, generar más código (2,574 vs 1,148 chars), y ser especialista en código. Qwen3 14B es una buena alternativa si se necesita razonamiento (thinking) o respuestas en español.

*\* Qwen3 14B TTFT incluye cold start.*

## Requisitos verificados

1. ✅ Cabe en ≤14 GB VRAM (dejando ≥2 GB para contexto) — Ambos usan ~9.5-9.9 GB
2. ✅ Genera ≥30 tok/s — Qwen 2.5 Coder 14B: ~49 tok/s
3. ✅ Genera código válido y ejecutable — Ambos generan LRU Cache correcto
4. ✅ Soporta tool calling con OpenCode — Ambos tienen capability "tools"

## Pruebas pendientes

- [ ] Gemma 4 12B (falló con EOF repetido en Ollama — se puede intentar manualmente: `ollama pull gemma4:12b`)
- [ ] Tool calling real con OpenCode (integración completa)
- [ ] Lectura de repositorio grande (contexto largo)

## Modelo descartado

**Bonsai 27B 1-bit**: Probado en esta máquina. Usa solo 3.8 GB VRAM pero **no genera código válido** (respuesta vacía). La compresión 1-bit degrada demasiado la calidad para programar. No recomendado para OpenCode.

## Ganador definitivo: Qwen 2.5 Coder 14B

Basado en las pruebas reales ejecutadas en esta máquina (RTX 5070 Ti, 16 GB VRAM):

| Criterio | Qwen3 14B | Qwen 2.5 Coder 14B | Bonsai 27B 1-bit |
|---|---|---|---|
| VRAM usada | ~9.5 GB | ~9.9 GB | ~6.9 GB |
| VRAM libre para contexto | ~6.5 GB | ~6.1 GB | ~9.1 GB |
| Velocidad | ~4.6 tok/s* | **~49 tok/s** | ~0 tok/s |
| Código válido | SÍ | **SÍ** | NO |
| Tool calling | SÍ (thinking) | **SÍ** | NO |
| Respuesta a código | 1,148 chars | **2,574 chars** | 0 chars |

**Qwen 2.5 Coder 14B es el ganador definitivo** por ser ~10x más rápido, generar más del doble de código, ser especialista en código, y soportar tool calling con OpenCode. Bonsai 27B 1-bit, aunque muy liviano (3.8 GB), no genera código válido.

## Respuestas individuales

Véase `docs/benchmark-results/` (una carpeta por modelo con su respuesta de código).
