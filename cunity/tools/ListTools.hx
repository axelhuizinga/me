/**
 *
 * @author Axel Huizinga
 */

package me.cunity.tools;

class ListTools 
{

	public function new() 
	{
		
	}
	public static function contains < T > (l:List < T > , item:T  ) :Bool{
		var it:Iterator<T> = l.iterator();
		while (it.hasNext() ){
			if (it.next() == item)
				return true;
		}
		return false;
	}
	
	public static function fromIt < T > ( it:Iterator < T > ):List < T > {
		var l:List<T> = new List();
		while (it.hasNext())
			l.add(it.next());
		return l;
	}
	
}