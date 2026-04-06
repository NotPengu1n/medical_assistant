import 'package:flutter/material.dart';
import 'package:medical_assistant/src/network/synchronization.dart';

class ServicesReportPage extends StatefulWidget {
  const ServicesReportPage({super.key});

  @override
  State<ServicesReportPage> createState() => _ServicesReportPageState();
}

class _ServicesReportPageState extends State<ServicesReportPage> {
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  List<Map<String, dynamic>> _servicesData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServicesData();
  }

  Future<void> _fetchServicesData() async {
    setState(() {
      _isLoading = true;
    });

    final data = await Synchronization.getRenderedSessions(_selectedDateRange.start, _selectedDateRange.end);

    setState(() {
      _servicesData = data;
      _isLoading = false;
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  String _formatDateRange(DateTimeRange range) {
    return '${_formatDate(range.start)} - ${_formatDate(range.end)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Оказанные услуги',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          period(),

          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: tableHead(context),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                : _servicesData.isEmpty
                ? const Center(
              child: Text(
                'Нет данных за выбранный период',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : tableBody(context),
          ),
        ],
      ),
    );
  }

  Widget tableHead(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryCard(
          'Всего услуг',
          _servicesData.length.toString(),
          Icons.medical_services,
        ),
        _buildSummaryCard(
          'Всего сеансов',
          _servicesData.fold<int>(0, (sum, item) => sum + (item['КоличествоСеансов'] as num).toInt()).toString(),
          Icons.repeat,
        ),
        _buildSummaryCard(
          'Общая стоимость',
          '${_servicesData.fold<int>(0, (sum, item) => sum + (item['Стоимость'] as num).toInt())}',
          Icons.currency_ruble,
        ),
      ],
    );
  }

  Widget tableBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          //scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) => Colors.blue,
            ),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            dataRowMaxHeight: 48,
            columns: const [
              DataColumn(label: Text('Услуга')),
              DataColumn(label: Text('Сеансы'), numeric: true),
              DataColumn(label: Text('Стоимость'), numeric: true),
              DataColumn(label: Text('Проц. ед.'), numeric: true),
            ],
            rows: _servicesData.map((service) {
              final isPaid = service['фПлатная'] as bool;
              return DataRow(
                color: WidgetStateProperty.resolveWith<Color?>(
                      (states) => isPaid ? Colors.grey[50] : null,
                ),
                cells: [
                  DataCell(Text(
                    service['Услуга'],
                    style: const TextStyle(color: Colors.black),
                  )),
                  DataCell(Text(
                    '${service['КоличествоСеансов']}',
                    style: const TextStyle(color: Colors.black),
                  )),
                  DataCell(Text(
                    '${service['Стоимость']} ₽',
                    style: TextStyle(
                      color: (service['Стоимость'] as num) > 0 ? Colors.black : Colors.grey,
                    ),
                  )),
                  DataCell(Text(
                    service['ПроцедурныеЕдиницы'].toString(),
                    style: const TextStyle(color: Colors.black),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Виджет для вывода итога
  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Виджет с периодом
  Widget period() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.date_range, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Период',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  _formatDateRange(_selectedDateRange),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _selectDateRange(context),
            icon: const Icon(Icons.edit_calendar, size: 18),
            label: const Text('Выбрать'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


