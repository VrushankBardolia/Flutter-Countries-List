import 'package:graphql/client.dart';
import 'model.dart';

final _httpLink = HttpLink("https://countries.trevorblades.com/");

final GraphQLClient client = GraphQLClient(
  link: _httpLink,
  cache: GraphQLCache(),
);

const _getAllCountries = r'''
{
  countries{
    name
    code
  }
}
''';

const _getCountry = r'''
query getCountry($code:ID!){
  country(code:$code){
    name
    capital
    code
    native
    currency
    phone
    emoji
  }
}
''';

Future<List<Country>> getAllCountries() async {
  var result = await client.query(
    QueryOptions(
      document: gql(_getAllCountries),
    ),
  );
  if (result.hasException) {
    throw result.exception!;
  }
  var json = result.data!["countries"];
  List<Country> countries = [];
  for (var res in json) {
    var country = Country.fromJson(res);
    countries.add(country);
    print(countries);
  }
  return countries;
}

// returns a country details with the given country code
Future<Country> getCountry(String code) async {
  var result = await client.query(
    QueryOptions(
      document: gql(_getCountry),
      variables: {
        "code": code,
      },
    ),
  );
  var json = result.data?["country"];
  var country = Country.fromJson(json);
  return country;
}