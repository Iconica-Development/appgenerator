import 'table_column.dart';
import 'table_item.dart';

//#pragma: imports
import 'package:flutter_table/flutter_table.dart';
import 'package:flutter/material.dart';

//#pragma: declaration
class HydroTable extends StatelessWidget {
  const HydroTable({
    required this.columns,
    required this.items,
    this.title = '',
  });

  final List<HydroTableColumn>
      columns; // first string is column name, second is the property in the items map that should be accessed for the itembuilder
  final String title;
  final List<HydroTableItem> items;

  @override
  Widget build(BuildContext context) {
    return FlutterTable<HydroTableItem>(
      tableDefinition: TableDefinition<HydroTableItem>(
        title: title,
        columns: [
          for (var column in columns) ...[
            TableColumn<HydroTableItem>(
              name: column.columnName,
              size: 1,
              itemBuilder: (context, item) {
                return Text(
                  item?.data[column.jsonAttribute],
                );
              },
            ),
          ],
        ],
      ),
      data: items,
    );
  }
}


//#pragma: execution
SizedBox(
  width: 500,
  height: 360,
  child: HydroTable(columns: [...columns], items: items, title: "[[title]]"),
),