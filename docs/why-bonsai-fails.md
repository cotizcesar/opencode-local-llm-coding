# Bonsai 27B 1-bit — Error confirmado

## Error real al cargar en Ollama

```
Error: 400 Bad Request: Field 'repeat_last_n': Value must be between 0 <= value <= 2147483647, but got -1
```

Este error ocurre tanto con `/api/generate` como con `/api/chat`. El Modelfile del modelo contiene `PARAMETER repeat_last_n -1`, que está fuera del rango válido (0 a 2147483647).

## Prueba con /api/generate

El modelo no puede siquiera inicializarse correctamente. Cuando se intentó generar código LRU Cache, devolvió **0 caracteres**.

## Especificaciones del modelo

| Campo | Valor |
|---|---|
| Nombre | wcamaralopes/bonsai-27b:latest |
| Tamaño | 3.8 GB |
| Quantización | Q1_0 (1-bit binario) |
| Familia | qwen35 |
| Parámetros | 26.9B |
| Contexto | 32,768 tokens |
| VRAM requerida | ~6.9 GB (se midió al intentar cargar) |

## ¿Por qué falla?

1. **`repeat_last_n = -1` inválido**: Bloquea la API de chat de Ollama (usada por OpenCode para tool calling)
2. **Template insuficiente**: `TEMPLATE {{ .Prompt }}` — sin system prompt, sin formato de instrucción
3. **Compresión 1-bit**: Pesos binarios {−1, +1} degradan la calidad de generación de código

## Conclusión

Bonsai 27B 1-bit **no es usable** como asistente de programación con OpenCode. No se recomienda para esta máquina ni para ningún caso de uso de coding agent.
