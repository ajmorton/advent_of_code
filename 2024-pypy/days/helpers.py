
class Tup:
    _tuple = (1,)

    def __init__(self, *vals):
        self._tuple = tuple(vals)

    def __add__(self, other):
        if len(self._tuple) != len(other._tuple):
            print(f"inval lenths when adding {self}, {other}")
        else:
            return Tup(*(self._tuple[i] + other._tuple[i] for i in range(len(self._tuple))))

    def __mul__(self, m):
        return Tup(*(m * self._tuple[i] for i in range(len(self._tuple))))

    def __rmul__(self, m):
        return Tup(*(m * self._tuple[i] for i in range(len(self._tuple))))

    def __repr__(self):
        return "Tup" + str(self._tuple)

    def __eq__(self, other):
        return self._tuple == other._tuple

    def __lt__(self, other):
        return self._tuple < other._tuple

    def __getitem__(self, key):
        return self._tuple[key]

    def __hash__(self):
        return self._tuple.__hash__()

# Tuple indexable array
class Grid:
    _grid = []

    def __init__(self, grid):
        self._grid = grid

    def __getitem__(self, key):
        g = self._grid

        if isinstance(key, Tup):
            key = key._tuple

        if isinstance(key, tuple):
            for v in key:
                g = g[v]
            return g
        elif isinstance(key, int):
            return self._grid[key]
        else:
            print("Unsupported index type: ", type(key))
            exit(1)

    def __contains__(self, key) -> bool:
        g = self._grid

        if isinstance(key, Tup):
            key = key._tuple

        if isinstance(key, tuple):
            for v in key:
                if 0 <= v < len(g):
                    g = g[v]
                else:
                    return False
            return True
        else:
            print("Unsupported index type: ", type(key))
            exit(1)

    def find2D(self, target) -> (int, int):
        for r, row in enumerate(self._grid):
            for c, cell in enumerate(row):
                if cell == target:
                    return Tup(r, c)
        return None

    def __repr__(self):
        s = ""
        for row in self._grid:
            for cell in row:
                s += str(cell)
            s += '\n'
        return s