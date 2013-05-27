package cases;
 import prime.bindable.collections.ArrayList;
 import prime.bindable.collections.BalancingListCollection;
 import prime.bindable.collections.ChainedListCollection;
 import prime.bindable.collections.SimpleList;
 

/**
 * Description
 * 
 * @creation-date	Jul 5, 2010
 * @author			Ruben Weijers
 */
class CollectionTest 
{
	public static function main ()
	{
		var tile:Tile;
		
		
		//
		// TEST SIMPLE LIST
		//
		trace("START SIMPLE-LIST");
		var tile1:Tile, tile2:Tile, tile3:Tile;
		var slist = new SimpleList<Tile>();
		Assert.isEqual(slist.length, 0);
		
		slist.add( tile1 = tile = new Tile() );			// [ tile1 ]					( tile = tile1 )
		Assert.isEqual(slist.length, 1);
		Assert.isEqual(slist.first.data, tile);
		Assert.isEqual(slist.last.data, tile);
		Assert.isEqual(slist.last.prev, null);
		Assert.isEqual(slist.last.next, null);
		
		slist.add( tile2 = tile = new Tile() );			// [ tile1, tile2 ]				( tile = tile2 )
		Assert.isEqual(slist.length, 2);
		Assert.notEqual(slist.first.data, tile);
		Assert.isEqual(slist.first.data, tile1);
		Assert.isEqual(slist.last.data, tile);
		
		Assert.isEqual(slist.first.prev, null);
		Assert.isEqual(slist.first.next, slist.last);
		Assert.isEqual(slist.last.data, tile);
		Assert.isEqual(slist.last.prev, slist.first);
		Assert.isEqual(slist.last.next, null);
		
		slist.add( tile3 = tile = new Tile(), 1 );		// [ tile1, tile3, tile2 ]		( tile = tile3 )
		Assert.isEqual(slist.length, 3);
		
		Assert.notEqual(slist.last.data, tile3);
		Assert.isEqual(slist.first.data, tile1);
		Assert.isEqual(slist.last.data, tile2);
		Assert.isEqual(slist.first.next.data, tile3);
		Assert.isEqual(slist.last.prev.data, tile3);
		
		Assert.isEqual(slist.first.prev, null);
		Assert.isEqual(slist.first.next, slist.last.prev);
		Assert.isEqual(slist.first.next.next, slist.last);
		Assert.isEqual(slist.first.next.prev, slist.first);
		Assert.isEqual(slist.last.next, null);
		
		//test iterator
		var current = tile1;
		for (item in slist) {
			Assert.isEqual(current, item);
			if (current == tile1)		current = tile3;
			else if (current == tile3)	current = tile2;
		}
		
		//
		// test moving items around
		//
		
		trace(slist);
		
		//test moving items higher in the slist
		trace("moving item up: "+tile1+" to 2");
		slist.move(tile1, 2);									// [ tile3, tile2, tile1 ]
	//	throw "poep";
		trace(slist);
		Assert.isEqual( slist.first.data,			tile3 );
		Assert.isEqual( slist.last.data,			tile1 );
		Assert.isEqual( slist.first.next.data,	tile2 );
		Assert.isEqual( slist.last.next,			null );
		Assert.isEqual( slist.last.prev.data,		tile2 );
		
		//test moving items lower in the slist
		trace("moving item down: "+tile1+" to 0");
		slist.move(tile1, 0);									// [ tile1, tile3, tile2 ]
		trace(slist);
		Assert.isEqual( slist.first.data,			tile1 );
		Assert.isEqual( slist.last.data,			tile2 );
		Assert.isEqual( slist.first.next.data,	tile3 );
		Assert.isEqual( slist.last.next,			null );
		Assert.isEqual( slist.last.prev.data,		tile3 );
		
		//test moving items lower in the slist
		trace("moving item down: "+tile2+" to -2");
		slist.move(tile2, -2);									// [ tile1, tile2, tile3 ]
		trace(slist);
		Assert.isEqual( slist.first.data,			tile1 );
		Assert.isEqual( slist.last.data,			tile3 );
		Assert.isEqual( slist.first.next.data,	tile2 );
		Assert.isEqual( slist.last.next,			null );
		Assert.isEqual( slist.last.prev.data,		tile2 );
		
		trace("END SIMPLE LIST\n\n");
		
		
		//
		// TEST ARRAY LIST
		//
		trace("START ARRAY-LIST");
		var alist = new ArrayList<Tile>();
		Assert.isEqual(alist.length, 0);
		
		alist.add( tile1 = tile = new Tile() );
		Assert.isEqual(alist.length, 1);
		Assert.isEqual(alist.getItemAt(0), tile);
		
		alist.add( tile2 = tile = new Tile() );
		Assert.isEqual(alist.length, 2);
		Assert.isEqual(alist.getItemAt(0), tile1);
		Assert.isEqual(alist.getItemAt(1), tile2);
		
		alist.add( tile3 = tile = new Tile(), 1 );
		Assert.isEqual(alist.length, 3);
		Assert.isEqual(alist.getItemAt(0), tile1);
		Assert.isEqual(alist.getItemAt(1), tile3);
		Assert.isEqual(alist.getItemAt(2), tile2);
		
		//test iterator
		var current = tile1;
		for (item in alist) {
			Assert.isEqual(current, item);
			if (current == tile1)		current = tile3;
			else if (current == tile3)	current = tile2;
		}
		
		//
		// test moving items around
		//
		
		trace(alist);
		
		//test moving items higher in the alist
		trace("moving item up: "+tile1+" to 2");
		alist.move(tile1, 2);
		trace(alist);
		Assert.isEqual(alist.getItemAt(0), tile3);
		Assert.isEqual(alist.getItemAt(1), tile2);
		Assert.isEqual(alist.getItemAt(2), tile1);
		
		//test moving items lower in the alist
		trace("moving item down: "+tile1+" to 0");
		alist.move(tile1, 0);
		trace(alist);
		Assert.isEqual(alist.getItemAt(0), tile1);
		Assert.isEqual(alist.getItemAt(1), tile3);
		Assert.isEqual(alist.getItemAt(2), tile2);
		
		trace("END ARRAY LIST\n\n");
		
		
		
		//
		// TEST CHAINEDLIST COLLECTION
		//
		trace("START CHAINED LIST COLLECTION");
		
		Tile.COUNTER = 0;
		var chained = new ChainedListCollection<Tile>(4);
		Assert.isEqual( chained.length, 0 );
		Assert.isEqual( chained.lists.length, 0 );
		
		chained.add( tile = new Tile() );
		Assert.isEqual(chained.length, 1);
		Assert.isEqual(chained.lists.length, 1);
		Assert.isEqual(chained.indexOf( tile ), 0 );
		
		chained.add( tile = new Tile() );
		chained.add( tile = new Tile() );
		chained.add( tile = new Tile() );
		
		Assert.isEqual(chained.indexOf( tile ), 3 );
		Assert.isEqual(chained.length, 4);
		Assert.isEqual(chained.lists.length, 1);
		Assert.isEqual(chained.lists.getItemAt(0).length, 4);
		
		chained.add( tile = new Tile() );
		chained.add( tile = new Tile() );
		Assert.isEqual(chained.indexOf( tile ), 5 );
		Assert.isEqual(chained.length, 6);
		Assert.isEqual(chained.lists.getItemAt(0).length, 4);
		Assert.isEqual(chained.lists.getItemAt(1).length, 2);
		Assert.isEqual(chained.lists.length, 2);
		
		trace(chained.lists.getItemAt(0));
		Assert.isEqual(chained.lists.getItemAt(0).getItemAt(0).id, 1);
		Assert.isEqual(chained.lists.getItemAt(0).getItemAt(1).id, 2);
		Assert.isEqual(chained.lists.getItemAt(0).getItemAt(2).id, 3);
		Assert.isEqual(chained.lists.getItemAt(0).getItemAt(3).id, 4);
		Assert.isEqual(chained.lists.getItemAt(1).getItemAt(0).id, 5);
		Assert.isEqual(chained.lists.getItemAt(1).getItemAt(1).id, 6);
		
		chained.add( tile = new Tile(), 2 );
		chained.add( tile = new Tile(), 2 );
		Assert.isEqual(chained.indexOf( tile ), 2 );
		Assert.isEqual(chained.length, 8);
		Assert.isEqual(chained.lists.getItemAt(0).length, 4);
		Assert.isEqual(chained.lists.getItemAt(1).length, 4);
		
		Assert.isEqual(chained.lists.getItemAt(0).getItemAt(0).id, 1);
		Assert.isEqual(chained.lists.getItemAt(0).getItemAt(1).id, 2);
		Assert.isEqual(chained.lists.getItemAt(0).getItemAt(2).id, 8);
		Assert.isEqual(chained.lists.getItemAt(0).getItemAt(3).id, 7);
		Assert.isEqual(chained.lists.getItemAt(1).getItemAt(0).id, 3);
		Assert.isEqual(chained.lists.getItemAt(1).getItemAt(1).id, 4);
		Assert.isEqual(chained.lists.getItemAt(1).getItemAt(2).id, 5);
		Assert.isEqual(chained.lists.getItemAt(1).getItemAt(3).id, 6);
		
		//
		//test moving items around
		//
		var ctile0 = chained.getItemAt(0);
		var ctile1 = chained.getItemAt(1);
		var ctile2 = chained.getItemAt(2);
		var ctile3 = chained.getItemAt(3);
		var ctile4 = chained.getItemAt(4);
		var ctile5 = chained.getItemAt(5);
		var ctile6 = chained.getItemAt(6);
		var ctile7 = chained.getItemAt(7);
		
		trace(chained);
		
		//move item to lower position
		trace("moving item up: "+ctile6+" to 2");
		chained.move( ctile6, 2 );
		trace(chained);
		Assert.isEqual( ctile0, chained.getItemAt(0));
		Assert.isEqual( ctile1, chained.getItemAt(1));
		Assert.isEqual( ctile6, chained.getItemAt(2));
		Assert.isEqual( ctile2, chained.getItemAt(3));
		Assert.isEqual( ctile3, chained.getItemAt(4));
		Assert.isEqual( ctile4, chained.getItemAt(5));
		
		//move item to higher position
		trace("moving item down: "+ctile0+" to 4");
		chained.move( ctile0, 4 );
		trace(chained);
		Assert.isEqual( ctile1, chained.getItemAt(0));
		Assert.isEqual( ctile6, chained.getItemAt(1));
		Assert.isEqual( ctile2, chained.getItemAt(2));
		Assert.isEqual( ctile3, chained.getItemAt(3));
		Assert.isEqual( ctile0, chained.getItemAt(4));
		Assert.isEqual( ctile4, chained.getItemAt(5));
		
		trace("END CHAINED LIST COLLECTION\n\n");
		
		
		
		//
		// TEST BALANCING LIST COLLECTION
		//
		trace("BALANCING LIST COLLECTION");
		
		Tile.COUNTER = 0;
		var balancingCol = new BalancingListCollection<Tile>(4);
		Assert.isEqual(balancingCol.length, 0);
		Assert.isEqual(balancingCol.lists.length, 0);
		
		balancingCol.add( tile = new Tile() );
		Assert.isEqual(balancingCol.length, 1);
		Assert.isEqual(balancingCol.lists.length, 1);
		Assert.isEqual(balancingCol.indexOf( tile ), 0 );
		
		balancingCol.add( tile = new Tile() );
		balancingCol.add( tile = new Tile() );
		balancingCol.add( tile = new Tile() );
		Assert.isEqual(balancingCol.indexOf( tile ), 3 );
		Assert.isEqual(balancingCol.length, 4);
		Assert.isEqual(balancingCol.lists.length, 4);
		
	//	iterateList(balancingCol);
		balancingCol.add( tile = new Tile() );
		Assert.isEqual(balancingCol.indexOf( tile ), 4 );
		balancingCol.add( tile = new Tile() );
		Assert.isEqual(balancingCol.indexOf( tile ), 5 );
		balancingCol.add( tile = new Tile() );
		Assert.isEqual(balancingCol.indexOf( tile ), 6 );
		
		Assert.isEqual(balancingCol.length, 7);
		Assert.isEqual(balancingCol.lists.length, 4);
		Assert.isEqual(balancingCol.lists.getItemAt(0).length, 2);
		Assert.isEqual(balancingCol.lists.getItemAt(1).length, 2);
		Assert.isEqual(balancingCol.lists.getItemAt(2).length, 2);
		Assert.isEqual(balancingCol.lists.getItemAt(3).length, 1);
		
		balancingCol.add( tile = new Tile(), 3 );
	//	iterateList(balancingCol);
		Assert.isEqual(balancingCol.indexOf( tile ), 3 );
		Assert.isEqual(balancingCol.length, 8);
		Assert.isEqual(balancingCol.lists.length, 4);
		Assert.isEqual(balancingCol.lists.getItemAt(0).length, 2);
		Assert.isEqual(balancingCol.lists.getItemAt(1).length, 2);
		Assert.isEqual(balancingCol.lists.getItemAt(2).length, 2);
		Assert.isEqual(balancingCol.lists.getItemAt(3).length, 2);
		Assert.isEqual(balancingCol.lists.getItemAt(3).getItemAt(0).id, 8 );
		Assert.isEqual(balancingCol.lists.getItemAt(0).getItemAt(1).id, 4 );
		Assert.isEqual(balancingCol.lists.getItemAt(1).getItemAt(1).id, 5 );
		Assert.isEqual(balancingCol.lists.getItemAt(2).getItemAt(1).id, 6 );
		Assert.isEqual(balancingCol.lists.getItemAt(3).getItemAt(1).id, 7 );
		
		var removed = balancingCol.getItemAt(0);
		removed = balancingCol.remove( removed );
		
		Assert.isEqual(balancingCol.length, 7);
		Assert.isEqual(balancingCol.lists.length, 4);
		Assert.isEqual(balancingCol.indexOf(removed), -1);
		Assert.isEqual(balancingCol.lists.getItemAt(0).length, 2);
		Assert.isEqual(balancingCol.lists.getItemAt(1).length, 2);
		Assert.isEqual(balancingCol.lists.getItemAt(2).length, 2);
		Assert.isEqual(balancingCol.lists.getItemAt(3).length, 1);
		Assert.isEqual(balancingCol.lists.getItemAt(0).getItemAt(0).id, 2 );
		Assert.isEqual(balancingCol.lists.getItemAt(1).getItemAt(0).id, 3 );
		Assert.isEqual(balancingCol.lists.getItemAt(2).getItemAt(0).id, 8 );
		Assert.isEqual(balancingCol.lists.getItemAt(3).getItemAt(0).id, 4 );
		Assert.isEqual(balancingCol.lists.getItemAt(0).getItemAt(1).id, 5 );
		Assert.isEqual(balancingCol.lists.getItemAt(1).getItemAt(1).id, 6 );
		Assert.isEqual(balancingCol.lists.getItemAt(2).getItemAt(1).id, 7 );
		
		//
		//test moving items around
		//
		var btile0 = balancingCol.getItemAt(0);
		var btile1 = balancingCol.getItemAt(1);
		var btile2 = balancingCol.getItemAt(2);
		var btile3 = balancingCol.getItemAt(3);
		var btile4 = balancingCol.getItemAt(4);
		var btile5 = balancingCol.getItemAt(5);
		var btile6 = balancingCol.getItemAt(6);
		trace(balancingCol);
		
		//move item to lower position
		trace("moving item down: "+btile6+" to 2");
		balancingCol.move( btile6, 2 );
		trace(balancingCol);
		Assert.isEqual( btile0, balancingCol.getItemAt(0));
		Assert.isEqual( btile1, balancingCol.getItemAt(1));
		Assert.isEqual( btile6, balancingCol.getItemAt(2));
		Assert.isEqual( btile2, balancingCol.getItemAt(3));
		Assert.isEqual( btile3, balancingCol.getItemAt(4));
		Assert.isEqual( btile4, balancingCol.getItemAt(5));
		
		//move item to higher position
		trace("moving item up: "+btile0+" to 4");
		balancingCol.move( btile0, 4 );
		trace(balancingCol);
		Assert.isEqual( btile1, balancingCol.getItemAt(0));
		Assert.isEqual( btile6, balancingCol.getItemAt(1));
		Assert.isEqual( btile2, balancingCol.getItemAt(2));
		Assert.isEqual( btile3, balancingCol.getItemAt(3));
		Assert.isEqual( btile0, balancingCol.getItemAt(4));
		Assert.isEqual( btile4, balancingCol.getItemAt(5));
		
		//*/
		
		trace("TEST FINISHED!");
	}
}

class Tile
{
	public static var COUNTER:Int = 0;
	
	public var id:Int;
	public function new () { this.id = ++COUNTER; }
	public function toString () { return "Tile" + id; }
}