# Plan de pruebas y comparación de modelos

> Esta página registra el plan de pruebas reales que se ejecutarán en esta máquina (RTX 5070 Ti, 16 GB VRAM) para elegir el mejor modelo local para programar con OpenCode.

## Modelos a probar

| # | Modelo | Tipo | Parámetros | VRAM esperada (Q4) | Contexto | Licencia |
|---|---|---|---|---|---|---|
| 1 | Qwen3 14B | Denso | 14.8B | ~9.3 GB | 125K | Apache 2.0 |
| 2 | Qwen 2.5 Coder 14B | Denso (code-spec) | 14B | ~9 GB | 32K | Apache 2.0 |
| 3 | Gemma 4 12B | Denso (multimodal) | 11.95B | ~8 GB | 128K | Apache 2.0 |
| 4 | Bonsai 27B | Ternario (Qwen3.6) | 27B | ~7.2 GB | 262K | Apache 2.0 |

## Métricas a medir (script `scripts/benchmark.sh`)

1. **VRAM usada** tras cargar el modelo (MB) — ¿cuánto queda libre para contexto?
2. **Velocidad de generación** (tokens/segundo aproximada)
3. **Tiempo a primera respuesta** (TTFT)
4. **Calidad de código** — ¿genera código válido y ejecutable?
5. **Disponibilidad en Ollama** — ¿se puede bajar con `ollama pull`?

## Prueba funcional con OpenCode

Una vez elegido el modelo ganador:
- Configurar `opencode.json` con el modelo ganador
- Ejecutar `opencode`
- Usar `/models` para seleccionarlo
- Probar tool calling (leer archivo, escribir archivo, ejecutar comando)

## Criterio de decisión

El ganador debe:
1. Caber en ≤14 GB VRAM (dejando ≥2 GB para contexto KV cache)
2. Generar ≥30 tok/s (útil para agente interactivo)
3. Generar código válido y ejecutable
4. Soportar tool calling con OpenCode

Si hay empate, gana el que tenga mejor contexto y licencia más permisiva.

## Resultados

Se irán registrando aquí a medida que se ejecuten las pruebas. Véase `scripts/benchmark.sh` para las mediciones automatizadas.
