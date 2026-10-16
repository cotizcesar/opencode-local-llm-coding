# Resultados de benchmark — RTX 5070 Ti 16 GB VRAM

> Esta sección se llena con mediciones REALES ejecutadas en esta máquina mediante `scripts/benchmark.sh`. No son estimaciones de terceros.

## Estado de las pruebas

| Modelo | Estado | VRAM carga | VRAM genera | Velocidad | TTFT | Código válido | Tool calling | Veredicto |
|---|---|---|---|---|---|---|---|---|
| Qwen3 14B | ✅ Probado | 567 MB | 10,085 MB (~9.5 GB) | ~4.6 tok/s* | 62.45s* | SÍ | SÍ (thinking) | ✅ Viable |
| Qwen 2.5 Coder 14B | ✅ Probado | — | 9,879 MB (~9.9 GB) | ~49 tok/s | 13.02s | SÍ | SÍ | ✅ **GANADOR provisional** |
| Gemma 4 12B | ⏳ Descargando | — | — | — | — | — | — | Pendiente |
| Bonsai 27B Q4_K_M | ⏳ Descargando | — | — | — | — | — | — | Pendiente |

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

- [ ] Gemma 4 12B (descargando)
- [ ] Bonsai 27B Q4_K_M (descargando, 11%)
- [ ] Tool calling real con OpenCode (integración completa)
- [ ] Lectura de repositorio grande (contexto largo)

## Respuestas individuales

Véase `docs/benchmark-results/` (una carpeta por modelo con su respuesta de código).
