import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/onboarding/presentation/widgets/tile.dart';

class WalletRecoveryOptions extends StatelessWidget {
  const WalletRecoveryOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Connect Wallet'),
      ),
      body: Column(
        children: [
          24.verticalSpace,
          CustomTile(
            icon: R.ASSETS_ICONS_ADD_SVG,
            title: 'Create new account',
            subtilte: 'Add a new multi-chain account',
          ),
          CustomTile(
            icon: R.ASSETS_ICONS_HARDWARE_SVG,
            title: 'Connect hardware wallet',
            subtilte: 'Add a new multi-chain account',
          ),
          CustomTile(
            icon: R.ASSETS_ICONS_PHRASE_SVG,
            title: 'Import recovery phrase',
            subtilte: 'Add a new multi-chain account',
            onTap: () {
              context.push(pRecoveryPhrase);
              HapticFeedback.lightImpact();
            },
          ),
          CustomTile(
            icon: R.ASSETS_ICONS_PRIVATE_KEY_SVG,
            title: 'Import private key',
            subtilte: 'Add a new multi-chain account',
            onTap: () {
              context.push(pPrivateKey);
              HapticFeedback.lightImpact();
            },
          ),
        ],
      ).padHorizontal,
    );
  }
}
