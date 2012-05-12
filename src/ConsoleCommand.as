package
{
	public class ConsoleCommand
	{
		static private var commandObjects:Array = new Array();
		
		static public function addCommand(name:String, 
										  callback:Function, 
										  appendSpaceOnAutoComplete:Boolean=true):void
		{
			commandObjects.push(
				{
					name:name,
					callback:callback,
					partials:generatePartialCommandMatches(name),
					appendSpace:appendSpaceOnAutoComplete
				}
			);
		}
		
		static private function generatePartialCommandMatches(name:String):Array
		{
			// given the input "exit", this function will return a
			// partials array ["e", "ex", "exi"]
			
			var partials:Array = new Array();
			
			for(var i:int = 0; i < name.length - 1; ++i)
				partials.push(name.substring(0, i + 1));
			
			return partials;
		}
		
		static private function matchPartial(input:String, commandObj:Object):String
		{
			// if the first character doesn't match, nothing else will
			if(input.charAt(0) != commandObj.partials[0])
				return null;
			
			for each(var partial:String in commandObj.partials)
			{
				if(partial == input)
					return partial;
			}
			
			return null;
		}
		
		static public function autoComplete(input:String):String
		{
			var matches:Array = new Array();
			
			// input "br" may match "brush" or "bristle" commands
			// if so return until the next input char is entered
			for each(var commandObj:Object in commandObjects)
			{
				var match:String = matchPartial(input, commandObj);
				if(match)
					matches.push(commandObj);
			}
			
			if(matches.length == 1)
			{
				// return trailing chars
				if(matches[0].appendSpace)
					return matches[0].name.substring(input.length) + " ";
				
				return matches[0].name.substring(input.length);
			}
			
			return null;
		}
		
		static public function process(input:String):void
		{
			var targetCommandObj:Object = null;
			var tokens:Array = input.split(" ");
			
			if(tokens.length > 0)
			{
				for each(var commandObj:Object in commandObjects)
				{
					if(commandObj.name == tokens[0])
					{
						targetCommandObj = commandObj;
						break;
					}
				}
				
				if(tokens.length > 1)
				{
					tokens.shift();
					targetCommandObj.callback.apply(null, tokens);
				}
				else
					targetCommandObj.callback();
			}
		}
		
	} // end class
} // end package