package me.cunity.service;
import erazor.Template;
import sys.io.File;
import php.Web;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

class Localizer
{

	public static function process( tPath:String, obj:Dynamic):String
	{
		/*
		 * 1. load and parse locale
		 * 2. load and process template
		*/
		Service.instance.errLog('');
		Service.instance.errLog(tPath);
		var xml:Xml = null;
		try {
			xml = Xml.parse(File.getContent(Service.instance.templateDir + 'locale/' + tPath));
			if (xml.firstChild().nodeName == 'locale')
			{
				for (el in xml.firstChild().elements())
					Reflect.setField(obj, el.nodeName, el.toString());
				var tmp:Template = new Template(File.getContent(Service.instance.templateDir + tPath));
				return tmp.execute(obj);
			}
			return '';
		}
		catch (ex:Dynamic)
		{
			return(ex);
		}				
	}
	
	public static function getSystemTemplate(keys:Array<String>, ?data:Dynamic):String
	{
		var processed:String = '';

		//Service.instance.errLog('<textarea cols="60" rows="10">'+Std.string(data)+'</textarea>');
		try{
			var xml:Xml =  Xml.parse(
				File.getContent(Service.instance.templateDir + 'locale/' + Service.instance.locale + '/system.xml')
			);			
			//Service.instance.errLog('xml::nodeName:' + xml.firstElement().nodeName);
			if (xml.firstElement().nodeName == 'locale')
			{		
				for (key in keys)
				{
					var els:Iterator<Xml> = xml.firstElement().elementsNamed(key);
					if (els.hasNext())
					{
						//Service.instance.errLog(els.next().toString());
						var el:Xml = els.next();
						if (Lambda.has(keys, el.nodeName))
						{
							//Service.instance.errLog(el.nodeType + ':' + el.firstChild().nodeType+':' + );
							for (c in  el.iterator())
							{
								//Service.instance.errLog(c.nodeType + ':' + c.toString());
								var eR:EReg = ~/{:(\w*)}/;
								if (data != null &&  eR.match(c.toString()) && Lambda.has(Reflect.fields(data), eR.matched(1)))
									processed += new Template(c.toString()).execute(data);	
								else
									processed += c.toString();							
							}
						}
					}
				}
			}
		}
		catch (ex:Dynamic) { 
			#if debug
			throw(ex);
			#else
			processed += ex ;
			#end
		}
		return processed;
	}	
}