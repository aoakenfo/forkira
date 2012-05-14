package
{
	public class ConsoleCommand
	{
		static private var commandObjects:Array = new Array();
		
		static public function addCommand(name:String, 
										  callback:Function, 
										  appendSpaceOnAutoComplete:Boolean=true):void
		{
			commandObjects[name] = 
				{
					name:name,
					callback:callback,
					partials:generatePartialCommandMatches(name),
					appendSpace:appendSpaceOnAutoComplete
				};
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
			
			var input:String = input;
			if(input.search(";") != -1)
			{
				// multiple commands separated by ;
				// match last potential command
				var tokens:Array = input.split("; ");
				if(tokens.length > 0)
					input = tokens[tokens.length - 1];
			}
			
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
		
		static private function executeTokens(tokens:Array):void
		{	
			var targetCommandObj:Object = commandObjects[tokens[0]];
				
			if(targetCommandObj)
			{
				if(tokens.length > 1)
				{
					// first token is the command name; remaining are the params
					tokens.shift();
					targetCommandObj.callback.apply(null, tokens);
				}
				else // apply command with no params
					targetCommandObj.callback();
			}
		}
		
		static private function processQuotedInput(input:String):void
		{
			// we support *one* double quoted param in the form:
			// 		bind-key a "open pic.jpg; source-alpha 0.1; line-width 10"
			
			var inputTokens:Array = input.split(" \"");
			
			if(inputTokens.length == 2)
			{
				var exeTokens:Array = inputTokens[0].split(" ");
				
				// strip trailing double quote and add entire string as single param
				exeTokens.push(inputTokens[1].substring(0, inputTokens[1].length - 1));
				
				executeTokens(exeTokens);
			}
		}
		
		static public function processMultipleCommands(input:String):void
		{
			// we're executing a sequence of commands, for example:
			// 		open pic.jpg; source-alpha 0.1
			
			var inputTokens:Array = input.split("; ");
			
			// we don't support double quoted params when using ;
			for each(var inputCommand:String in inputTokens)
				executeTokens(inputCommand.split(" "));
		}
		
		static public function process(input:String):void
		{
			var targetCommandObj:Object = null;
			var tokens:Array = null;
			
			if(input.search('"') != -1)
				processQuotedInput(input);
			else if(input.search(";") != -1)
				processMultipleCommands(input);
			else
				executeTokens(input.split(" "));
		}
		
	} // end class
} // end package