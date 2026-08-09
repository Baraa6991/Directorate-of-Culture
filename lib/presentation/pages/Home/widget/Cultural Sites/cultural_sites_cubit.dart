import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_site.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_sites-state.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_center_card_model.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_location_code/open_location_code.dart' as olc;

class CulturalSitesCubit extends Cubit<CulturalSitesState> {
  final HomeRepository repository;

  CulturalSitesCubit({required this.repository})
    : super(CulturalSitesState(sites: const [], selectedSite: null));

  Future<void> loadSites() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final centers = await repository.getCenters();
      final sites = centers
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final center = entry.value;
            return _toSite(center, index);
          })
          .whereType<CulturalSite>()
          .toList();

      emit(
        state.copyWith(
          sites: sites,
          selectedSite: sites.isNotEmpty ? sites.first : null,
          isLoading: false,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  void selectSite(CulturalSite site) {
    emit(state.copyWith(selectedSite: site));
  }

  CulturalSite? _toSite(CulturalCenterCardModel center, int index) {
    final resolvedCoordinates = _resolveCoordinates(center);
    if (resolvedCoordinates == null) return null;

    return CulturalSite(
      id: center.id,
      name: center.name,
      location: center.location,
      mapLocation: center.mapLocation,
      latitude: resolvedCoordinates.$1,
      longitude: resolvedCoordinates.$2,
      iconType: IconDataType.values[index % IconDataType.values.length],
      activityLevel: 'نشاط مرتفع',
      imageAssets: const [],
    );
  }

  (double, double)? _resolveCoordinates(CulturalCenterCardModel center) {
    final mapLocation = center.mapLocation?.trim();

    if (mapLocation != null && mapLocation.isNotEmpty) {
      final parsedLatLng = _tryParseLatLng(mapLocation);
      if (parsedLatLng != null) {
        return parsedLatLng;
      }

      final decodedPlusCode = _tryDecodePlusCode(mapLocation);
      if (decodedPlusCode != null) {
        return decodedPlusCode;
      }
    }

    return null;
  }

  (double, double)? _tryParseLatLng(String value) {
    final parts = value.split(',');
    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return null;

    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;
    return (lat, lng);
  }

  (double, double)? _tryDecodePlusCode(String value) {
    final cleaned = value.toUpperCase().trim();

    try {
      olc.PlusCode plusCode = olc.PlusCode.unverified(cleaned);
      if (!plusCode.isValid) return null;

      if (plusCode.isShort()) {
        // دمشق كنقطة مرجعية لفك short plus code مثل G79M+XMM
        plusCode = plusCode.recoverNearest(const olc.LatLng(33.5138, 36.2765));
      }

      if (!plusCode.isFull()) return null;

      final decoded = plusCode.decode();
      return (
        decoded.center.latitude.toDouble(),
        decoded.center.longitude.toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}
