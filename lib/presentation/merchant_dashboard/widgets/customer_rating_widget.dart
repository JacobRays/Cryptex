import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomerRatingWidget extends StatelessWidget {
  final Map<String, dynamic> ratingData;
  final List<Map<String, dynamic>> recentFeedback;
  final Function(String, String) onRespondToFeedback;

  const CustomerRatingWidget({
    Key? key,
    required this.ratingData,
    required this.recentFeedback,
    required this.onRespondToFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final averageRating = ratingData['averageRating'] as double? ?? 0.0;
    final totalReviews = ratingData['totalReviews'] as int? ?? 0;
    final ratingDistribution =
        ratingData['distribution'] as Map<String, int>? ?? {};

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.getPrimaryColor().withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.getPrimaryColor().withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Rating',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.getPrimaryColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: AppTheme.lightTheme.textTheme.headlineLarge
                              ?.copyWith(
                            color: AppTheme.getSuccessColor(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: Text(
                            '/ 5.0',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 1.w),
                          child: CustomIconWidget(
                            iconName: index < averageRating.floor()
                                ? 'star'
                                : 'star_border',
                            color: AppTheme.getWarningColor(),
                            size: 5.w,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '$totalReviews reviews',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: List.generate(5, (index) {
                    final star = 5 - index;
                    final count = ratingDistribution[star.toString()] ?? 0;
                    final percentage =
                        totalReviews > 0 ? (count / totalReviews) : 0.0;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: Row(
                        children: [
                          Text(
                            '$star',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Container(
                              height: 1.h,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(0.5.h),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: percentage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.getWarningColor(),
                                    borderRadius: BorderRadius.circular(0.5.h),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            count.toString(),
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Recent Feedback',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          recentFeedback.isEmpty
              ? _buildNoFeedbackState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      recentFeedback.length > 3 ? 3 : recentFeedback.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final feedback = recentFeedback[index];
                    return _buildFeedbackCard(feedback);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildNoFeedbackState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'feedback',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'No recent feedback',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    final rating = feedback['rating'] as int? ?? 0;
    final comment = feedback['comment'] as String? ?? '';
    final customerName = feedback['customerName'] as String? ?? 'Anonymous';
    final date = feedback['date'] as String? ?? '';
    final hasResponse = feedback['hasResponse'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    customerName,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Row(
                    children: List.generate(5, (index) {
                      return CustomIconWidget(
                        iconName: index < rating ? 'star' : 'star_border',
                        color: AppTheme.getWarningColor(),
                        size: 3.w,
                      );
                    }),
                  ),
                ],
              ),
              Text(
                date,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Text(
              comment,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
          if (!hasResponse) ...[
            SizedBox(height: 2.h),
            GestureDetector(
              onTap: () => onRespondToFeedback(
                feedback['id'] as String? ?? '',
                customerName,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.getPrimaryColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.getPrimaryColor().withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'reply',
                      color: AppTheme.getPrimaryColor(),
                      size: 3.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Respond',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.getPrimaryColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
