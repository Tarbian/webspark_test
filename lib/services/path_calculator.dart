import 'dart:collection';
import 'package:webspark_test/models/grid_cell.dart';

class PathCalculator {
  List<List<String>> _grid = [];
  int _rows = 0;
  int _cols = 0;

  List<GridCell> findShortestPath(List<List<String>> grid, GridCell start, GridCell end) {
    _grid = grid;
    _rows = grid.length;
    _cols = grid[0].length;

    Queue<List<GridCell>> queue = Queue();
    Set<String> visited = {};

    queue.add([start]);
    visited.add('${start.x},${start.y}');

    while (queue.isNotEmpty) {
      List<GridCell> path = queue.removeFirst();
      GridCell current = path.last;

      if (current.x == end.x && current.y == end.y) {
        return path;
      }

      for (GridCell neighbor in _getValidNeighbors(current)) {
        String key = '${neighbor.x},${neighbor.y}';
        if (!visited.contains(key)) {
          visited.add(key);
          List<GridCell> newPath = List.from(path)..add(neighbor);
          queue.add(newPath);
        }
      }
    }

    return [];
  }

  List<GridCell> _getValidNeighbors(GridCell cell) {
    List<GridCell> neighbors = [];
    List<List<int>> directions = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1],           [0, 1],
      [1, -1],  [1, 0],  [1, 1]
    ];

    for (var dir in directions) {
      int newX = cell.x + dir[0];
      int newY = cell.y + dir[1];

      if (_isValidCell(newX, newY)) {
        neighbors.add(GridCell(newX, newY));
      }
    }

    return neighbors;
  }

  bool _isValidCell(int x, int y) {
    return x >= 0 && x < _rows && y >= 0 && y < _cols && _grid[x][y] != 'X';
  }
  
  Future<Map<String, dynamic>> calculateShortestPath(dynamic task) async {

    List<List<String>> grid = (task['field'] as List<dynamic>).map((row) => 
      (row as String).split('').toList()
    ).toList();

    dynamic start = task['start'];
    dynamic end = task['end'];

    GridCell startCell;
    GridCell endCell;

    startCell = GridCell(start['x'] as int, start['y'] as int);
    endCell = GridCell(end['x'] as int, end['y'] as int);

    List<GridCell> path = findShortestPath(grid, startCell, endCell);

    List<Map<String, int>> steps = path.map((cell) => {'x': cell.x, 'y': cell.y}).toList();
    String pathString = path.map((cell) => '(${cell.x},${cell.y})').join('->');

    return {
      'id': task['id'],
      'result': {
        'steps': steps,
        'path': pathString,
      },
    };
  }
}