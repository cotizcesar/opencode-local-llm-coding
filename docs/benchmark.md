# Resultados de benchmark — RTX 5070 Ti 16 GB VRAM

> Esta sección contiene mediciones REALES ejecutadas en esta máquina. Cada modelo fue probado individualmente, reiniciando Ollama entre pruebas para asegurar que solo un modelo esté cargado a la vez.

## Protocolo de prueba

- Hardware: NVIDIA RTX 5070 Ti (16 GB VRAM), AMD Ryzen 7 9800X3D
- Prompt idéntico para todos: "Escribe una función Python de LRU Cache con get y put O(1), type hints, docstrings y ejemplo. Solo código."
- Endpoint: Ollama `/api/generate` (no `/api/chat`, porque Bonsai falla en ese endpoint)
- VRAM medida con `nvidia-smi` antes de cargar y durante la generación

## Resultados medidos

| Modelo | VRAM carga | VRAM genera | Carga (s) | Generación (s) | Tok/s | Chars | Código válido | Idioma |
|---|---|---|---|---|---|---|---|---|
| **Qwen 2.5 Coder 14B** | 10,014 MB | 10,014 MB | 7.19 | 6.30 | 76.2 | 1,919 | ✅ SÍ (4) | Español |
| **Gemma 4 12B** | 9,717 MB | 9,649 MB | — | 12.95 | 53.0 | 2,743 | ✅ SÍ (5) | Inglés |
| **Qwen3 14B** | 10,176 MB | 10,220 MB | 11.11 | 28.32 | 12.1 | 1,375 | ✅ SÍ (4) | Inglés |
| **Bonsai 27B 1-bit** | ❌ Error | ❌ Error | — | — | — | 0 | ❌ No | — |

## Detalle por modelo

### Qwen 2.5 Coder 14B — GANADOR
- VRAM: ~9.8 GB (deja ~6.2 GB libres para contexto)
- Velocidad: ~76 tok/s (el más rápido)
- Código: LRU Cache completo y correcto en español
- Tool calling: SÍ (capability "tools" en Ollama)

### Gemma 4 12B — Segundo puesto
- VRAM: ~9.5 GB (deja ~6.5 GB libres para contexto)
- Velocidad: ~53 tok/s
- Código: LRU Cache completo en inglés
- Tool calling: SÍ

### Qwen3 14B — Tercera opción
- VRAM: ~9.9 GB (deja ~6.1 GB libres para contexto)
- Velocidad: ~12 tok/s (el más lento)
- Código: LRU Cache básico en inglés
- Tool calling: SÍ (con thinking)

### Bonsai 27B 1-bit — DESCARTADO
- Error real: `400 Bad Request: Field 'repeat_last_n': Value must be between 0 <= value <= 2147483647, but got -1`
- No se puede cargar en Ollama para uso con `/api/chat`
- Con `/api/generate` devolvió 0 caracteres
- VRAM: no se pudo medir (no carga)
- Compresión Q1_0 degrada calidad de código

## Veredicto

**Qwen 2.5 Coder 14B es el ganador definitivo** por ser el más rápido (~76 tok/s), generar código válido, usar menos VRAM que Qwen3 14B, y soportar tool calling con OpenCode.

**Gemma 4 12B es una excelente alternativa** si se prefiere más extensión de código (2,743 chars vs 1,919) y no importa unos segundos extra de latencia.

## Cómo reproducir

```bash
# Reiniciar Ollama para pruebas limpias
pkill -f "ollama serve"
ollama serve &

# Probar cada modelo
ollama run qwen2.5-coder:14b "Hola"
curl -s http://localhost:11434/api/generate -d '{"model":"qwen2.5-coder:14b","prompt":"TU PROMPT","stream":false}'
```
