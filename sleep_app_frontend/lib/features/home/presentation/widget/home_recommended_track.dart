import 'package:flutter/material.dart';

class RecommendedTrack extends StatelessWidget {
  final Size size;

  const RecommendedTrack({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: size.width * 0.9,
      height: 550,
      child: Column(
        children: [
          Text(
            'Sleep Quality',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFDFBBE4),
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) {
                return Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Day ${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDFBBE4),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
