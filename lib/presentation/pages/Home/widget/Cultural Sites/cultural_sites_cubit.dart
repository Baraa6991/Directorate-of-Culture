import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_site.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_sites-state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CulturalSitesCubit extends Cubit<CulturalSitesState> {
  CulturalSitesCubit()
      : super(
          CulturalSitesState(
            sites: [
              CulturalSite(
                id: '1',
                name: 'مركز برزة',
                latitude: 33.605738,
                longitude: 36.310047,
                iconType: IconDataType.theater,
                activityLevel: 'High Activity',
                imageAssets: [
                  'assets/images/site1_1.png',
                  'assets/images/site1_2.png',
                  'assets/images/site1_3.png',
                ],
              ),
              CulturalSite(
                id: '2',
                name: 'مركز العدوي',
                latitude: 33.522387,
                longitude: 36.306016,
                iconType: IconDataType.museum,
                activityLevel: 'High Activity',
                imageAssets: [
                  'assets/images/site2_1.png',
                  'assets/images/site2_2.png',
                  'assets/images/site2_3.png',
                ],
              ),
              CulturalSite(
                id: '3',
                name: 'مركز الميدان',
                latitude: 33.494012,
                longitude: 36.301297,
                iconType: IconDataType.library,
                activityLevel: 'Medium Activity',
                imageAssets: [
                  'assets/images/site3_1.png',
                  'assets/images/site3_2.png',
                  'assets/images/site3_3.png',
                ],
              ),
              CulturalSite(
                id: '4',
                name: 'مركز المزة',
                latitude: 33.497412,
                longitude: 36.244484,
                iconType: IconDataType.pin,
                activityLevel: 'Low Activity',
                imageAssets: [
                  'assets/images/site4_1.png',
                  'assets/images/site4_2.png',
                  'assets/images/site4_3.png',
                ],
              ),
              CulturalSite(
                id: '5',
                name: 'مركز أبو رمانة',
                latitude: 33.519963,
                longitude: 36.284172,
                iconType: IconDataType.museum,
                activityLevel: 'High Activity',
                imageAssets: [
                  'assets/images/site5_1.png',
                  'assets/images/site5_2.png',
                  'assets/images/site5_3.png',
                ],
              ),
              CulturalSite(
                id: '6',
                name: 'مركز كفر سوسة',
                latitude: 33.500812,
                longitude: 36.278312,
                iconType: IconDataType.theater,
                activityLevel: 'Medium Activity',
                imageAssets: [
                  'assets/images/site6_1.png',
                  'assets/images/site6_2.png',
                  'assets/images/site6_3.png',
                ],
              ),
            ],
            selectedSite: null,
          ),
        ) {
    emit(state.copyWith(selectedSite: state.sites[1]));
  }

  void selectSite(CulturalSite site) {
    emit(state.copyWith(selectedSite: site));
  }
}