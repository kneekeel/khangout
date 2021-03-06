import 'package:aqueduct/aqueduct.dart';
import '../model/hangout.dart';
import '../server.dart';

class HangoutController extends ResourceController {
  HangoutController(this.context);

  final ManagedContext context;

  // GET
  // get a list of hangouts
  @Operation.get()
  Future<Response> getAllHangouts() async {
    final hangoutQuery = Query<Hangout>(context);
    final hangouts = await hangoutQuery.fetch();

    return Response.ok(hangouts);
  }

  // get a single hangout by its id
  @Operation.get('id')
  // declare input parameter which is path('id') and bind it as argument of type integer
  Future<Response> getHangoutByID(@Bind.path('id') int id) async {
    final hangoutQuery = Query<Hangout>(context)
      ..where((h) => h.id).equalTo(id);
    final hangout = await hangoutQuery.fetchOne();
    if (hangout == null) {
      return Response.notFound();
    }
    return Response.ok(hangout);
  }

  // POST; Insert new hangout info into the database
  // The request will contain the JSON representation of a hangout in its body
  @Operation.post()
  Future<Response> createHangout(@Bind.body() Hangout inputHangout) async {
    final query = Query<Hangout>(context)..values = inputHangout;
    final insertedHangout = await query.insert();
    return Response.ok(insertedHangout);
  }

  // PUT
  @Operation.put('id')
  Future<Response> updateHangoutById(
      @Bind.path('id') int id, @Bind.body() Hangout inputHangout) async {
    final hangoutQuery = Query<Hangout>(context)
      ..where((h) => h.id).equalTo(id)
      ..values = inputHangout;
    final hangout = await hangoutQuery.updateOne();
    if (hangout == null) {
      return Response.notFound();
    }
    return Response.ok(hangout);
  }

  // DELETE
  @Operation.delete('id')
  Future<Response> deleteHangoutByID(@Bind.path('id') int id) async {
    final hangoutQuery = Query<Hangout>(context)
      ..where((h) => h.id).equalTo(id);
    final hangout = await hangoutQuery.delete();
    if (hangout == null) {
      return Response.notFound();
    }
    return Response.ok(hangout);
  }
}
