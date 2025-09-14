import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dashboard_metrics_widget.dart';
import './widgets/exchange_rate_control_widget.dart';
import './widgets/fee_management_widget.dart';
import './widgets/merchant_oversight_widget.dart';
import './widgets/system_alerts_widget.dart';
import './widgets/transaction_monitoring_widget.dart';
import './widgets/user_management_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _drawerItems = [
    {
      "title": "Dashboard",
      "icon": "dashboard",
      "index": 0,
    },
    {
      "title": "User Management",
      "icon": "people",
      "index": 1,
    },
    {
      "title": "Merchant Oversight",
      "icon": "store",
      "index": 2,
    },
    {
      "title": "Transactions",
      "icon": "receipt_long",
      "index": 3,
    },
    {
      "title": "Exchange Rates",
      "icon": "currency_exchange",
      "index": 4,
    },
    {
      "title": "Fee Management",
      "icon": "payments",
      "index": 5,
    },
    {
      "title": "System Alerts",
      "icon": "warning",
      "index": 6,
    },
  ];

  final List<String> _tabTitles = [
    "Dashboard Overview",
    "User Management",
    "Merchant Oversight",
    "Transaction Monitor",
    "Exchange Rate Control",
    "Fee Management",
    "System Alerts",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });
    Navigator.of(context).pop();
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        title: Text(
          "Logout",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Are you sure you want to logout from admin panel?",
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/login-screen');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getErrorColor(),
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(Map<String, dynamic> item) {
    final isSelected = _selectedIndex == item["index"];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
              )
            : null,
      ),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: item["icon"] as String,
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 6.w,
        ),
        title: Text(
          item["title"] as String,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: () => _onDrawerItemTapped(item["index"] as int),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardMetricsWidget();
      case 1:
        return const UserManagementWidget();
      case 2:
        return const MerchantOversightWidget();
      case 3:
        return const TransactionMonitoringWidget();
      case 4:
        return const ExchangeRateControlWidget();
      case 5:
        return const FeeManagementWidget();
      case 6:
        return const SystemAlertsWidget();
      default:
        return const DashboardMetricsWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _tabTitles[_selectedIndex],
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: CustomIconWidget(
            iconName: 'menu',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 2.w),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'admin_panel_settings',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 5.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  "Admin",
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _logout,
            icon: CustomIconWidget(
              iconName: 'logout',
              color: AppTheme.getErrorColor(),
              size: 6.w,
            ),
          ),
        ],
        elevation: 2,
        shadowColor: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
      ),
      drawer: Drawer(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(4.w, 12.h, 4.w, 4.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.scaffoldBackgroundColor,
                    AppTheme.lightTheme.colorScheme.surface,
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'admin_panel_settings',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 10.w,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "CRYPTEX",
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    "Admin Panel",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                children:
                    _drawerItems.map((item) => _buildDrawerItem(item)).toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                    title: Text(
                      "Settings",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Settings feature coming soon"),
                          backgroundColor: AppTheme.lightTheme.primaryColor,
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'logout',
                      color: AppTheme.getErrorColor(),
                      size: 6.w,
                    ),
                    title: Text(
                      "Logout",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.getErrorColor(),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _buildCurrentTab(),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Refreshing dashboard data..."),
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                  ),
                );
              },
              child: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            )
          : null,
    );
  }
}
