import 'package:flutter/material.dart';
import 'package:template_app/template10/lib/features/todo/service/todo_service.dart';

class TodoStatisticsCard extends StatelessWidget {
  const TodoStatisticsCard({
    super.key,
    required this.statistics,
  });

  final TodoStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー
              Row(
                children: [
                  Icon(
                    Icons.analytics,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '統計情報',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 進捗バー
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '進捗',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${statistics.completionPercentage.toStringAsFixed(1)}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getProgressColor(
                              statistics.completionPercentage, theme),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: statistics.completionRate,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(statistics.completionPercentage, theme),
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 統計グリッド
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  _buildStatItem(
                    context,
                    icon: Icons.list_alt,
                    label: '総Todo数',
                    value: '${statistics.totalCount}',
                    color: theme.colorScheme.primary,
                  ),
                  _buildStatItem(
                    context,
                    icon: Icons.check_circle,
                    label: '完了済み',
                    value: '${statistics.completedCount}',
                    color: Colors.green,
                  ),
                  _buildStatItem(
                    context,
                    icon: Icons.radio_button_unchecked,
                    label: '未完了',
                    value: '${statistics.incompleteCount}',
                    color: Colors.orange,
                  ),
                  _buildStatItem(
                    context,
                    icon: Icons.today,
                    label: '今日作成',
                    value: '${statistics.todayCreatedCount}',
                    color: theme.colorScheme.secondary,
                  ),
                ],
              ),

              // 詳細情報（条件付き表示）
              if (statistics.totalCount > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getMotivationIcon(statistics.completionPercentage),
                        color: _getProgressColor(
                            statistics.completionPercentage, theme),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getMotivationMessage(
                              statistics.completionPercentage),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage, ThemeData theme) {
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 50) {
      return Colors.orange;
    } else if (percentage >= 25) {
      return theme.colorScheme.primary;
    } else {
      return Colors.red;
    }
  }

  IconData _getMotivationIcon(double percentage) {
    if (percentage >= 100) {
      return Icons.celebration;
    } else if (percentage >= 80) {
      return Icons.thumb_up;
    } else if (percentage >= 50) {
      return Icons.trending_up;
    } else if (percentage >= 25) {
      return Icons.directions_run;
    } else {
      return Icons.flag;
    }
  }

  String _getMotivationMessage(double percentage) {
    if (percentage >= 100) {
      return '素晴らしい！全てのTodoが完了しています 🎉';
    } else if (percentage >= 80) {
      return 'あと少しで完了です！頑張りましょう 💪';
    } else if (percentage >= 50) {
      return '順調に進んでいます！このペースで続けましょう ⭐';
    } else if (percentage >= 25) {
      return 'まだまだ頑張れます！一歩ずつ進めましょう 🚀';
    } else {
      return '新しいスタートです！今日から始めましょう ✨';
    }
  }
}
