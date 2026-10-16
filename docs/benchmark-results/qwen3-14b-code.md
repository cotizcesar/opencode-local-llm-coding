# Qwen3 14B — Respuesta de código (LRU Cache)

```python
from collections import OrderedDict

class LRUCache:
    """Implementación de un caché LRU con operaciones get y put en O(1)."""

    def __init__(self, capacity: int):
        """Inicializa el caché con una capacidad dada."""
        self.cache = OrderedDict()
        self.capacity = capacity

    def get(self, key: int) -> int:
        """Obtiene el valor asociado a la clave. Si no existe, devuelve -1."""
        if key not in self.cache:
            return -1
        self.cache.move_to_end(key)
        return self.cache[key]

    def put(self, key: int, value: int) -> None:
        """Inserta o actualiza el valor asociado a la clave. Si el caché está lleno, elimina el elemento menos usado."""
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value
        if len(self.cache) > self.capacity:
            self.cache.popitem(last=False)


# Ejemplo de uso
if __name__ == "__main__":
    lru = LRUCache(2)
    lru.put(1, 1)
    lru.put(2, 2)
    print(lru.get(1))    # 1
    lru.put(3, 3)        # expulsa clave 2
    print(lru.get(2))    # -1
    lru.put(4, 4)        # expulsa clave 1
    print(lru.get(1))    # -1
    print(lru.get(3))    # 3
    print(lru.get(4))    # 4
```

**Métricas:** Tiempo: 62.45s (incluye cold start) | Chars: 1,148 | VRAM: ~9.5 GB | def/class: 4
