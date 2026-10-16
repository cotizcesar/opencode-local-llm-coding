# Qwen 2.5 Coder 14B — Respuesta de código (LRU Cache)

```python
from collections import OrderedDict

class LRUCache:
    def __init__(self, capacity: int):
        """
        Initialize the LRU Cache with a given capacity.
        
        :param capacity: Maximum number of items the cache can hold.
        """
        self.cache = OrderedDict()
        self.capacity = capacity

    def get(self, key: int) -> int:
        """
        Retrieve the value associated with the given key.
        Returns -1 if the key is not present.
        """
        if key not in self.cache:
            return -1
        self.cache.move_to_end(key)
        return self.cache[key]

    def put(self, key: int) -> None:
        """
        Insert or update the value associated with the given key.
        If the cache exceeds its capacity, evicts the least recently used item.
        """
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value
        if len(self.cache) > self.capacity:
            self.cache.popitem(last=False)


# Example usage
if __name__ == "__main__":
    lru = LRUCache(2)
    lru.put(1, 1)
    lru.put(2, 2)
    print(lru.get(1))    # 1
    lru.put(3, 3)        # evicts key 2
    print(lru.get(2))    # -1
    lru.put(4, 4)        # evicts key 1
    print(lru.get(1))    # -1
    print(lru.get(3))    # 3
    print(lru.get(4))    # 4
```

**Métricas:** Tiempo: 13.02s | Chars: 2,574 | VRAM: ~9.9 GB | def/class: 5
