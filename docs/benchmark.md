# Resultados de benchmark — RTX 5070 Ti 16 GB VRAM

> Esta sección se llena con mediciones REALES ejecutadas en esta máquina mediante `scripts/benchmark.sh`. No son estimaciones de terceros.

## Estado de las pruebas

| Modelo | Estado | VRAM carga | VRAM genera | Velocidad | TTFT | Código válido | Tool calling | Veredicto |
|---|---|---|---|---|---|---|---|---|
| Qwen3 14B | ⏳ Descargando (99%) | — | — | — | — | — | — | Pendiente |
| Qwen 2.5 Coder 14B | ⏳ Descargando (91%) | — | — | — | — | — | — | Pendiente |
| Gemma 4 12B | ⏳ Descargando (53%) | — | — | — | — | — | — | Pendiente |
| Bonsai 27B Q4_K_M | ⏳ Descargando (3%) | — | — | — | — | — | — | Pendiente |

## Cómo reproducir

```bash
./scripts/benchmark.sh
```

## Ganador

Por determinar tras las pruebas reales. Se elegirá el modelo que:
1. ✅ Cabe en ≤14 GB VRAM (dejando ≥2 GB para contexto)
2. ✅ Genera ≥30 tok/s
3. ✅ Genera código válido y ejecutable
4. ✅ Soporta tool calling con OpenCode

## Respuestas individuales

Véase `docs/benchmark-results/` (una carpeta por modelo con su respuesta de código).
