import read_as
import re
from collections import defaultdict

def get_surrounds(r, c, graph):
    occupied = 0
    for m in [-1, 0, 1]:
        if 0 <= r + m < len(graph):
            for n in [-1, 0, 1]:
                if 0 <= c + n < len(graph[0]):
                    if m == 0 and n == 0:
                        continue
                    occupied += graph[r+m][c+n] == "#"

    return occupied

def get_surrounds_see(r, c, graph):
    occupied = 0
    for m in [-1, 0, 1]:
        for n in [-1, 0, 1]:
            if m != 0 or n != 0:
                rr = r
                cc = c
                while True:
                    rr = rr + m
                    cc = cc + n
                    if rr < 0 or rr >= len(graph):
                        break
                    elif cc < 0 or cc >= len(graph[0]):
                        break
                    elif graph[rr][cc] == ".":
                        continue
                    else:
                        occupied += graph[rr][cc] == "#"
                        break

    return occupied


def update(graph):
    new_graph = [["X" for c in row] for row in graph]

    for r in range(len(graph)):
        for c in range(len(graph[r])):
            if graph[r][c] == ".":
                new_graph[r][c] = "."
            elif graph[r][c] == "L":
                if get_surrounds_see(r, c, graph) == 0: # was get_surrounds
                    new_graph[r][c] = "#"
                else:
                    new_graph[r][c] = "L"
            else:
                if get_surrounds_see(r,c,graph) >= 5: #was get_surrounds_see, was 4
                    new_graph[r][c] = "L"
                else:
                    new_graph[r][c] = "#"

    return new_graph

def run() -> (int, int):
    rows = read_as.lines("input/11.txt")
    graph = [[c for c in row] for row in rows]

    new_graph = update(graph)
    while graph != new_graph:
        graph = new_graph
        new_graph = update(new_graph)

    print(sum(row.count("#") for row in graph))

    return(False, False)

if __name__ == "__main__":
    print(run())