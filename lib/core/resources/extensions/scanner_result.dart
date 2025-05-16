import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/features/transfer/data/models/params/solana_pay.dart';
import 'package:solana/solana.dart';

extension ScannerResult on String? {
  SolanaPayUrl? get parseSolanaPayUrl {
    try {
      if (this == null) return null;

      AppLogger.log(this);

      // Check if the URL starts with 'solana:'
      if (!this!.toString().trim().startsWith('solana')) {
        AppLogger.log('Invalid Solana Pay URL: does not start with "solana:"');
        return null;
      }

      // Split the URL into the base part and query parameters
      final parts = this!.split('?');
      if (parts.length > 2) {
        AppLogger.log('Invalid Solana Pay URL: multiple question marks');
        return null;
      }

      // Extract recipient (address)
      final recipient = parts[0].replaceFirst('solana:', '').trim();
      if (recipient.isEmpty) {
        AppLogger.log('Invalid Solana Pay URL: missing recipient address');
        return null;
      }

      // If there are no query parameters, return just the recipient
      if (parts.length == 1 || parts[1].isEmpty) {
        return SolanaPayUrl(recipient: recipient);
      }

      // Parse query parameters
      final queryParams = Uri.splitQueryString(parts[1]);

      return SolanaPayUrl(
        recipient: recipient,
        amount: queryParams['amount'],
        splToken: queryParams['spl-token'],
        reference: queryParams['reference'],
        label: queryParams['label'],
        message: queryParams['message'],
        memo: queryParams['memo'],
      );
    } catch (e) {
      AppLogger.log('Error parsing Solana Pay URL: $e');
      return null;
    }
  }

  String? get parseWalletAddress {
    try {
      // Check if the string is null or empty
      if (this == null || this!.isEmpty) {
        return null;
      }

      // Validate the address by attempting to create an Ed25519HDPublicKey
      // This will throw an exception if the address is invalid
      final publicKey = Ed25519HDPublicKey.fromBase58(this!);

      // If we've made it here, the address is valid
      // Return the validated base58 representation
      return publicKey.toBase58();
    } catch (e) {
      // If any exception occurs during parsing, the address is invalid
      AppLogger.log('Invalid Solana address: $e');
      return null;
    }
  }
}
