import 'package:flutter/material.dart';

class StatWidget extends StatelessWidget {
  final String label;
  final String? value; // Описание атрибута
  final int? count; // Количество атрибута
  final bool isValueBelow; // Управляет расположением value
  final VoidCallback? onIncrement; // Добавляем callback для кнопки "+"

  const StatWidget({
    super.key,
    required this.label,
    this.value,
    this.count,
    this.isValueBelow = false,
    this.onIncrement, // Принимаем callback
  });

  @override
  Widget build(BuildContext context) {
    return isValueBelow
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (value != null)
                Text(
                  value!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              if (count != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$count',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8), // Отступ между количеством и кнопкой
                    if (onIncrement != null)
                      GestureDetector(
                        onTap: onIncrement,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (value != null)
                    Text(
                      value!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  if (count != null)
                    Text(
                      '$count',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(width: 8), // Отступ между количеством и кнопкой
                  if (onIncrement != null)
                    GestureDetector(
                      onTap: onIncrement,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
  }
}
