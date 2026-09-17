import '../models/yard_model.dart';
import '../models/crop_model.dart';
import '../models/price_history_model.dart';
import '../models/shop_model.dart';
import '../models/user_model.dart';

class MockData {
  static List<YardModel> getYards() {
    return [
      YardModel(
        id: 'rajkot',
        name: 'Rajkot Marketing Yard',
        city: 'Rajkot',
        address: '150ft Ring Road, Rajkot, Gujarat 360005',
        contactNumber: '0281 2456789',
        totalShops: '250+ Shops',
        establishedYear: '1985',
        imageAsset: 'assets/images/yard_rajkot.png',
      ),
      YardModel(
        id: 'junagadh',
        name: 'Junagadh Marketing Yard',
        city: 'Junagadh',
        address: 'Dhoraji Road, Junagadh, Gujarat 362001',
        contactNumber: '0285 2654321',
        totalShops: '180+ Shops',
        establishedYear: '1978',
        imageAsset: 'assets/images/yard_junagadh.png',
      ),
      YardModel(
        id: 'gondal',
        name: 'Gondal Marketing Yard',
        city: 'Gondal',
        address: 'Jetpur Road, Gondal, Gujarat 360311',
        contactNumber: '02825 221234',
        totalShops: '220+ Shops',
        establishedYear: '1965',
        imageAsset: 'assets/images/yard_gondal.png',
      ),
      YardModel(
        id: 'mendarda',
        name: 'Mendarda Marketing Yard',
        city: 'Mendarda',
        address: 'Mendarda Main Road, Junagadh, Gujarat 362260',
        contactNumber: '02872 245367',
        totalShops: '95+ Shops',
        establishedYear: '1992',
        imageAsset: 'assets/images/yard_mendarda.png',
      ),
    ];
  }

  static List<CropRate> getCrops() {
    return [
      CropRate(
        id: 'wheat',
        name: 'Wheat',
        gujaratiName: 'Ghau',
        imageAsset: 'assets/images/crop_wheat.png',
        arrivalBags: 980,
        totalQuantityKg: 19600,
        minPrice: 620,
        avgPrice: 670,
        maxPrice: 720,
        changeAmount: 60,
        changePercentage: 9.84,
        isRise: true,
        lastUpdated: '21 May 2025, 08:30 AM',
        history: [
          PriceHistoryRecord(date: '20 May 2025', minPrice: 600, avgPrice: 650, maxPrice: 700),
          PriceHistoryRecord(date: '19 May 2025', minPrice: 590, avgPrice: 640, maxPrice: 690),
          PriceHistoryRecord(date: '18 May 2025', minPrice: 580, avgPrice: 630, maxPrice: 680),
          PriceHistoryRecord(date: '17 May 2025', minPrice: 570, avgPrice: 620, maxPrice: 670),
          PriceHistoryRecord(date: '16 May 2025', minPrice: 560, avgPrice: 610, maxPrice: 660),
          PriceHistoryRecord(date: '15 May 2025', minPrice: 550, avgPrice: 600, maxPrice: 650),
          PriceHistoryRecord(date: '14 May 2025', minPrice: 540, avgPrice: 590, maxPrice: 640),
        ],
      ),
      CropRate(
        id: 'soyabean',
        name: 'Soyabean',
        gujaratiName: '',
        imageAsset: 'assets/images/crop_soyabean.png',
        arrivalBags: 860,
        totalQuantityKg: 17200,
        minPrice: 600,
        avgPrice: 650,
        maxPrice: 700,
        changeAmount: 80,
        changePercentage: 14.04,
        isRise: true,
        lastUpdated: '21 May 2025, 08:30 AM',
        history: [
          PriceHistoryRecord(date: '20 May 2025', minPrice: 600, avgPrice: 650, maxPrice: 700),
          PriceHistoryRecord(date: '19 May 2025', minPrice: 590, avgPrice: 640, maxPrice: 690),
          PriceHistoryRecord(date: '18 May 2025', minPrice: 570, avgPrice: 620, maxPrice: 670),
          PriceHistoryRecord(date: '17 May 2025', minPrice: 560, avgPrice: 610, maxPrice: 660),
          PriceHistoryRecord(date: '16 May 2025', minPrice: 550, avgPrice: 600, maxPrice: 650),
        ],
      ),
      CropRate(
        id: 'chana',
        name: 'Chana',
        gujaratiName: '',
        imageAsset: 'assets/images/crop_chana.png',
        arrivalBags: 750,
        totalQuantityKg: 15000,
        minPrice: 540,
        avgPrice: 590,
        maxPrice: 640,
        changeAmount: -90,
        changePercentage: 14.29,
        isRise: false,
        lastUpdated: '21 May 2025, 08:30 AM',
        history: [
          PriceHistoryRecord(date: '20 May 2025', minPrice: 540, avgPrice: 590, maxPrice: 640),
          PriceHistoryRecord(date: '19 May 2025', minPrice: 550, avgPrice: 600, maxPrice: 650),
          PriceHistoryRecord(date: '18 May 2025', minPrice: 560, avgPrice: 610, maxPrice: 660),
          PriceHistoryRecord(date: '17 May 2025', minPrice: 570, avgPrice: 620, maxPrice: 670),
          PriceHistoryRecord(date: '16 May 2025', minPrice: 580, avgPrice: 630, maxPrice: 680),
        ],
      ),
      CropRate(
        id: 'cotton',
        name: 'Cotton',
        gujaratiName: 'Kapas',
        imageAsset: 'assets/images/crop_cotton.png',
        arrivalBags: 1020,
        totalQuantityKg: 20400,
        minPrice: 740,
        avgPrice: 810,
        maxPrice: 880,
        changeAmount: 120,
        changePercentage: 17.39,
        isRise: true,
        lastUpdated: '21 May 2025, 08:30 AM',
        history: [
          PriceHistoryRecord(date: '20 May 2025', minPrice: 740, avgPrice: 810, maxPrice: 880),
          PriceHistoryRecord(date: '19 May 2025', minPrice: 720, avgPrice: 790, maxPrice: 860),
          PriceHistoryRecord(date: '18 May 2025', minPrice: 700, avgPrice: 770, maxPrice: 840),
          PriceHistoryRecord(date: '17 May 2025', minPrice: 690, avgPrice: 760, maxPrice: 830),
          PriceHistoryRecord(date: '16 May 2025', minPrice: 680, avgPrice: 750, maxPrice: 820),
        ],
      ),
      CropRate(
        id: 'tuver',
        name: 'Tuver',
        gujaratiName: '',
        imageAsset: 'assets/images/crop_tuver.png',
        arrivalBags: 680,
        totalQuantityKg: 13600,
        minPrice: 700,
        avgPrice: 760,
        maxPrice: 820,
        changeAmount: 50,
        changePercentage: 7.25,
        isRise: true,
        lastUpdated: '21 May 2025, 08:30 AM',
        history: [
          PriceHistoryRecord(date: '20 May 2025', minPrice: 700, avgPrice: 760, maxPrice: 820),
          PriceHistoryRecord(date: '19 May 2025', minPrice: 710, avgPrice: 770, maxPrice: 830),
          PriceHistoryRecord(date: '18 May 2025', minPrice: 720, avgPrice: 780, maxPrice: 840),
          PriceHistoryRecord(date: '17 May 2025', minPrice: 730, avgPrice: 790, maxPrice: 850),
          PriceHistoryRecord(date: '16 May 2025', minPrice: 740, avgPrice: 800, maxPrice: 860),
        ],
      ),
      CropRate(
        id: 'garlic',
        name: 'Garlic',
        gujaratiName: 'Lasan',
        imageAsset: 'assets/images/crop_garlic.png',
        arrivalBags: 560,
        totalQuantityKg: 11200,
        minPrice: 900,
        avgPrice: 1020,
        maxPrice: 1140,
        changeAmount: 60,
        changePercentage: 6.32,
        isRise: true,
        lastUpdated: '21 May 2025, 08:30 AM',
        history: [
          PriceHistoryRecord(date: '20 May 2025', minPrice: 900, avgPrice: 1020, maxPrice: 1140),
          PriceHistoryRecord(date: '19 May 2025', minPrice: 890, avgPrice: 1010, maxPrice: 1130),
          PriceHistoryRecord(date: '18 May 2025', minPrice: 880, avgPrice: 1000, maxPrice: 1120),
          PriceHistoryRecord(date: '17 May 2025', minPrice: 860, avgPrice: 980, maxPrice: 1100),
          PriceHistoryRecord(date: '16 May 2025', minPrice: 850, avgPrice: 970, maxPrice: 1090),
        ],
      ),
    ];
  }

  static List<ShopModel> getShops() {
    return [
      ShopModel(id: '1', number: 1, name: 'Ramdev Trading', phoneNumber: '+91 8238930700', yardId: 'rajkot'),
      ShopModel(id: '2', number: 2, name: 'Patel Corporation', phoneNumber: '+91 98765 43211', yardId: 'rajkot'),
      ShopModel(id: '3', number: 3, name: 'Mahadev Agency', phoneNumber: '+91 98765 43212', yardId: 'rajkot'),
      ShopModel(id: '4', number: 4, name: 'Shree Krishna Traders', phoneNumber: '+91 98765 43213', yardId: 'junagadh'),
      ShopModel(id: '5', number: 5, name: 'Jay Khodiyar Traders', phoneNumber: '+91 98765 43214', yardId: 'junagadh'),
      ShopModel(id: '6', number: 6, name: 'Balaji Trading Co.', phoneNumber: '+91 98765 43215', yardId: 'gondal'),
      ShopModel(id: '7', number: 7, name: 'Shivam Enterprise', phoneNumber: '+91 98765 43216', yardId: 'gondal'),
      ShopModel(id: '8', number: 8, name: 'Om Agro Traders', phoneNumber: '+91 98765 43217', yardId: 'mendarda'),
      ShopModel(id: '9', number: 9, name: 'Shakti Commission Agent', phoneNumber: '+91 98765 43218', yardId: 'mendarda'),
    ];
  }

  static List<UserModel> getUsers() {
    return [
      UserModel(id: '1', name: 'Ramesh Patel', phoneNumber: '+91 98765 43210', email: 'ramesh.patel@example.com', isActive: true, isBlocked: false),
      UserModel(id: '2', name: 'Suresh Bhai', phoneNumber: '+91 87654 32109', email: 'suresh.bhai@example.com', isActive: true, isBlocked: false),
      UserModel(id: '3', name: 'Vijay Kumar', phoneNumber: '+91 76543 21098', email: 'vijay.kumar@example.com', isActive: false, isBlocked: true),
    ];
  }
}
