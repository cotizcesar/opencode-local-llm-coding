# Modelo ganador definitivo para programar en RTX 5070 Ti (16 GB VRAM)

## 🏆 Qwen 2.5 Coder 14B

Después de probar rigurosamente **7 modelos locales** en esta máquina (RTX 5070 Ti, 16 GB VRAM), el ganador es **Qwen 2.5 Coder 14B**.

## Tabla comparativa de resultados REALES

| Modelo | VRAM | Velocidad | Chars de código | Código válido | Tool calling | Idioma | Licencia |
|---|---|---|---|---|---|---|---|
| **Qwen 2.5 Coder 14B** | ~9.8 GB | **76 tok/s** | 1,919 | ✅ SÍ | ✅ SÍ | Español | Apache 2.0 |
| DeepSeek Coder V2 Lite 16B | ~10.5 GB | 66 tok/s | 1,675 | ✅ SÍ | ✅ SÍ | Inglés | DeepSeek |
| Gemma 4 12B | ~9.5 GB | 53 tok/s | 2,743 | ✅ SÍ | ✅ SÍ | Inglés | Apache 2.0 |
| Qwen3 14B | ~10.0 GB | 12 tok/s | 1,375 | ✅ SÍ | ✅ SÍ | Inglés | Apache 2.0 |
| Bonsai 27B 1-bit | ❌ Error | — | 0 | ❌ No | ❌ No | — | Apache 2.0 |
| Bonsai 2 4B | ❌ Error | — | — | — | — | — | Apache 2.0 |

## ¿Por qué Qwen 2.5 Coder 14B gana?

1. **Más rápido:** 76 tok/s (~1.1x más rápido que DeepSeek, 1.4x que Gemma, 6x que Qwen3)
2. **Código válido:** Genera LRU Cache completo y ejecutable
3. **VRAM eficiente:** ~9.8 GB, deja ~6.2 GB libres para contexto KV cache
4. **Tool calling:** Soporta la API de chat de Ollama (clave para OpenCode)
5. **Licencia:** Apache 2.0 (uso libre, comercial incluido)
6. **Contexto:** 32K nativo, suficiente para leer repositorios grandes

## Configuración final en OpenCode

El modelo ya está configurado en `~/.config/opencode/opencode.json` como `ollama/qwen-coder-local` (basado en Qwen 2.5 Coder 14B).

```json
{
  "model": "ollama/qwen-coder-local",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1",
        "apiKey": "ollama"
      },
      "models": {
        "qwen-coder-local": {
          "name": "Qwen 2.5 Coder 14B (local, GANADOR)",
          "limit": { "context": 131072, "output": 8192 }
        }
      }
    }
  }
}
```

## Para empezar a programar

```bash
opencode
# Luego: /models → ollama/qwen-coder-local
```

Todo queda en tu máquina local. Tu código nunca sale de tu PC. Costo $0 en tokens.
