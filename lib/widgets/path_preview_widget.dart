import 'package:flutter/material.dart';
import 'package:webspark_test/styles/app_text_styles.dart';

class PathPreviewWidget extends StatelessWidget {
  final List<List<String>> grid;
  final List<Map<String, int>> path;
  final Map<String, int> start;
  final Map<String, int> end;

  const PathPreviewWidget({super.key, 
    required this.grid,
    required this.path,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: grid[0].length,
            childAspectRatio: 1,
          ),
          itemCount: grid.length * grid[0].length,
          itemBuilder: (context, index) {
            int x = index ~/ grid[0].length;
            int y = index % grid[0].length;
            return _buildGridCell(x, y);
          },
        ),
        const SizedBox(height: 16),
        Text(
          _getPathString(),
          style: AppTextStyles.buttonText,
        ),
      ],
    );
  }

  Widget _buildGridCell(int x, int y) {
    Color cellColor = _getCellColor(x, y);
    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          '($x,$y)',
          style: TextStyle(
            color: cellColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Color _getCellColor(int x, int y) {
    if (x == start['x'] && y == start['y']) return const Color(0xFF64FFDA);
    if (x == end['x'] && y == end['y']) return const Color(0xFF009688);
    if (grid[x][y] == 'X') return Colors.black;
    if (path.any((step) => step['x'] == x && step['y'] == y)) return const Color(0xFF4CAF50);
    return Colors.white;
  }

  String _getPathString() {
    return path.map((step) => '(${step['x']},${step['y']})').join('->');
  }
}