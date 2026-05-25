import 'package:flutter/material.dart';
import '../../thermal_printer_pkg.dart';

class BoletoWidget extends StatelessWidget {
  const BoletoWidget({
    super.key,
    required this.data,
    this.width = 384.0, // Default 58mm
  });

  final BoletoData data;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho Banco
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.banco ?? 'BOLETO BANCÁRIO',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
              ),
              Text(
                'Venc: ${data.vencimento.day.toString().padLeft(2, '0')}/${data.vencimento.month.toString().padLeft(2, '0')}/${data.vencimento.year}',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          const Divider(color: Colors.black, thickness: 1),
          
          // Beneficiário e Pagador
          _buildInfoField('Beneficiário', data.beneficiario),
          _buildInfoField('Pagador', data.pagador),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoField('Valor', 'R\$ ${data.valor.toStringAsFixed(2)}'),
              if (data.nossoNumero.isNotEmpty)
                _buildInfoField('Nosso Número', data.nossoNumero),
            ],
          ),

          if (data.instrucoes != null && data.instrucoes!.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Instruções:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12)),
            ),
            ...data.instrucoes!.map((i) => Text('- $i', style: const TextStyle(fontSize: 11, color: Colors.black))),
          ],

          const SizedBox(height: 12),
          const Center(child: Text('Linha Digitável', style: TextStyle(fontSize: 10, color: Colors.black))),
          Center(
            child: Text(
              data.linhaDigitavel,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          
          // Espaço reservado — barcode impresso nativamente via ESC/POS
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 13, color: Colors.black)),
        ],
      ),
    );
  }
}