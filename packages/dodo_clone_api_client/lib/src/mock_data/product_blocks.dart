part of 'mock_data.dart';

final defaultList = productsDetails(false);
Map<String, dynamic> mockProducts(int cityId, bool isLoyalty) => {
      'error': false,
      'message': 'Successful',
      'result': [
        if (cityId == 2 || cityId == 1) defaultList[0],
        if (cityId == 2) defaultList[1],
        defaultList[2],
        if (cityId == 2 || cityId == 1) defaultList[3],
        if (cityId == 2) defaultList[4],
        if (cityId == 1) defaultList[5],
        defaultList[6],
        if (cityId == 1) defaultList[7],
        if (cityId == 1) defaultList[8],
        defaultList[9],
        defaultList[10],
        if (cityId == 2) defaultList[11],
        defaultList[12],
        defaultList[13],
        defaultList[14],
        defaultList[15],
        if (cityId == 2) defaultList[16],
        defaultList[17],
        defaultList[18],
        defaultList[19],
        defaultList[20],
        defaultList[21],
        defaultList[22],
        defaultList[23],
        if (cityId == 2) defaultList[24],
        defaultList[25],
        defaultList[26],
      ],
    };
