import "package:flutter/material.dart";
import "../components/brand/list.dart";


class BrandPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BrandWidget();
  }
}

class BrandWidget extends StatefulWidget {
  @override
  _BrandWidgetState createState() => _BrandWidgetState();
}

class _BrandWidgetState extends State<BrandWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text("品牌街")
      ),
      body: BrandList(),
    );
  }
}

