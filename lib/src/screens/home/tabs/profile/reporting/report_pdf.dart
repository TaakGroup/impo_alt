import 'package:flutter/material.dart' as MT;
import 'package:flutter/services.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:share_plus/share_plus.dart';

Future<bool> reportView(context,limit,isShare) async {


  final Document pdf = Document();
  var data = await rootBundle.load("fonts/yekanBakh/YekanBakhFaNum-SemiBold.ttf");
  final ttf = Font.ttf(data);
  // final Uint8List fontData = File('IRANYekanMobileBold.ttf').readAsBytesSync();
  // final ttf = Font.ttf(fontData.buffer.asByteData());
  final directory = (await getApplicationDocumentsDirectory ()).path;
  final compareChartImage = MemoryImage(File('$directory/compareChart.jpg').readAsBytesSync());
  final timingChartImage = MemoryImage(File('$directory/timingChart.jpg').readAsBytesSync());
  final fileNameImpoLogo = MemoryImage(File('$directory/fileNameImpoLogo.jpg').readAsBytesSync());
  pdf.addPage(
      Page(

          pageFormat: PdfPageFormat.a4,
          theme: ThemeData.withFont(
            base: ttf,
          ),
          margin: EdgeInsets.only(
            top: 20,
            bottom: 15,
            left: 0,
            right: 0
          ),
          orientation: PageOrientation.landscape,
          build: (Context context) {
         return  new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(fileNameImpoLogo),
                Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: PdfColor.fromInt(0xffF0C1E0)
                    ),
                    child: Column(
                        children: [
                          Text(
                              'ایمپویی عزیز',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: PdfColor.fromInt(0xffC33091),
                              )
                          ),
                          Column(
                              children: [
                                Text(
                                    'این گزارش نشون دهنده ی زمان های پیش بینی شده و اتفاق افتاده ی پریود شماست.',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: PdfColor.fromInt(0xffC33091),
                                    )
                                ),
                                Text(
                                    'می‌تونی این گزارش رو برای خودت ذخیره کنی و یا برای پزشکت بفرستی',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: PdfColor.fromInt(0xffC33091),
                                    )
                                )
                              ]
                          )
                        ]
                    )
                ),
                Text(
                    'گزارش‌گیری $limit دوره',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: PdfColor.fromInt(0xffC33091)
                    )
                )
              ]
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 15
                  ),
                  child: Text(
                      'نمودار مقایسه‌ای',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: PdfColor.fromInt(0xff545454),
                      )
                  ),
                ),
                SizedBox(height: 8),
                Image(compareChartImage,width: 877,height: 620/2.5),
              ]
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:[
                Padding(
                  padding: EdgeInsets.only(
                      right: 15,
                      bottom: 10
                  ),
                  child:Text(
                      'جدول گزارش‌گیری',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: PdfColor.fromInt(0xff545454),
                      )
                  ),),
                Image(timingChartImage,width: 847,height: 620/4),
              ]
          )
        ]
    ); // Center
     }
    )
  ); //

  // save PDF

  //getExternalStorageDirectory
  //getApplicationDocumentsDirectory
   String dir;
  if(Platform.isAndroid){
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;
    if(sdkInt >= 24){
      print('getApplicationDocumentsDirectory');
     dir = (await getApplicationDocumentsDirectory()).path;
    }else{
      print('getExternalStorageDirectory');
     dir = (await getExternalStorageDirectory())!.path;
    }
  }else{
    dir = (await getApplicationDocumentsDirectory()).path;
  }
  final String path = '$dir/reporting-$limit-cycles.pdf';
  final File file = File(path);
  await file.writeAsBytes(await pdf.save());
  if(isShare){
    Share.shareFiles(['$dir/reporting-$limit-cycles.pdf'], text: 'reporting-$limit-cycles.pdf');
  }else{
    try{
      await OpenFile.open("$dir/reporting-$limit-cycles.pdf");
    }catch(e){
      //Fluttertoast.showToast(msg:'برنامه ای برای باز کردن pdf ندارید',toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM);
      CustomSnackBar.show(context, 'برنامه ای برای باز کردن pdf ندارید');
    }
  }


  return true;

}
