# Benchmarks y resultados

> Esta sección se llenará con mediciones reales una vez que el modelo esté instalado y funcionando en esta máquina (RTX 5070 Ti, 16 GB VRAM).

## Pendiente de medir

- [ ] Tiempo de descarga del modelo `qwen2.5-coder:14b`
- [ ] VRAM usada en reposo y durante generación
- [ ] Tokens por segundo (prompt + generación)
- [ ] Latencia de primera respuesta (time-to-first-token)
- [ ] Prueba de tool calling con OpenCode
- [ ] Prueba de lectura de repositorio grande (contexto largo)

## Cómo medir

Ejecuta el script de verificación:
```bash
./scripts/verify.sh qwen-coder-local
```

O mide manualmente con Ollama:
```bash
time ollama run qwen-coder-local "Escribe un script de Python que lea un directorio y liste los archivos .py"
```

## Plantilla de resultados

| Métrica | Valor | Fecha |
|---|---|---|
| Descarga modelo | — | — |
| VRAM uso (idle) | — GB | — |
| VRAM uso (generando) | — GB | — |
| Tokens/segundo | — | — |
| Time-to-first-token | — ms | — |
| OpenCode tool calls | — | — |
