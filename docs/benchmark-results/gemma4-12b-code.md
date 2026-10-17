# Gemma 4 12B — Respuesta de código (LRU Cache)

```python
from typing import Any, Dict, Optional


class Node:
    """Nodo para la lista doblemente enlazada."""
    def __init__(self, key: Any, value: Any):
        self.key: Any = key
        self.value: Any = value
        self.prev: Optional[Node] = None
        self.next: Optional[Node] = None


class LRUCache:
    """
    Implementación de un caché LRU con operaciones get y put en O(1).
    Utiliza un diccionario para acceso O(1) y una lista doblemente enlazada
    para mantener el orden de uso.
    """
    def __init__(self, capacidad: int):
        self.capacidad = capacidad
        self.cache: Dict[Any, Node] = {}
        self.cabeza = Node(None, None)  # Nodo fantasma (más reciente)
        self.cola = Node(None, None)    # Nodo fantasma (menos reciente)
        self.cabeza.next = self.cola
        self.cola.prev = self.cabeza

    def _agregar_al_frente(self, nodo: Node):
        """Agrega un nodo justo después de la cabeza (más reciente)."""
        nodo.prev = self.cabeza
        nodo.next = self.cabeza.next
        self.cabeza.next.prev = nodo
        self.cabeza.next = nodo

    def _remover_nodo(self, nodo: Node):
        """Remueve un nodo de la lista doblemente enlazada."""
        prev = nodo.prev
        nxt = nodo.next
        prev.next = nxt
        nxt.prev = prev

    def _mover_al_frente(self, nodo: Node):
        """Mueve un nodo existente al frente de la lista."""
        self._remover_nodo(nodo)
        self._agregar_al_frente(nodo)

    def _evictar_menos_reciente(self):
        """Elimina el nodo menos recientemente usado (antes de la cola)."""
        nodo = self.cola.prev
        self._remover_nodo(nodo)
        del self.cache[nodo.key]

    def get(self, clave: Any) -> Any:
        """
        Obtiene el valor asociado a la clave.
        Retorna None si la clave no existe.
        """
        if clave not in self.cache:
            return None
        nodo = self.cache[clave]
        self._mover_al_frente(nodo)
        return nodo.value

    def put(self, clave: Any, valor: Any):
        """
        Inserta o actualiza un par clave-valor.
        Si el caché excede su capacidad, elimina el elemento menos usado.
        """
        if clave in self.cache:
            nodo = self.cache[clave]
            nodo.valor = valor
            self._mover_al_frente(nodo)
            return

        nuevo = Node(clave, valor)
        self.cache[clave] = nuevo
        self._agregar_al_frente(nuevo)

        if len(self.cache) > self.capacidad:
            self._evictar_menos_reciente()


# Ejemplo de uso
if __name__ == "__main__":
    lru = LRUCache(2)
    lru.put(1, 1)
    lru.put(2, 2)
    print(lru.get(1))    # 1
    lru.put(3, 3)        # expulsa clave 2
    print(lru.get(2))    # None
    lru.put(4, 4)        # expulsa clave 1
    print(lru.get(1))    # None
    print(lru.get(3))    # 3
    print(lru.get(4))    # 4
```

**Métricas:** Tiempo: 27.64s | Chars: 3,443 | VRAM: ~9.6 GB | def/class: 8 | Idioma: Español

**Fortalezas:** Genera más código que Qwen 2.5 Coder 14B, implementación completa con lista doblemente enlazada, respuesta en español.
**Debilidades:** Más lento (27.64s vs 13.02s de Qwen 2.5 Coder 14B).
