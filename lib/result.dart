import 'package:flutter/material.dart';
import 'package:nyumba/filter.dart';
import 'package:nyumba/models/rental.dart';
import 'package:nyumba/property.dart';
import 'generated/l10n.dart';
import 'providers/spesnow_provider.dart';
import 'package:http/http.dart' as http;

class Result extends StatelessWidget {
  const Result({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          S.of(context).results,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const Filter()),
                ),
              );
            },
            icon: const Icon(Icons.filter_alt),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
          child: Column(
            children: [
              FutureBuilder<List<Rental>>(
                future:
                    SpesnowProvider().fetchCategoryRentals(http.Client(), id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    // print(snapshot.error);
                    return const Center(
                      child: Text('An error has occurred!'),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No rentals found'),
                      );
                    } else {
                      return RentalsList(rentals: snapshot.data!);
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RentalsList extends StatelessWidget {
  const RentalsList({super.key, required this.rentals});

  final List<Rental> rentals;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: rentals.length,
        itemBuilder: (context, index) {
          if (rentals[index].promoted == 0) {
             return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Property(id: rentals[index].id)),
              ),
              child: SizedBox(
                child: Card(
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/hero-img.jpg',
                          width: 100,
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(rentals[index].title),
                               Text(
                                'Ush ${rentals[index].price}',
                                style: const TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(children:  [
                                const Icon(Icons.location_pin),
                                Text(rentals[index].district),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          }
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Property(id: rentals[index].id)),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.brown),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/hero-img.jpg',
                              width: 100,
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(rentals[index].title),
                                   Text(
                                    'Ush ${rentals[index].price}',
                                    style: const TextStyle(
                                        color: Colors.brown,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children:  [
                                      const Icon(Icons.location_pin),
                                      Text(rentals[index].district),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('PROMOTED'),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
