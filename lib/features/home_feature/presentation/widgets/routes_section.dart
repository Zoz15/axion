import 'package:axion/core/constants.dart';
import 'package:axion/features/home_feature/presentation/widgets/chack_location.dart';
import 'package:axion/features/home_feature/presentation/widgets/route_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutesSection extends StatelessWidget {
  final RxList<Map<String, dynamic>> routes;
  final Function(int, Map<String, dynamic>) onDeleteRoute;

  const RoutesSection({
    required this.routes,
    required this.onDeleteRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Routes',
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w600, color: lightColor),
        ),
        SizedBox(height: 10),
        Obx(() {
          return routes.isEmpty
              ? SizedBox(
                  height: screenHeight / 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No routes saved yet',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        InkWell(
                          onTap: onTapChickLocation,
                          child: Text(
                            'Start cycling',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Color(0xff00A6ED),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: routes.length,
                  itemBuilder: (context, index) {
                    final route = routes[index];
                    return RouteCard(
                      route: route,
                      onDelete: () => onDeleteRoute(index, route),
                    );
                  },
                );
        }),
      ],
    );
  }
}
