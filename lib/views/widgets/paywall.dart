import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';





class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({Key? key, required this.offering}) : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[

            const Padding(
              padding:
              EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Unscroll premium',
                ),
              ),
            ),
            ListView.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (BuildContext context, int index) {
                var myProductList = widget.offering.availablePackages;
                return Card(

                  child: ListTile(
                      onTap: () async {
                        try {

                          await Purchases.purchasePackage(
                              myProductList[index]);


                          //
                          // appData.entitlementIsActive = customerInfo
                          //     .entitlements.all[entitlementID].isActive;
                        } catch (e) {
                          print(e);
                        }

                        setState(() {});
                        Navigator.pop(context);
                      },
                      title: Text(
                        myProductList[index].storeProduct.title,

                      ),
                      subtitle: Text(
                        myProductList[index].storeProduct.description,

                      ),
                      trailing: Text(
                          myProductList[index].storeProduct.priceString,
                         ),
                ),
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            ),
            const Padding(
              padding:
              EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "You can also restore your purchase if you've already bought it.",

                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}