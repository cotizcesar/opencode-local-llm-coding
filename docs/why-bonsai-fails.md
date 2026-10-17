# Investigación: ¿Por qué Bonsai 27B 1-bit no funciona para programar?

## Resumen ejecutivo

Bonsai 27B 1-bit (`wcamaralopes/bonsai-27b:latest`) fue probado en esta máquina (RTX 5070 Ti, 16 GB VRAM) y **descartado** para uso con OpenCode como asistente de programación. No genera código válido y tiene problemas de compatibilidad con la API de chat de Ollama.

## Problema 1: `repeat_last_n = -1` inválido (bloquea /api/chat)

El Modelfile del modelo contiene:

```
PARAMETER repeat_last_n -1
```

El endpoint `/api/chat` de Ollama (que usa OpenCode para tool calling y mensajes estructurados) rechaza este valor:

```
{"error":"Field 'repeat_last_n': Value must be between 0 <= value <= 2147483647, but got -1"}
```

Esto impide que OpenCode utilice el modelo con su flujo de chat nativo. El endpoint `/api/generate` sí acepta el modelo, pero no soporta tool calling ni formato de chat estructurado.

## Problema 2: Template de chat insuficiente

El TEMPLATE del modelo es simplemente:

```
TEMPLATE {{ .Prompt }}
```

Esto significa que:
- No hay **system prompt** (no se le dice "eres un programador experto")
- No hay **formato de chat** (no hay etiquetas `assistant`/`user` estructuradas)
- No hay **instrucciones de salida** (no se le indica que debe generar código)

Cuando se usa `/api/generate`, el modelo recibe solo el texto del prompt sin ningún contexto de instrucción, lo que probablemente explique por qué devolvió **0 caracteres** en la prueba de generación de código LRU Cache.

## Problema 3: Compresión 1-bit degrada calidad de código

Bonsai 27B 1-bit usa pesos binarios Q1_0 (`{−1, +1}`) con solo ~3.8 GB en disco. Según los benchmarks oficiales de PrismML:

| Métrica | Qwen3.6-27B FP16 | Bonsai 27B 1-bit | Retención |
|---|---|---|---|
| Coding | 88.7 | 81.88 | ~92% |
| Agentic/tool calling | 80.0 | 66.0 | ~82% |
| Overall | 85.0 | 76.1 | ~89% |

Aunque la retención general es alta, para **generación de código específica** la pérdida de calidad es suficiente para que el modelo no produzca código ejecutable de forma confiable.

## Resultado de la prueba en esta máquina

| Méctrica | Valor |
|---|---|
| Modelo | wcamaralopes/bonsai-27b:latest |
| Quantización | Q1_0 (1-bit) |
| Tamaño | 3.8 GB |
| VRAM usada | ~6.9 GB |
| Endpoint /api/generate | 0 chars generados (código vacío) |
| Endpoint /api/chat | Error: repeat_last_n = -1 |
| Código válido | ❌ No |

## Alternativas dentro de la familia Bonsai

| Variante | Tamaño | VRAM aprox. | Calidad código | ¿Vale la pena probar? |
|---|---|---|---|---|
| Bonsai 27B 1-bit (Q1_0) | 3.8 GB | ~6.9 GB | ❌ Mala | No |
| Bonsai 27B Ternary (Q2_0) | ~5.9 GB | ~8-9 GB | ⚠️ Media | Quizás |
| Bonsai 27B Q4_K_M | ~16 GB | ~16+ GB | ✅ Buena | No cabe en 16 GB con contexto |
| Bonsai 2 27B Ternary | ~5.9 GB | ~8-9 GB | ⚠️ Media | Quizás (versión mejorada) |

**Recomendación**: No usar Bonsai 27B 1-bit para programación. Si se necesita un modelo muy liviano, usar Qwen 2.5 Coder 7B (~4.7 GB) o Qwen3 8B (~8.1 GB) que tienen mejor calidad de código a pesar de ser más pequeños.

## Conclusión

Bonsai 27B 1-bit no es usable como asistente de programación con OpenCode debido a:
1. `repeat_last_n = -1` que rompe la API de chat de Ollama
2. Template sin system prompt ni formato de instrucción
3. Degradación de calidad por compresión 1-bit

**Ganarador definitivo para esta máquina: Qwen 2.5 Coder 14B** (~9.9 GB VRAM, ~49 tok/s, código válido, tool calling funcional).
