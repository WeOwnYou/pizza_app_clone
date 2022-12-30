// To parse this JSON data, do
//
//     final addressCompletionResponse = addressCompletionResponseFromJson(jsonString);

import 'dart:convert';

AddressCompletionResponse addressCompletionResponseFromJson(String str) => AddressCompletionResponse.fromJson(json.decode(str));

String addressCompletionResponseToJson(AddressCompletionResponse data) => json.encode(data.toJson());

class AddressCompletionResponse {
  AddressCompletionResponse({
    required this.suggestions,
  });

  List<Suggestion> suggestions;

  factory AddressCompletionResponse.fromJson(Map<String, dynamic> json) => AddressCompletionResponse(
    suggestions: List<Suggestion>.from(json["suggestions"].map((x) => Suggestion.fromJson(x))??[]),
  );

  Map<String, dynamic> toJson() => {
    "suggestions": List<dynamic>.from(suggestions.map((x) => x.toJson())),
  };
}

class Suggestion {
  Suggestion({
    this.value,
    this.unrestrictedValue,
    this.data,
  });

  String? value;
  String? unrestrictedValue;
  Data? data;

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
    value: json["value"],
    unrestrictedValue: json["unrestricted_value"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "unrestricted_value": unrestrictedValue,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.postalCode,
    this.country,
    this.countryIsoCode,
    this.federalDistrict,
    this.regionFiasId,
    this.regionKladrId,
    this.regionIsoCode,
    this.regionWithType,
    this.regionType,
    this.regionTypeFull,
    this.region,
    this.areaFiasId,
    this.areaKladrId,
    this.areaWithType,
    this.areaType,
    this.areaTypeFull,
    this.area,
    this.cityFiasId,
    this.cityKladrId,
    this.cityWithType,
    this.cityType,
    this.cityTypeFull,
    this.city,
    this.cityArea,
    this.cityDistrictFiasId,
    this.cityDistrictKladrId,
    this.cityDistrictWithType,
    this.cityDistrictType,
    this.cityDistrictTypeFull,
    this.cityDistrict,
    this.settlementFiasId,
    this.settlementKladrId,
    this.settlementWithType,
    this.settlementType,
    this.settlementTypeFull,
    this.settlement,
    this.streetFiasId,
    this.streetKladrId,
    this.streetWithType,
    this.streetType,
    this.streetTypeFull,
    this.street,
    this.steadFiasId,
    this.steadCadnum,
    this.steadType,
    this.steadTypeFull,
    this.stead,
    this.houseFiasId,
    this.houseKladrId,
    this.houseCadnum,
    this.houseType,
    this.houseTypeFull,
    this.house,
    this.blockType,
    this.blockTypeFull,
    this.block,
    this.entrance,
    this.floor,
    this.flatFiasId,
    this.flatCadnum,
    this.flatType,
    this.flatTypeFull,
    this.flat,
    this.flatArea,
    this.squareMeterPrice,
    this.flatPrice,
    this.postalBox,
    this.fiasId,
    this.fiasCode,
    this.fiasLevel,
    this.fiasActualityState,
    this.kladrId,
    this.geonameId,
    this.capitalMarker,
    this.okato,
    this.oktmo,
    this.taxOffice,
    this.taxOfficeLegal,
    this.timezone,
    this.geoLat,
    this.geoLon,
    this.beltwayHit,
    this.beltwayDistance,
    this.metro,
    this.divisions,
    this.qcGeo,
    this.qcComplete,
    this.qcHouse,
    required this.historyValues,
    this.unparsedParts,
    this.source,
    this.qc,
  });

  dynamic? postalCode;
  String? country;
  String? countryIsoCode;
  dynamic federalDistrict;
  String? regionFiasId;
  String? regionKladrId;
  String? regionIsoCode;
  String? regionWithType;
  String? regionType;
  String? regionTypeFull;
  String? region;
  dynamic areaFiasId;
  dynamic areaKladrId;
  dynamic areaWithType;
  dynamic areaType;
  dynamic areaTypeFull;
  dynamic area;
  String? cityFiasId;
  String? cityKladrId;
  String? cityWithType;
  String? cityType;
  String? cityTypeFull;
  String? city;
  dynamic cityArea;
  dynamic cityDistrictFiasId;
  dynamic cityDistrictKladrId;
  dynamic cityDistrictWithType;
  dynamic cityDistrictType;
  dynamic cityDistrictTypeFull;
  dynamic cityDistrict;
  dynamic settlementFiasId;
  dynamic settlementKladrId;
  dynamic settlementWithType;
  dynamic settlementType;
  dynamic settlementTypeFull;
  dynamic settlement;
  String? streetFiasId;
  String? streetKladrId;
  String? streetWithType;
  String? streetType;
  String? streetTypeFull;
  String? street;
  dynamic steadFiasId;
  dynamic steadCadnum;
  dynamic steadType;
  dynamic steadTypeFull;
  dynamic stead;
  dynamic houseFiasId;
  dynamic houseKladrId;
  dynamic houseCadnum;
  dynamic houseType;
  dynamic houseTypeFull;
  dynamic house;
  dynamic blockType;
  dynamic blockTypeFull;
  dynamic block;
  dynamic entrance;
  dynamic floor;
  dynamic flatFiasId;
  dynamic flatCadnum;
  dynamic flatType;
  dynamic flatTypeFull;
  dynamic flat;
  dynamic flatArea;
  dynamic squareMeterPrice;
  dynamic flatPrice;
  dynamic postalBox;
  String? fiasId;
  dynamic fiasCode;
  String? fiasLevel;
  String? fiasActualityState;
  String? kladrId;
  String? geonameId;
  String? capitalMarker;
  String? okato;
  String? oktmo;
  String? taxOffice;
  String? taxOfficeLegal;
  dynamic timezone;
  String? geoLat;
  String? geoLon;
  dynamic beltwayHit;
  dynamic beltwayDistance;
  dynamic metro;
  dynamic divisions;
  String? qcGeo;
  dynamic qcComplete;
  dynamic qcHouse;
  List<String> historyValues;                 //!!
  dynamic unparsedParts;
  dynamic source;
  dynamic qc;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    postalCode: json["postal_code"],
    country: json["country"],
    countryIsoCode: json["country_iso_code"],
    federalDistrict: json["federal_district"],
    regionFiasId: json["region_fias_id"],
    regionKladrId: json["region_kladr_id"],
    regionIsoCode: json["region_iso_code"],
    regionWithType: json["region_with_type"],
    regionType: json["region_type"],
    regionTypeFull: json["region_type_full"],
    region: json["region"],
    areaFiasId: json["area_fias_id"],
    areaKladrId: json["area_kladr_id"],
    areaWithType: json["area_with_type"],
    areaType: json["area_type"],
    areaTypeFull: json["area_type_full"],
    area: json["area"],
    cityFiasId: json["city_fias_id"],
    cityKladrId: json["city_kladr_id"],
    cityWithType: json["city_with_type"],
    cityType: json["city_type"],
    cityTypeFull: json["city_type_full"],
    city: json["city"],
    cityArea: json["city_area"],
    cityDistrictFiasId: json["city_district_fias_id"],
    cityDistrictKladrId: json["city_district_kladr_id"],
    cityDistrictWithType: json["city_district_with_type"],
    cityDistrictType: json["city_district_type"],
    cityDistrictTypeFull: json["city_district_type_full"],
    cityDistrict: json["city_district"],
    settlementFiasId: json["settlement_fias_id"],
    settlementKladrId: json["settlement_kladr_id"],
    settlementWithType: json["settlement_with_type"],
    settlementType: json["settlement_type"],
    settlementTypeFull: json["settlement_type_full"],
    settlement: json["settlement"],
    streetFiasId: json["street_fias_id"],
    streetKladrId: json["street_kladr_id"],
    streetWithType: json["street_with_type"],
    streetType: json["street_type"],
    streetTypeFull: json["street_type_full"],
    street: json["street"],
    steadFiasId: json["stead_fias_id"],
    steadCadnum: json["stead_cadnum"],
    steadType: json["stead_type"],
    steadTypeFull: json["stead_type_full"],
    stead: json["stead"],
    houseFiasId: json["house_fias_id"],
    houseKladrId: json["house_kladr_id"],
    houseCadnum: json["house_cadnum"],
    houseType: json["house_type"],
    houseTypeFull: json["house_type_full"],
    house: json["house"],
    blockType: json["block_type"],
    blockTypeFull: json["block_type_full"],
    block: json["block"],
    entrance: json["entrance"],
    floor: json["floor"],
    flatFiasId: json["flat_fias_id"],
    flatCadnum: json["flat_cadnum"],
    flatType: json["flat_type"],
    flatTypeFull: json["flat_type_full"],
    flat: json["flat"],
    flatArea: json["flat_area"],
    squareMeterPrice: json["square_meter_price"],
    flatPrice: json["flat_price"],
    postalBox: json["postal_box"],
    fiasId: json["fias_id"],
    fiasCode: json["fias_code"],
    fiasLevel: json["fias_level"],
    fiasActualityState: json["fias_actuality_state"],
    kladrId: json["kladr_id"],
    geonameId: json["geoname_id"],
    capitalMarker: json["capital_marker"],
    okato: json["okato"],
    oktmo: json["oktmo"],
    taxOffice: json["tax_office"],
    taxOfficeLegal: json["tax_office_legal"],
    timezone: json["timezone"],
    geoLat: json["geo_lat"],
    geoLon: json["geo_lon"],
    beltwayHit: json["beltway_hit"],
    beltwayDistance: json["beltway_distance"],
    metro: json["metro"],
    divisions: json["divisions"],
    qcGeo: json["qc_geo"],
    qcComplete: json["qc_complete"],
    qcHouse: json["qc_house"],
    historyValues: (List<String>.from(json["history_values"]??[])).map((x) => x??'').toList(),
    unparsedParts: json["unparsed_parts"],
    source: json["source"],
    qc: json["qc"],
  );

  Map<String, dynamic> toJson() => {
    "postal_code": postalCode,
    "country": country,
    "country_iso_code": countryIsoCode,
    "federal_district": federalDistrict,
    "region_fias_id": regionFiasId,
    "region_kladr_id": regionKladrId,
    "region_iso_code": regionIsoCode,
    "region_with_type": regionWithType,
    "region_type": regionType,
    "region_type_full": regionTypeFull,
    "region": region,
    "area_fias_id": areaFiasId,
    "area_kladr_id": areaKladrId,
    "area_with_type": areaWithType,
    "area_type": areaType,
    "area_type_full": areaTypeFull,
    "area": area,
    "city_fias_id": cityFiasId,
    "city_kladr_id": cityKladrId,
    "city_with_type": cityWithType,
    "city_type": cityType,
    "city_type_full": cityTypeFull,
    "city": city,
    "city_area": cityArea,
    "city_district_fias_id": cityDistrictFiasId,
    "city_district_kladr_id": cityDistrictKladrId,
    "city_district_with_type": cityDistrictWithType,
    "city_district_type": cityDistrictType,
    "city_district_type_full": cityDistrictTypeFull,
    "city_district": cityDistrict,
    "settlement_fias_id": settlementFiasId,
    "settlement_kladr_id": settlementKladrId,
    "settlement_with_type": settlementWithType,
    "settlement_type": settlementType,
    "settlement_type_full": settlementTypeFull,
    "settlement": settlement,
    "street_fias_id": streetFiasId,
    "street_kladr_id": streetKladrId,
    "street_with_type": streetWithType,
    "street_type": streetType,
    "street_type_full": streetTypeFull,
    "street": street,
    "stead_fias_id": steadFiasId,
    "stead_cadnum": steadCadnum,
    "stead_type": steadType,
    "stead_type_full": steadTypeFull,
    "stead": stead,
    "house_fias_id": houseFiasId,
    "house_kladr_id": houseKladrId,
    "house_cadnum": houseCadnum,
    "house_type": houseType,
    "house_type_full": houseTypeFull,
    "house": house,
    "block_type": blockType,
    "block_type_full": blockTypeFull,
    "block": block,
    "entrance": entrance,
    "floor": floor,
    "flat_fias_id": flatFiasId,
    "flat_cadnum": flatCadnum,
    "flat_type": flatType,
    "flat_type_full": flatTypeFull,
    "flat": flat,
    "flat_area": flatArea,
    "square_meter_price": squareMeterPrice,
    "flat_price": flatPrice,
    "postal_box": postalBox,
    "fias_id": fiasId,
    "fias_code": fiasCode,
    "fias_level": fiasLevel,
    "fias_actuality_state": fiasActualityState,
    "kladr_id": kladrId,
    "geoname_id": geonameId,
    "capital_marker": capitalMarker,
    "okato": okato,
    "oktmo": oktmo,
    "tax_office": taxOffice,
    "tax_office_legal": taxOfficeLegal,
    "timezone": timezone,
    "geo_lat": geoLat,
    "geo_lon": geoLon,
    "beltway_hit": beltwayHit,
    "beltway_distance": beltwayDistance,
    "metro": metro,
    "divisions": divisions,
    "qc_geo": qcGeo,
    "qc_complete": qcComplete,
    "qc_house": qcHouse,
    "history_values": List<dynamic>.from(historyValues.map((x) => x)),
    "unparsed_parts": unparsedParts,
    "source": source,
    "qc": qc,
  };
}
