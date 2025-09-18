-import 'package:flutter/material.dart';
-import 'package:cryptex_malawi/theme/app_colors.dart';
+import 'package:flutter/material.dart';
+import 'package:cryptex_malawi/theme/app_colors.dart';
+import 'package:cryptex_malawi/widgets/pin_modal.dart';
@@
-  void _showPinSheet(BuildContext context) {
-    showModalBottomSheet(
-      context: context,
-      backgroundColor: AppColors.surface,
-      shape: RoundedRectangleBorder(
-        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
-      ),
-      builder: (_) {
-        final pinCtrl = TextEditingController();
-        return Padding(
-          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
-          child: Column(
-            mainAxisSize: MainAxisSize.min,
-            children: [
-              Container(
-                height: 4,
-                width: 40,
-                decoration: BoxDecoration(
-                  color: AppColors.border,
-                  borderRadius: BorderRadius.circular(4),
-                ),
-              ),
-              const SizedBox(height: 12),
-              Text('Enter PIN to Confirm', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
-              const SizedBox(height: 12),
-              TextField(
-                controller: pinCtrl,
-                keyboardType: TextInputType.number,
-                obscureText: true,
-                maxLength: 6,
-                style: TextStyle(color: AppColors.textPrimary),
-                decoration: InputDecoration(
-                  counterText: '',
-                  hintText: '••••',
-                  hintStyle: TextStyle(color: AppColors.textSecondary),
-                ),
-              ),
-              const SizedBox(height: 12),
-              Row(
-                children: [
-                  Expanded(
-                    child: ElevatedButton(
-                      style: ElevatedButton.styleFrom(
-                        backgroundColor: AppColors.primary,
-                        padding: const EdgeInsets.symmetric(vertical: 14),
-                      ),
-                      onPressed: () {
-                        Navigator.pop(context);
-                        ScaffoldMessenger.of(context).showSnackBar(
-                          SnackBar(
-                            backgroundColor: AppColors.surface,
-                            content: Text('PIN verified. Sending…', style: TextStyle(color: AppColors.textPrimary)),
-                          ),
-                        );
-                      },
-                      child: Text('Confirm', style: TextStyle(color: Colors.white)),
-                    ),
-                  ),
-                  const SizedBox(width: 12),
-                  Expanded(
-                    child: ElevatedButton(
-                      style: ElevatedButton.styleFrom(
-                        backgroundColor: AppColors.error,
-                        padding: const EdgeInsets.symmetric(vertical: 14),
-                      ),
-                      onPressed: () => Navigator.pop(context),
-                      child: Text('Cancel', style: TextStyle(color: Colors.white)),
-                    ),
-                  ),
-                ],
-              ),
-            ],
-          ),
-        );
-      },
-    );
-  }
+  void _showPinSheet(BuildContext context) {
+    PinModal.show(
+      context,
+      onSubmit: (pin) {
+        // In a full flow, verify the PIN securely here
+        ScaffoldMessenger.of(context).showSnackBar(
+          SnackBar(
+            backgroundColor: AppColors.surface,
+            content: Text('PIN verified. Sending…', style: TextStyle(color: AppColors.textPrimary)),
+          ),
+        );
+      },
+    );
+  }
*** End Patch
