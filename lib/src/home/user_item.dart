import 'package:flutter/material.dart';
import 'package:iwallet_case_study/src/domain/user.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showUserDetails(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[600]!,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: user.photo != null
                      ? FutureBuilder<ImageProvider>(
                          future: _loadImage(user.photo!.downloadUrl!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              );
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: Icon(Icons.error),
                              );
                            }
                            return CircleAvatar(
                              backgroundImage: snapshot.data,
                              radius: 30,
                            );
                          },
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.orange[200],
                          radius: 30,
                          child: Text(
                            user.name![0].toUpperCase(),
                          ),
                        ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      user.name!,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user.username!,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.chevron_right_sharp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<ImageProvider> _loadImage(String imageUrl) async {
    return NetworkImage(imageUrl);
  }

  void _showUserDetails(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                user.photo != null
                    ? Container(
                        // width: 100,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(user.photo!.downloadUrl!),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.yellow,
                        radius: 70,
                        child: Text(
                          user.name!.length >= 3
                              ? user.name!.substring(0, 3).toUpperCase()
                              : user.name![0].toUpperCase(),
                        ),
                      ),
                const SizedBox(height: 20),
                Text(
                  user.name!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('@${user.username}'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          const TextSpan(text: 'Email: '),
                          TextSpan(
                            text: user.email!,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Telefon: ${user.phone}'),
                    const SizedBox(height: 10),
                    Text(
                        'Adres: ${user.address!.suite} ${user.address!.street} ${user.address!.zipCode}'),
                    const SizedBox(height: 10),
                    Text('Şehir: ${user.address!.city}'),
                    const SizedBox(height: 10),
                    Text(
                        'Konum: ${user.address!.geo!.lat}/${user.address!.geo!.lng}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
