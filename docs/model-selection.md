# Selección de modelo local para programación

> Investigación actualizada octubre 2026. Comparativa real de modelos locales que entran en **RTX 5070 Ti (16 GB VRAM)**.

## Contexto de hardware

| Componente | Especificación | Relevancia |
|---|---|---|
| GPU | NVIDIA RTX 5070 Ti — 16 GB VRAM, 896 GB/s bandwidth | **Cuello de botella principal** |
| CPU | AMD Ryzen 7 9800X3D — 8C/16T | Secundario para inferencia con GPU |
| RAM | 30 GB | Respaldo para modelos que no quepan en VRAM |

## Reglas de oro para elegir un modelo local en 16 GB VRAM

1. **VRAM es el límite, no la CPU.** Un modelo que no quepa en 16 GB se swappea a RAM del sistema por PCIe y cae de ~50 tok/s a ~1-5 tok/s. Inutilizable para un agente de programación.
2. **Deja margen para el KV cache y contexto.** OpenCode necesita contexto largo (mínimo 64K, ideal 128K+). Si el modelo ocupa los 16 GB de pesos, no queda espacio para contexto y el agente falla al leer repositorios grandes.
3. **Denso > ultra-comprimido para código.** Modelos binarios/ternarios (Bonsai 1-bit) entran en poca VRAM pero pierden calidad de código.
4. **Mínimo 14B denso** para code generation de calidad agentic.

## Candidatos evaluados (2026) — aptos para RTX 5070 Ti 16 GB

| Modelo | Tipo | Parámetros | VRAM Q4 | Contexto | Licencia | Coding Score (ref.) | Veredicto |
|---|---|---|---|---|---|---|---|
| **Qwen3 14B** | Denso | 14.8B | ~9.3 GB | 125K | Apache 2.0 | 95.9 (coding) | ✅ **TOP PICK** |
| Qwen 2.5 Coder 14B | Denso (code-spec) | 14B | ~9 GB | 32K | Apache 2.0 | ~90 (coding) | ✅ Especialista código |
| Qwen3.5 14B | Denso | 14B | ~9.3 GB | 125K | Apache 2.0 | 93.2-94.1 | ✅ Muy bueno |
| DeepSeek-R1 Distill Qwen 14B | Denso (reasoning) | 14B | ~9 GB | 32K+ | MIT | 93.9 (coding) | ⚠️ Más lento (razonamiento) |
| Gemma 4 12B | Denso (multimodal) | 11.95B | ~8 GB | 128K | Apache 2.0 | 31.7 / 92.2 general | ⚠️ Más débil en código puro |
| Devstral Small 2 24B | Denso (agent) | 24B | ~14-15 GB | 128K | Apache 2.0 | 96.5 (coding) | ⚠️ Justo en 16 GB, poco margen contexto |
| Qwen3-Coder 30B | MoE | 30.5B / 3.3B activo | ~19 GB | 256K | Apache 2.0 | 80-87 (coding) | ❌ **No cabe en 16 GB** |
| Qwen3.8 27B | Denso | 27.3B | ~17.6 GB | 1M | Apache 2.0 | alto | ❌ **No cabe en 16 GB** |
| Gemma 4 31B | Denso | 30.7B | ~17.5 GB Q4 | 262K | Gemma | alto | ❌ **No cabe en 16 GB** |
| Gemma 4 26B A4B | MoE | 26B / 3.8B activo | ~14.4 GB Q4 | 256K | Gemma | 39.3 coding index | ⚠️ Justo, sin margen contexto |
| Bonsai 27B (Ternary) | Binario/Ternario | 27B | ~3.9-7.2 GB | 262K | Apache 2.0 | 81.9-86.0 | ⚠️ Cabe, pero calidad reducida (1-bit) |
| Bonsai 2 27B (Ternary) | Ternario | 27.8B | ~5.9 GB | 262K | Apache 2.0 | ~83.9 aggregate | ⚠️ Idem, experimental |

### ¿Por qué no Qwen3-Coder 30B?
Es el mejor coder local publicado (SWE-bench ~80%), pero en Q4 necesita ~19 GB VRAM. En tu RTX 5070 Ti de 16 GB no cabe sin offloading a CPU, lo que destruye la velocidad. **Descartado para esta máquina.**

### ¿Por qué no Bonsai 27B?
Entra en 16 GB (3.9-7.2 GB) gracias a su compresión extrema (1-bit/ternario). Pero al ser binario/ternario pierde precisión en generación de código (coding 81.9-86 vs ~95 de Qwen3 14B). Es una opción interesante si necesitas máxima economía de VRAM, pero no es el mejor para programar.

### ¿Por qué Qwen3 14B como ganador?
- Caben en ~9.3 GB VRAM (Q4_K_M), dejando **~6-7 GB libres** para contexto KV cache —clave para que OpenCode lea tu repositorio entero sin truncar.
- Denso: calidad consistente, sin degradación por compresión ultra-agresiva.
- Apache 2.0: uso libre, comercial incluido.
- 125K contexto: suficiente para agente de código.
- Score de coding ~95.9 (llmconfigurator, RTX 5080/5070Ti guía, oct 2026).

## Modelo seleccionado: Qwen3 14B

**Qwen3:14b** es el mejor equilibrio capacidad/velocidad/VRAM para tu RTX 5070 Ti de 16 GB.

Alternativa si quieres un especialista puro en código: **Qwen 2.5 Coder 14b** (`qwen2.5-coder:14b`).

## Pruebas pendientes (se ejecutarán en esta máquina)

- [ ] Descargar y cargar Qwen3 14B, medir VRAM y tok/s
- [ ] Descargar y cargar Qwen 2.5 Coder 14B, medir VRAM y tok/s
- [ ] Descargar y cargar Gemma 4 12B, medir VRAM y tok/s
- [ ] Descargar y cargar Bonsai 27B (ternary), medir VRAM y tok/s
- [ ] Prueba de generación de código con cada modelo
- [ ] Prueba de tool calling con OpenCode
- [ ] Elegir el ganador y dejarlo configurado en OpenCode

## Fuentes

- https://llmconfigurator.com/en/best-models/rtx-5080 (RTX 5070/5080 Ti 16 GB guía, oct 2026)
- https://modelfit.io/gpu/rtx-5070-ti/ (ModelFit, RTX 5070 Ti 16 GB, oct 2026)
- https://www.orcarouter.ai/blog/best-local-llm-for-coding (Local LLM for Coding by VRAM, ago 2026)
- https://benchlm.ai/compare/gemma-4-31b-vs-qwen3-5-35b-a3b (Gemma 4 vs Qwen3.5, oct 2026)
- https://docs.prismml.com/models/bonsai-27b (Bonsai 27B specs y benchmarks)
- https://www.prnewswire.com/news-releases/prismml-launches-bonsai-2-27b (Bonsai 2 27B, sep 2026)
- https://ai.google.dev/gemma/docs/core (Gemma 4 model card, Google)
- https://ollama.com/library (Qwen3, Qwen2.5-Coder, Gemma4 en Ollama)
