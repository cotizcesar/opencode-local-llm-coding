# Bonsai 27B 1-bit — Respuesta de código (LRU Cache)

**Resultado: DESCARTADO**

El modelo Bonsai 27B 1-bit (3.8 GB, versión `wcamaralopes/bonsai-27b:latest`) fue probado en esta máquina con el mismo prompt que los otros modelos:

> "Escribe una función Python de LRU Cache con get y put O(1), type hints, docstrings y ejemplo. Solo código."

**Respuesta:** Vacía (0 caracteres).

**Métricas:**
- Tiempo: 11.00s
- Chars generados: 0
- VRAM usada: ~6.9 GB (609 MB idle → 6,868 MB generando)
- Código válido: NO
- Tool calling: NO

**Conclusión:** La compresión 1-bit degrada demasiado la calidad para generación de código. Aunque es muy liviano (3.8 GB VRAM), no es usable como asistente de programación con OpenCode.

**Mejor alternativa en esta máquina:** Qwen 2.5 Coder 14B (~9.9 GB VRAM, ~49 tok/s, código válido).
