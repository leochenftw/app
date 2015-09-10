package Classes
{
	import com.Leo.utils.pf;
	import com.Leo.utils.trim;
	
	import DataStructures.Forecast;

	public class ClsTranslate
	{
		private var arrayOfTokens:Array = [];
		private var aheadHours:int = Math.abs(Statics.HOURSAHEAD);
		private var forecast:Forecast;
		private var qnh:Object = null;
		private var minFound:Boolean = false;
		private var maxFound:Boolean = false;
		private var weatherFeedOn:Boolean = false;
		private var numTempo:int = 0;
		private var numBecoming:int = 0;
		private var varian:Object = null;
		private var year:int;
		private var month:int;
		private var altWind:Object = null;
		private var idx:int = 0;
		
		private var _replacementTags:Array = [];
		
		private var _callback:Function;
		public function ClsTranslate()
		{
			
		}
		
		public function translate(inString:String,callback:Function):void {
			if (trim(inString).length == 0) {
				if (callback) callback('You didn\'t input anything');
				return;
			}
			
			forecast = new Forecast;
			_callback = callback;
			inString = inString.replace(/\n/gi, " ");
			inString = inString.replace(/\r/gi, " ");
			inString = trim(inString);
			while (inString.indexOf('  ') >= 0) {
				inString = inString.replace(/  /gi,' ');
			}
			
			var rmCount:int = 0;
			if (inString.indexOf('TAF ') == 0) {
				rmCount = 4;
				forecast.type = 'Aerodrome forecast';
				if (inString.indexOf('TAF COR ') == 0) {
					rmCount = 8;
					forecast.type = 'Corrected Aerodrome Forecast';
				}
				
				if (inString.indexOf('TAF AMD ') == 0) {
					rmCount = 8;
					forecast.type = 'Amended Aerodrome Forecast';
				}
				inString = inString.substr(rmCount);
				forecast.typecode = 'TAF';
			}else {
				if (inString.indexOf('METAR ') == 0) {
					rmCount = 6;
					forecast.type = 'Aerodrome routine meteorological report';
					inString = inString.substr(rmCount);
					forecast.typecode = 'METAR';
					if (inString.indexOf(' AUTO ') > 0) {
						forecast.auto = true;
					}else{
						forecast.auto = false;
					}
					forecast.stacks = [];
					forecast.temp = '';
					forecast.dewpoint = '';
				}else if (inString.indexOf('SPECI ') == 0) {
					rmCount = 6;
					forecast.type = 'Special aerodrome meteorological report';
					inString = inString.substr(rmCount);
					forecast.typecode = 'SPECI';
					if (inString.indexOf(' AUTO ') > 0) {
						forecast.auto = true;
					}else{
						forecast.auto = false;
					}
					forecast.stacks = [];
					forecast.temp = '';
					forecast.dewpoint = '';
				}
			}
			
			if (inString.indexOf('//// // /////////') >= 0) {
				forecast.slashes = 'No visibility, present weather or cloud indications are available from this station';
			}
			
			if (inString.indexOf('NOSIG') > 0) {
				forecast.closure = 'No significant changes';
			}
			
			if (inString.indexOf('RMK') > 0) {
				forecast.remark = {rtype: '', degree: '', speed: '', string: ''};
				var inArr:Array = inString.split(' ');
				forecast.remark.rtype = inArr[inArr.indexOf('RMK')+1];
				var windParam:String = inArr[inArr.indexOf('RMK')+2];
				
				forecast.remark.string = '';
				for (var i:int = inArr.indexOf('RMK')+2; i < inArr.length; i++){
					forecast.remark.string += inArr[i];
				}
				
				var reWindKT:RegExp  = /^(\d{3}|VRB)(\d{2,3})(G\d{2,3})?(KT|MPS|KMH)$/;
				if(reWindKT.test(windParam))
				{
					var lcDegree:String = '';
					var lcSpeed:int = 0;
					// Wind token: dddss(s){Gss(s)}KT -- ddd is true direction, ss(s) speed in knots
					var myArray:Array = reWindKT.exec(windParam);
					lcDegree = myArray[1];
					lcSpeed = parseInt(myArray[2],10);
					forecast.remark.speed = lcSpeed.toString();
					forecast.remark.degree = lcDegree;
				}
				
			}
			metar_decode(inString);
		}
		
		private function add_output(text):void 
		{
			if (weatherFeedOn) {
				if (!varian) {
					forecast.initial.weather += text;
				}else{
					varian.weather+=text;
				}
			}
		}
		
		private function metar_decode(text:String):void {	
			
			// Join newline-separated pieces...
			var newlineJoined:String = text.replace(/\n/gi, " ").replace(/\r/gi," ");
			
			while (newlineJoined.indexOf('  ') >= 0) {
				newlineJoined = newlineJoined.replace(/  /gi,' ');
			}
			
			
			var equalPosition:int = newlineJoined.indexOf("=");
			if (equalPosition > -1)
			{
				trace("End of a METAR report is indicated by '='. We only decode until the first '='!!");
				newlineJoined = newlineJoined.substr(0,equalPosition);
			}
			
			
			arrayOfTokens = newlineJoined.split(" ");
			var numToken:int = 0;
			
			// Check if initial token is non-METAR date
			var reDate:RegExp = /^\d\d\d\d\/\d\d\/\d\d/;
			if (reDate.test(arrayOfTokens[numToken]))
				numToken++;
			
			// Check if initial token is non-METAR time
			var reTime:RegExp = /^\d\d:\d\d/;
			if (reTime.test(arrayOfTokens[numToken]))
				numToken++;
			
			// Check if initial token indicates type of report
			if(arrayOfTokens[numToken] == "METAR")
				numToken++;
			else if(arrayOfTokens[numToken] == "SPECI")
			{
//				add_output("Report is a SPECIAL report\n");
				numToken++;
			}
			
			
			// Parse location token
			if (arrayOfTokens[numToken].length == 4)
			{
				add_output("Location...........: " + arrayOfTokens[numToken] + "\n");
				forecast.location = findair(trim(arrayOfTokens[numToken]));
				
				if (forecast.typecode == 'SPECI') {
					if (forecast.location.toUpperCase() != 'NZWP' || forecast.location.toUpperCase() != 'NZOH' || forecast.location.toUpperCase() != 'NZMF') {
						trace('SPECI report is only issued for NZWP, NZOH, NZMF');
					}
				}
				
				numToken++;
			}
			else
			{
				trace('no airport code detected');
				/*add_output("Invalid report: malformed location token '" + arrayOfTokens[numToken] + "' \n-- it should be 4 characters long!");
				return;
				var inputCode:String = '';
				while (forecast.location.length == 0) {
					
					inputCode = trim(prompt('Please input the aerodrome code (4-5 letters)'));
					if (findair(inputCode).length > 0) {
						forecast.location = findair(inputCode);
						if (forecast.typecode == 'SPECI') {
							if (forecast.location.toUpperCase() != 'NZWP' || forecast.location.toUpperCase() != 'NZOH' || forecast.location.toUpperCase() != 'NZMF') {
								alert('SPECI report is only issued for NZWP, NZOH, NZMF');
							}
						}
					}
				}*/
				
			}
			
			
			// Parse date-time token -- we allow time specifications without final 'Z'
			
			if ( (
				( (arrayOfTokens[numToken].length == 7) &&
					(arrayOfTokens[numToken].charAt(6) == 'Z') ) ||
				( arrayOfTokens[numToken].length == 6 )
			) &&
				is_num_digit(arrayOfTokens[numToken].charAt(0)) &&
				is_num_digit(arrayOfTokens[numToken].charAt(1)) &&
				is_num_digit(arrayOfTokens[numToken].charAt(2)) &&
				is_num_digit(arrayOfTokens[numToken].charAt(3)) &&
				is_num_digit(arrayOfTokens[numToken].charAt(4)) &&
				is_num_digit(arrayOfTokens[numToken].charAt(5))    )
			{
				add_output("Day of month.......: " + arrayOfTokens[numToken].substr(0,2) + "\n");
				add_output("Time...............: " + arrayOfTokens[numToken].substr(2,2) +":" +
					arrayOfTokens[numToken].substr(4,2) + " UTC");
				var date:Date = new Date();
				year = date.getFullYear();
				month = date.getMonth()+1;
				forecast.utc = year +'-'+(month)+'-'+arrayOfTokens[numToken].substr(0,2)+' '+ arrayOfTokens[numToken].substr(2,2) +":" + arrayOfTokens[numToken].substr(4,2) + " UTC";
				var nzd:Number = pf(arrayOfTokens[numToken].substr(0,2));
				var nzh:Number = pf(arrayOfTokens[numToken].substr(2,2));
				if (nzh+aheadHours >= 24) {
					nzd+= Math.floor((nzh+aheadHours)/24);
					nzh=nzh+aheadHours-24;
					//nzd = nzd<10?('0'+nzd.toString()):nzd;
				}else{
					nzh+=aheadHours;
				}
				
				forecast.nzt = nzd+'/'+(month<10?('0'+(month)):(month))+'/'+year+' '+ (nzh>12?(nzh-12):nzh) +'.'+arrayOfTokens[numToken].substr(4,2)+(nzh>=12?'pm':'am');
				
				if(arrayOfTokens[numToken].length == 6)
					add_output(" (Time specification is non-compliant!)");
				
				add_output("\n");
				numToken++;
			}
			else
			{
				add_output("Time token not found or with wrong format!");
				return;
			}
			
			
			// Check if "AUTO" or "COR" token comes next.
			// not applicable
			/**/
			
			//validity
			var fromto:Array = arrayOfTokens[numToken].split('/');
			if (fromto.length == 2) {
				var from:Object = {date: fromto[0].substr(0,2), hour: fromto[0].substr(2,2)};
				var to:Object = {date: fromto[1].substr(0,2), hour: fromto[1].substr(2,2)};
				var remonth:String = month > 9?month.toString():('0'+month.toString());
				forecast.validity = year + '-' + remonth + '-' + from.date + ' ' + from.hour + ':00 to ' + year + '-' + remonth + '-'+to.date + ' ' + to.hour + ':00 UTC';
				
				numToken++;
			}else{
				if (arrayOfTokens[numToken] == "AUTO")
				{
					add_output("Report is fully automated, with no human intervention or oversight\n");
					numToken++;
				}
				else if (arrayOfTokens[numToken] == "COR")
				{
					add_output("Report is a correction over a METAR or SPECI report\n");
					numToken++;
				}
			}
			
			// Parse remaining tokens
			for (var i:int=numToken; i<arrayOfTokens.length; i++)
			{
				idx = i;
				if(arrayOfTokens[i].length > 0)
				{
					decode_token(arrayOfTokens[i].toUpperCase());
				}
			}
			
			if (varian) {
				forecast.varians.push(varian);
				//varian = null;
			}
			
			printOutput();
		}
		
		private function decode_token(token):void 
		{
			token = trim(token);
			// Check if token is "calm wind"
			if(token == "00000KT")
				
			{
				add_output("Wind...............: calm\n");
				return;
				
			}
			// Check if token is "calm wind"
			if(token == "00000MPS")
			{
				add_output("Wind...............: calm\n");
				return;
			}
			// Check if token is "calm wind"
			if(token == "00000KMH")
			{
				add_output("Wind...............: calm\n");
				return;
				
			}
			
			
			// Check if token is Wind indication
			var reWindKT:RegExp  = /^(\d{3}|VRB)(\d{2,3})(G\d{2,3})?(KT|MPS|KMH)$/;
			if(reWindKT.test(token))
			{
				var lcDegree:String = '';
				var lcSpeed:String = '';
				var lcUnit:String = '';
				var lcGust:String = '';
				var lcGustUnit:String = '';
				// Wind token: dddss(s){Gss(s)}KT -- ddd is true direction, ss(s) speed in knots
				var myArray:Array = reWindKT.exec(token);
				var units:String = myArray[4];
				add_output("Wind...............: ");
				if(myArray[1]=="VRB")
					add_output(" variable in direction");
				else
					add_output("true direction = " + myArray[1] + " degrees");
				add_output("; speed = " + parseInt(myArray[2],10));
				
				lcDegree = myArray[1];
				lcSpeed = parseInt(myArray[2],10).toString();
				
				/*forecast.initial.wind.d = myArray[1];
				forecast.initial.wind.s = parseInt(myArray[2],10);*/
				if(units=="KT") {
					add_output(" knots");
					lcUnit = 'knots';
				}else if(units=="KMH") {
					add_output(" km/h");
					lcUnit = 'km/h';
				}else if(units=="MPS") {
					add_output(" m/s");
					lcUnit = 'm/s';
				}
				
				if(myArray[3] != null)
				{
					if (myArray[3]!="")
					{
						add_output(" with gusts of " + parseInt(myArray[3].substr(1,myArray[3].length),10));
						//forecast.initial.wind.g.v = parseInt(myArray[3].substr(1,myArray[3].length),10);
						lcGust = parseInt(myArray[3].substr(1,myArray[3].length),10).toString();
						if(units=="KT") {
							add_output(" knots");
							lcGustUnit = 'knots';
						}else if(units=="KMH") {
							add_output(" km/h");
							lcGustUnit = 'km/h';
						}else if(units=="MPS") {
							add_output(" m/s");
							lcGustUnit = 'm/s';
						}
					}
				}
				
				if (!altWind && !varian) {
					forecast.initial.wind.d = lcDegree;
					forecast.initial.wind.s = lcSpeed;
					forecast.initial.wind.u = lcUnit;
					forecast.initial.wind.g.v = lcGust;
					forecast.initial.wind.g.u = lcGustUnit;
				}else{
					if (altWind) {
						altWind.degree = lcDegree;
						altWind.speed = lcSpeed;
						altWind.munit = lcUnit;
						altWind.gust.v = lcGust;
						altWind.gust.u = lcGustUnit;
						altWind.idx = forecast.varians.length;
						forecast.altitudeWind.push(altWind);
						altWind = null;
						return;
					}
					
					if (varian) {
						varian.wind.degree = lcDegree;
						varian.wind.speed = lcSpeed;
						varian.wind.munit = lcUnit;
						varian.wind.gust.v = lcGust;
						varian.wind.gust.u = lcGustUnit;
						return;
					}
				}
				
				add_output("\n");  return;
			}
			
			
			// Check if token is "variable wind direction"
			var reVariableWind:RegExp = /^(\d{3})V(\d{3})$/;
			if(reVariableWind.test(token))
			{
				// Variable wind direction: aaaVbbb, aaa and bbb are directions in clockwise order
				add_output("Wind direction.....: variable between "+token.substr(0,3)+" and "+token.substr(4,3)+" degrees \n");
				forecast.initial.wind.v.from = token.substr(0,3);
				forecast.initial.wind.v.to = token.substr(4,3);
				return;
			}
			
			
			
			// Check if token is visibility
			if (!qnh) {
				var reVis:RegExp;
				if (!varian) {
					reVis = /^\d{4}$/;
					if(reVis.test(token))
					{
						forecast.initial.visibility = reVis.exec(token)[0];
						if (forecast.initial.visibility == '9999') forecast.initial.visibility = '10 km or more';
						if (forecast.initial.visibility == '0000') forecast.initial.visibility = 'less than 50 m';
					}
					
					reVis = /^(\d{4})(N|S)?(E|W)?$/;
					if(reVis.test(token))
					{
						var lcArray:Array = reVis.exec(token);
						add_output("Visibility.........: ");
						if(lcArray[1]=="9999")
							add_output("10 km or more");
						else if (lcArray[1]=="0000")
							add_output("less than 50 m");
						else
							add_output(parseInt(lcArray[1],10) + " m");
						
						var dir:String = "";
						if(typeof lcArray[2] != "undefined")
						{
							dir=dir + lcArray[2];
						}
						if(typeof lcArray[3] != "undefined")
						{
							dir=dir + lcArray[3];
						}
						if(dir != "")
						{
							add_output(" direction ");
							if(dir=="N") add_output("North");
							else if(dir=="NE") add_output("North East");
							else if(dir=="E") add_output("East");
							else if(dir=="SE") add_output("South East");
							else if(dir=="S") add_output("South");
							else if(dir=="SW") add_output("South West");
							else if(dir=="W") add_output("West");
							else if(dir=="NW") add_output("North West");
						}
						add_output("\n"); return;
					}
				}else{
					
					reVis = /^\d{4}$/;
					if(reVis.test(token))
					{
						varian.visibility = reVis.exec(token)[0];
						if (varian.visibility == '9999') varian.visibility = '10 km or more';
						if (varian.visibility == '0000') varian.visibility = 'less than 50 m';
					}
				}
			}else{
				if (!minFound) {
					var reMin:RegExp = /MNM/;
					if (reMin.test(token)){
						minFound = true;
					}
				}else{
					var reQHNValue:RegExp = /^(\d{3,4})$/;
					if (reQHNValue.test(token)) {
						if (!maxFound) {
							qnh.mini = token;
						}else{
							qnh.maxi = token;
							forecast.presures.push(qnh);
							maxFound = minFound = false;
							qnh = null;
						}
					}else{
						maxFound = true;
					}
				}
				return;
			}
			//KM Visibility
			var reKMVis:RegExp = /^\d{2}KM$/;
			if(reKMVis.test(token))
			{
				var kmArray:Array = reKMVis.exec(token);
				if(kmArray[0]=="20KM") {
					forecast.initial.visibility = '20 kilometres';
				}else if(kmArray[0]=="00KM") {
					forecast.initial.visibility = 'less than 50 m'
				}else{
					forecast.initial.visibility = kmArray[0].replace(/KM/gi,' ') + 'kilometres'
				}
				return;
			}
			
			// Check if token is Statute-Miles visibility
			var reVisUS:RegExp = /(SM)$/;
			if(reVisUS.test(token))
			{
				add_output("Visibility: ");
				var myVisArray:Array = token.split("S");
				add_output(myVisArray[0]);
				add_output(" Statute Miles\n");
			}
			
			var reNZQNH:RegExp = /QNH/;
			if (reNZQNH.test(token)) {
				qnh = {
					from: '',
					to: '',
					mini: '',
					maxi: ''
				}
				if (varian) {
					forecast.varians.push(varian);
					varian = null;
				}
				return;
			}
			
			
			// Check if token is QNH indication in mmHg or hPa
			var reQNHhPa:RegExp = /Q\d{3,4}/;
			if(reQNHhPa.test(token))
			{	
				var digit:Number = pf(token.replace(/Q/gi,''));
				forecast.presures.push(digit);
				// QNH token: Qpppp -- pppp is pressure hPa 
				add_output("QNH (msl pressure).: ");
				add_output(parseInt(token.substr(1,4),10) + " hPa"); 
				add_output("\n");  return;
			}
			
			// Check if token is QNH indication in mmHg: Annnn
			var reINHg:RegExp = /A\d{4}/;
			if(reINHg.test(token))
			{
				add_output("QNH: ");
				add_output(token.substr(1,2) + "." + token.substr(3,4) + " inHg");
				add_output("\n");  return;
			} 
			
			
			// Check if token is NOSIG
			if(token == "NOSIG")
			{
				add_output("Next 2 hours.......: no significant changes\n");
				return;
			}
			
			
			
			// Check if token is runway visual range (RVR) indication
			var reRVR:RegExp = /^R(\d{2})(R|C|L)?\/(M|P)?(\d{4})(V\d{4})?(U|D|N)?$/;
			if(reRVR.test(token))
			{
				var myArray = reRVR.exec(token);
				
				add_output("Runway visibilty...: on runway ");
				var rwInfo = {side:'', index: '', trend:'', visibility: ''};
				add_output(myArray[1]);
				rwInfo.index = myArray[1];
				if(typeof myArray[2] != "undefined")
				{
					if(myArray[2]=="L") add_output(" Left");
					else if(myArray[2]=="R") add_output(" Right");
					else if(myArray[2]=="C") add_output(" Central");
					switch (myArray[2]) {
						case 'L':
							rwInfo.side = 'Left';
							break;
						case 'R':
							rwInfo.side = 'Right';
							break;
						case 'C':
							rwInfo.side = 'central';
							break;
					}
				}
				add_output(", touchdown zone visual range is ");
				if(typeof myArray[5] != "undefined")
				{
					// Variable range
					add_output("variable from a minimum of ");
					if(myArray[3]=="P") add_output("more than ");
					else if(myArray[3]=="M") add_output("less than ");
					add_output(myArray[4]);
					add_output(" meters");
					add_output(" until a maximum of "+myArray[5].substr(1,myArray[5].length)+" meters");
					if(myArray[5]=="P") add_output("more than ");
					
					
				}
				else
				{
					// Single value
					if( (typeof myArray[3] != "undefined") &&
						(typeof myArray[4] != "undefined")    )
					{
						if(myArray[3]=="P") add_output("more than ");
						else if(myArray[3]=="M") add_output("less than ");
						add_output(myArray[4]);
						add_output(" meters");
					}
					
				}
				if( (myArray.length > 5) && (typeof myArray[6] != "undefined") )
				{
					if(myArray[6]=="U") add_output(", and increasing");
					else if(myArray[6]=="D") add_output(", and decreasing");
					switch (myArray[6]) {
						case 'U':
							rwInfo.trend = 'upward tendency'
							break;
						case 'D':
							rwInfo.trend = 'downward tendency';
							break;
						case 'N':
							rwInfo.trend = 'no distinct tendency';
							break;
					}
				}
				add_output("\n");
				rwInfo.visibility = parseInt(myArray[4]);
				forecast.runway.push(rwInfo);
				return;
			}
			
			
			// Check if token is CAVOK
			if(token=="CAVOK")
			{
				add_output("CAVOK conditions...: Ceiling And Visibility OK, which means visibility 10 kilometers or more, no cloud below 5000 feet or below the minimum sector altitude (whichever is greater), no cumulonimbus, and no weather of significance to aviation at the aerodrome or its vicinity\n");
				if (varian) {
					varian.visibility = 'Cloud and visibility OK';
				}else{
					forecast.initial.visibility = 'Cloud and visibility OK';
				}
				return;
			}
			
			//Find tempo or becoming's time frame
			if (varian){
				var fromto:Array = token.split('/');
				if (fromto.length == 2) {
					varian.from = {date: fromto[0].substr(0,2), hour: fromto[0].substr(2,2)};
					varian.to = {date: fromto[1].substr(0,2), hour: fromto[1].substr(2,2)};
					//forecast.validity = year + '-' + month + '-' + from.date + ' ' + from.hour + ':00 Z to ' + year + '-' + month + '-'+to.date + ' ' + to.hour + ':00 Z';
					
				}else{
					var reFindVis:RegExp = /^(\d{4})$|^\d{2}KM$/;
					if (reFindVis.test(token)) {
						varian.visibility = reFindVis.exec(token)[0];
						//if (varian.visibility == '9999' || varian.visibility == '20KM'){
						if (varian.visibility == '9999'){
							varian.visibility = '10 km or more';
						}else if (varian.visibility == '0000' || varian.visibility == '00KM'){
							varian.visibility = 'less than 50 m';
						}
					}
				}
			}
			
			
			
			// Check if token is a present weather code - The regular expression is a bit
			// long, because several precipitation types can be joined in a token, and I
			// don't see a better way to get all the codes.
			var reWX:RegExp = /^(\-|\+|)?(VC)?(MI|BC|DR|BL|SH|TS|FZ|PR)?(DZ|RA|SN|SG|IC|PL|GR|GS)?(DZ|RA|SN|SG|IC|PL|GR|GS)?(DZ|RA|SN|SG|IC|PL|GR|GS)?(DZ|RA|SN|SG|IC|PL|GR|GS)?(SH|TS|DZ|RA|SN|SG|IC|PL|GR|GS|BR|FG|FU|VA|DU|SA|HZ|PO|SQ|FC|SS|DS)$/;
			if(reWX.test(token))
			{
				add_output("Weather............: ");
				var myArray = reWX.exec(token);
				weatherFeedOn = true;
				for(var i=1;i<myArray.length; i++)
				{
					if(myArray[i] == "-") add_output("light ");
					if(myArray[i] == "+") add_output("heavy ");
					if(myArray[i] == "VC") add_output("in the vicinity ");
					if(myArray[i] == "MI") add_output("shallow ");
					if(myArray[i] == "BC") add_output("patches of ");
					if(myArray[i] == "SH") add_output("shower(s) of ");
					if(myArray[i] == "TS") add_output("thunderstorm ");
					if(myArray[i] == "FZ") add_output("freezing ");
					if(myArray[i] == "PR") add_output("partial ");
					if(myArray[i] == "DZ") add_output("drizzle ");
					if(myArray[i] == "RA") add_output("rain ");
					if(myArray[i] == "SN") add_output("snow ");
					if(myArray[i] == "SG") add_output("snow grains ");
					if(myArray[i] == "IC") add_output("ice crystals ");
					if(myArray[i] == "PL") add_output("ice pellets ");
					if(myArray[i] == "GR") add_output("hail ");
					if(myArray[i] == "GS") add_output("small hail and/or snow pellets ");
					if(myArray[i] == "BR") add_output("mist ");
					if(myArray[i] == "FG") add_output(" fog ");
					if(myArray[i] == "FU") add_output("smoke ");
					if(myArray[i] == "VA") add_output("volcanic ash ");
					if(myArray[i] == "DU") add_output("widespread dust ");
					if(myArray[i] == "SA") add_output("sand ");
					if(myArray[i] == "HZ") add_output("haze ");
					if(myArray[i] == "PO") add_output("dust/sand whirls (dust devils)");
					if(myArray[i] == "SQ") add_output("squall ");
					if(myArray[i] == "FC") add_output("funnel cloud(s) (tornado or waterspout) ");
					if(myArray[i] == "SS") add_output("sandstorm ");
					if(myArray[i] == "DS") add_output("duststorm ");
					if(myArray[i] == "DR") add_output("low drifting ");
					if(myArray[i] == "BL") add_output("blowing ");
				}
				weatherFeedOn = false;
				forecast.initial.weather = trim(forecast.initial.weather);
				add_output("\n");  return;
			}
			
			
			// Check if token is recent weather observation
			var reREWX = /^RE(\-|\+)?(VC)?(MI|BC|BL|DR|SH|TS|FZ|PR)?(DZ|RA|SN|SG|IC|PL|GR|GS)?(DZ|RA|SN|SG|IC|PL|GR|GS)?(DZ|RA|SN|SG|IC|PL|GR|GS)?(DZ|RA|SN|SG|IC|PL|GR|GS)?(DZ|RA|SN|SG|IC|PL|GR|GS|BR|FG|FU|VA|DU|SA|HZ|PO|SQ|FC|SS|DS)?$/;
			if(reREWX.test(token))
			{
				add_output("Since the previous observation (but not at present), the following\nmeteorological phenomena were observed: ");
				var myArray = reREWX.exec(token);
				for(var i=1;i<myArray.length; i++)
				{
					if(myArray[i] == "-") add_output("light ");
					if(myArray[i] == "+") add_output("heavy ");
					if(myArray[i] == "VC") add_output("in the vicinity ");
					if(myArray[i] == "MI") add_output("shallow ");
					if(myArray[i] == "BC") add_output("patches of ");
					if(myArray[i] == "SH") add_output("shower(s) of ");
					if(myArray[i] == "TS") add_output("thunderstorm ");
					if(myArray[i] == "FZ") add_output("freezing ");
					if(myArray[i] == "PR") add_output("partial ");
					if(myArray[i] == "DZ") add_output("drizzle ");
					if(myArray[i] == "RA") add_output("rain ");
					if(myArray[i] == "SN") add_output("snow ");
					if(myArray[i] == "SG") add_output("snow grains ");
					if(myArray[i] == "IC") add_output("ice crystals ");
					if(myArray[i] == "PL") add_output("ice pellets ");
					if(myArray[i] == "GR") add_output("hail ");
					if(myArray[i] == "GS") add_output("small hail and/or snow pellets ");
					if(myArray[i] == "BR") add_output("mist ");
					if(myArray[i] == "FG") add_output("fog ");
					if(myArray[i] == "FU") add_output("smoke ");
					if(myArray[i] == "VA") add_output("volcanic ash ");
					if(myArray[i] == "DU") add_output("widespread dust ");
					if(myArray[i] == "SA") add_output("sand ");
					if(myArray[i] == "HZ") add_output("haze ");
					if(myArray[i] == "PO") add_output("dust/Sand whirls (dust devils) ");
					if(myArray[i] == "SQ") add_output("squall ");
					if(myArray[i] == "FC") add_output("funnel cloud(s) (tornado or waterspout) ");
					if(myArray[i] == "SS") add_output("sandstorm ");
					if(myArray[i] == "DS") add_output("duststorm ");
					if(myArray[i] == "DR") add_output("low drifting ");
					if(myArray[i] == "BL") add_output("blowing ");
					
				}
				add_output("\n"); return;
			}
			
			
			// Check if token is temperature / dewpoint pair
			var reTempDew = /^(M?\d\d|\/\/)\/(M?\d\d)?$/;
			if(reTempDew.test(token))
			{
				
				var myArray = reTempDew.exec(token);
				
				if(myArray[1].charAt(0)=='M')
					add_output("Temperature........: -" + myArray[1].substr(1,2) + " degrees Celsius\n");
				else
					add_output("Temperature........: " + myArray[1].substr(0,2) + " degrees Celsius\n");
				
				if(myArray[2]!="")
				{
					if(myArray[2].charAt(0)=='M')
						add_output("Dewpoint...........: -" + myArray[2].substr(1,2) + " degrees Celsius\n");
					else
						add_output("Dewpoint...........: " + myArray[2].substr(0,2) + " degrees Celsius\n");
				}
				forecast.temp = myArray[1] + " degrees Celsius";
				forecast.dewpoint = myArray[2] + " degrees Celsius";
				
				return;
			}
			
			
			// Check if token is "sky clear" indication
			if(token=="SKC")
			{
				/*add_output("no clouds and no restrictions on vertical visibility\n");
				return;*/
				if (!varian) {
					var lcCloud:Object = {type:'Sky clear',altitude:0}
					forecast.initial.clouds.push(lcCloud);
				}else{
					var vCloud:Object = {
						type: 'Sky clear',
						altitude: 0
					}
					varian.clouds.push(vCloud);
				}
			}
			
			if(token=="NCD") {
				if (!varian) {
					var lcCloud:Object = {type:'No cloud detected',altitude:0}
					forecast.initial.clouds.push(lcCloud);
				}else{
					var vCloud:Object = {
						type: 'No cloud detected',
						altitude: 0
					}
					varian.clouds.push(vCloud);
				}
			}
			
			// Check if token is "vertical visibility" indication
			var reVV = /^VV(\d{3}|\/{3})$/;
			if(reVV.test(token))
			{
				// VVddd -- ddd is vertical distance, or /// if unspecified
				var myArray = reVV.exec(token);
				add_output("Vertical visibility");
				if(myArray[1] == "///") {
					add_output(" has indefinite ceiling\n");
					forecast.vv = 'Indefinite';
				} else {
					add_output(": " + (100*parseInt(myArray[1],10)) + " feet\n");
					forecast.vv = (100*parseInt(myArray[1],10)).toString();
				}
				return;
			}
			
			if (!forecast.slashes) {
				if (token == '//' ||
					token == '///' ||
					token == '////' ||
					token == '//////' ||
					token == '/////////'){
					switch (token) {
						case '//':
							forecast.initial.weather = 'Weather not detected due sensor temporarily inoperative';
							break;
						case '///':
							forecast.initial.clouds.push('Cloud is detected (unable to determine TCU/CB)');
							break;
						case '////':
							forecast.initial.visibility = 'Visibility not reported';
							break;
						case '//////':
							forecast.initial.clouds.push('Cloud is detected (unable to determine TCU/CB)');
							break;
						case '/////////':
							forecast.initial.clouds.push('Cloud is detected (unable to determine TCU/CB)');
							break;
					}
					return;
				}
			}
			
			// Check if token is cloud indication
			var reCloud:RegExp = /^(FEW|SCT|BKN|OVC|CB|TCU)(\d{3})(CB|TCU|\/\/\/|\/\/)?$/;
			if(reCloud.test(token))
			{
				// Clouds: aaadddkk -- aaa indicates amount of sky covered, ddd distance over
				//                     aerodrome level, and kk the type of cloud.
				var myArray = reCloud.exec(token);
				add_output("Cloud coverage.....: ");
				if(myArray[1] == "FEW") add_output("few (1 to 2 oktas)");
				else if(myArray[1] == "SCT") add_output("scattered (3 to 4 oktas)");
				else if(myArray[1] == "BKN") add_output("broken (5 to 7 oktas)");
				else if(myArray[1] == "OVC") add_output("overcast (8 oktas)");
				var cloudType = '';
				var cloudHeight = '';
				var cloudExt = '';
				switch (myArray[1]) {
					case 'FEW':
						cloudType = 'Few cloud';
						break;
					case 'SCT':
						cloudType = 'Scattered cloud';
						break;
					case 'BKN':
						cloudType = 'Broken cloud';
						break;
					case 'OVC':
						cloudType = 'Overcast cloud';
						break;
					case 'CB':
						cloudType = 'Cumulonimbus cloud';
						break;
					case 'TCU':
						cloudType = 'Towering cumulus cloud';
						break;
				}
				
				add_output(" at " + (100*parseInt(myArray[2],10)) + " feet above aerodrome level");
				cloudHeight = 100*parseInt(myArray[2],10);
				//if (myArray[1] == 'SCT') trace(myArray[2]);
				if(myArray[3] == "CB") {
					add_output(" cumulonimbus");
					cloudType = 'Cumulonimbus cloud';
				}else if(myArray[3] == "TCU") {
					add_output(" towering cumulus");
					cloudType = 'Towering cumulus cloud';
				}else if (myArray[3] == "//") {
					cloudExt = 'Weather not detected due sensor temporarily inoperative';
				}else if (myArray[3] == '///') {
					cloudExt = 'Cloud is detected, but unable to determine if TCU/CB present';
				}
				
				
				if (!varian) {
					if (forecast.typecode == 'TAF'){
						var lcCloud = {
							type: cloudType,
							altitude: cloudHeight
						}
						forecast.initial.clouds.push(lcCloud);
					}else{
						if (!forecast.stacks) {
							forecast.stacks = [];
						}
						forecast.stacks.push({type: cloudType, altitude: cloudHeight, ext: cloudExt});
					}
				}else{
					var vCloud = {
						type: cloudType,
						altitude: cloudHeight
					}
					varian.clouds.push(vCloud);
				}
				
				add_output("\n"); return; 
			}
			
			//find altitude wind start
			var reAltWind:RegExp = /^\d{1,}FT$/;
			if (reAltWind.test(token))
			{
				if (idx != arrayOfTokens.length-1){
					if (arrayOfTokens[idx+1] == 'WIND'){
						var lcType:String = '';
						if (arrayOfTokens[idx-1] == 'TEMPO' || arrayOfTokens[idx-1] == 'BECMG') {
							lcType = arrayOfTokens[idx-1] == 'TEMPO'?'Temporarily':'Becoming';
							varian = null;
						}else{
							lcType = 'Standard';
						}
						altWind = {
							idx: 0,
							type: lcType,
							altitude: pf(token.replace(/FT/g,'')),
							degree: 0,
							speed: 0,
							munit: '',
							gust: {v:'',u:''}
						}
					}
				}
				
				return;
			}
			
			
			// Check if token is part of a wind-shear indication
			var reRWY:RegExp = /^RWY(\d{2})(L|C|R)?$/;
			if(token=="WS")       { add_output("there is wind-shear in "); return; }
			else if(token=="ALL") { add_output("all "); return; }
			else if(token=="RWY") { add_output("runways\n"); return; }
			else if (reRWY.test(token))
			{
				var myArray = reRWY.exec(token);
				add_output("runway "+myArray[1]);
				if(myArray[2]=="L")      add_output(" Left");
				else if(myArray[2]=="C") add_output(" Central");
				else if(myArray[2]=="R") add_output(" Right");
				add_output("\n");
				return;
			}
			
			
			// Check if token is no-significant-weather indication
			if(token=="NSW")
			{
				add_output("no significant weather\n");
				return;
			}
			
			
			// Check if token is no-significant-clouds indication
			if(token=="NSC")
			{
				add_output("Clouds.............: no significant clouds are observed below 5000 feet or below the minimum sector altitude (whichever is higher)\n");
				return;
			}
			
			
			// Check if token is part of trend indication
			if(token=="BECMG")
			{
				add_output("Next 2hrs gradually:\n");
				if (varian) {
					forecast.varians.push(varian);
					varian = null;
				}
				varian = {
					type: 'Becoming',
					from: '',
					to: '',
					visibility: '',
					weather: '',
					clouds: [],
					wind: {
						degree: 0,
						speed: 0,
						munit: '',
						gust: {v:'',u:''}
					}
				};
				numBecoming++;
				return;
			}
			if(token=="TEMPO")
			{
				add_output("Next 2hrs temporary:\n");
				if (varian) {
					forecast.varians.push(varian);
					varian = null;
				}
				varian = {
					type: 'Temporarily',
					from: '',
					to: '',
					visibility: '',
					weather: '',
					clouds: [],
					wind: {
						altitude: 0,
						degree: 0,
						speed: 0,
						munit: '',
						gust: {v:'',u:''}
					}
				};
				numTempo++;
				return;
			}
			var reFM = /^FM(\d{2})(\d{2})Z?$/;
			if(reFM.test(token))
			{
				var myArray = reFM.exec(token);
				add_output("From "+myArray[1]+":"+myArray[2]+" UTC.....:\n");
				return;
			}
			//FM NZ
			var reFMNZ = /^FM(\d{2})(\d{2})(\d{2})$/;
			if(reFMNZ.test(token))
			{
				if (varian) {
					forecast.varians.push(varian);
					varian = null;
				}
				varian = {
					type: 'From',
					from: '',
					visibility: '',
					weather: '',
					clouds: [],
					wind: {
						degree: 0,
						speed: 0,
						munit: '',
						gust: {v:'',u:''}
					}
				};
				var myArray = reFMNZ.exec(token);
				//varian.from = year + '-' + month + '-' + myArray[1] + ' ' + myArray[2] + ':' + myArray[3];
				varian.from = myArray[2] + ':' + myArray[3];
				return;
			}
			
			var reTL = /^TL(\d{2})(\d{2})Z?$/;
			if(reTL.test(token))
			{
				var myArray = reTL.exec(token);
				add_output("Until "+myArray[1]+":"+myArray[2]+" UTC....:\n");
				return;
			}
			var reAT = /^AT(\d{2})(\d{2})Z?$/;
			if(reAT.test(token))
			{
				var myArray = reAT.exec(token);
				add_output("At "+myArray[1]+":"+myArray[2]+" UTC.......:\n");
				return;
			}
			
			
			
			
			// Check if item is runway state group
			var reRSG = /^(\d\d)(\d|C|\/)(\d|L|\/)(\d\d|RD|\/)(\d\d)$/;
			if(reRSG.test(token))
			{
				var myArray = reRSG.exec(token);
				add_output("Runway state.......:");
				
				// Runway designator (first 2 digits)
				var r = parseInt(myArray[1],10);
				if(r < 50) add_output(" Runway " + myArray[1] + " (or "+myArray[1]+" Left): ");
				else if(r < 88) add_output(" Runway " + (r-50) + " Right: ");
				else if(r == 88) add_output(" All runways: ");
				
				// Check if "CLRD" occurs in digits 3-6
				if(token.substr(2,4)=="CLRD") add_output("clear, ");
				else
				{
					// Runway deposits (third digit)
					if(myArray[2]=="0") add_output("clear and dry, ");
					else if(myArray[2]=="1") add_output("damp, ");
					else if(myArray[2]=="2") add_output("wet or water patches, ");
					else if(myArray[2]=="3") add_output("rime or frost covered, ");
					else if(myArray[2]=="4") add_output("dry snow, ");
					else if(myArray[2]=="5") add_output("wet snow, ");
					else if(myArray[2]=="6") add_output("slush, ");
					else if(myArray[2]=="7") add_output("ice, ");
					else if(myArray[2]=="8") add_output("compacted or rolled snow, ");
					else if(myArray[2]=="9") add_output("frozen ruts or ridges, ");
					else if(myArray[2]=="/") add_output("deposit not reported, ");
					
					// Extent of runway contamination (fourth digit)
					if(myArray[3]=="1") add_output("contamination 10% or less, ");
					else if(myArray[3]=="2") add_output("contamination 11% to 25%, ");
					else if(myArray[3]=="5") add_output("contamination 26% to 50%, ");
					else if(myArray[3]=="9") add_output("contamination 51% to 100%, ");
					else if(myArray[3]=="/") add_output("contamination not reported, ");
					
					// Depth of deposit (fifth and sixth digits)
					if(myArray[4]=="//") add_output("depth of deposit not reported, ");
					else
					{
						var d = parseInt(myArray[4],10);
						if(d == 0) add_output("deposit less than 1 mm deep, ");
						else if ((d >  0) && (d < 91)) add_output("deposit is "+d+" mm deep, ");
						else if (d == 92) add_output("deposit is 10 cm deep, ");
						else if (d == 93) add_output("deposit is 15 cm deep, ");
						else if (d == 94) add_output("deposit is 20 cm deep, ");
						else if (d == 95) add_output("deposit is 25 cm deep, ");
						else if (d == 96) add_output("deposit is 30 cm deep, ");
						else if (d == 97) add_output("deposit is 35 cm deep, ");
						else if (d == 98) add_output("deposit is 40 cm or more deep, ");
						else if (d == 99) add_output("runway(s) is/are non-operational due to snow, slush, ice, large drifts or runway clearance, but depth of deposit is not reported, ");
					}
				}
				
				// Friction coefficient or braking action (seventh and eighth digit)
				if(myArray[5]=="//") add_output("braking action not reported");
				else
				{
					var b = parseInt(myArray[5],10);
					if(b<91) add_output("friction coefficient 0."+myArray[5]);
					else
					{
						if(b == 91) add_output("braking action is poor");
						else if(b == 92) add_output("braking action is medium/poor");
						else if(b == 93) add_output("braking action is medium");
						else if(b == 94) add_output("braking action is medium/good");
						else if(b == 95) add_output("braking action is good");
						else if(b == 99) add_output("braking action figures are unreliable");
					}
				}
				add_output("\n"); return;
			} 
			
			if(token=="SNOCLO")
			{
				add_output("Aerodrome is closed due to snow on runways\n");
				return;
			}
			
			// Check if item is sea status indication
			var reSea:RegExp = /^W(M)?(\d\d)\/S(\d)/;
			if(reSea.test(token))
			{
				var myArray = reSea.exec(token);
				add_output("Sea surface temperature: ");
				if(myArray[1]=="M")
					add_output("-");
				add_output(parseInt(myArray[2],10) + " degrees Celsius\n");
				
				add_output("Sea waves have height: ");
				if(myArray[3]=="0") add_output("0 m (calm)\n");
				else if(myArray[3]=="1") add_output("0-0,1 m\n");
				else if(myArray[3]=="2") add_output("0,1-0,5 m\n");
				else if(myArray[3]=="3") add_output("0,5-1,25 m\n");
				else if(myArray[3]=="4") add_output("1,25-2,5 m\n");
				else if(myArray[3]=="5") add_output("2,5-4 m\n");
				else if(myArray[3]=="6") add_output("4-6 m\n");
				else if(myArray[3]=="7") add_output("6-9 m\n");
				else if(myArray[3]=="8") add_output("9-14 m\n");
				else if(myArray[3]=="9") add_output("more than 14 m (huge!)\n");
				return;
			}
		}
		
		private function sectionMaker(title:String,content:String):String {
			var container:String = '<b>'+title.toUpperCase()+'</b>';
			container += '<br>';
			container += '<font color="#305178" size="'+int(Statics.STAGEHEIGHT*0.03125).toString()+'">'+content+'</font>';
			container += '<br>';
			container += '<br>';
			return container;
		}
		
		private function printOutput():void {
			
			var translation:String = forecast.type+'<br>---------------------<br><br>';
			Statics.PAGEOUT.title = 'DECODED '+forecast.typecode.toUpperCase();
			//var location = $(outputer.clone());
			var lcUTC:Array = forecast.utc.split(' ');
			var lcNZ:Array = forecast.nzt.split(' ');//' Z (NZ Time: ' + lcNZ[1] + ')' );
			translation += sectionMaker('Location',forecast.location + ' @ <i>' + lcUTC[1] + ' UTC (' + lcNZ[1] + ' Local)</i>');
			if (forecast.validity.length > 0) {
				var strValidity:String = '<strong style="font-size: 12px;">UTC</strong><br><i>';
				var pureValidty:String = forecast.validity.replace(/UTC/gi,'');
				strValidity += pureValidty + '</i><br><strong style="font-size: 12px;">Local</strong><br><i>';
				strValidity += toLocal(pureValidty.split(' to ')[0]) + ' to ' + toLocal(pureValidty.split(' to ')[1]) + '</i>';
				translation += sectionMaker('Validity',strValidity);
			}else{
				translation += sectionMaker('',(forecast.auto?'METAR produced by an automatic weather station':''));
			}
			
			if (forecast.initial.weather.length > 0) {
				translation += sectionMaker('Present Weather',capit(forecast.initial.weather));
			}
			
			
			var windCondition:String = '';
			if (forecast.initial.wind.d.toString().length > 0){
				if (forecast.initial.wind.d != 'VRB') {
					windCondition += parseInt(forecast.initial.wind.d) + '° true ('+magnetic(forecast.initial.wind.d)+' magnetic), ' + forecast.initial.wind.s + ' ' + forecast.initial.wind.u;
					if (forecast.initial.wind.g.v.toString().length > 0) {
						windCondition += ' with gusts of ' + forecast.initial.wind.g.v + ' ' + forecast.initial.wind.g.u;
					}
					if (forecast.initial.wind.v.from.toString().length > 0 && forecast.initial.wind.v.to.toString().length > 0) {
						windCondition += '; Varying between ' + forecast.initial.wind.v.from + '° and ' + forecast.initial.wind.v.to + '° true ('+magnetic(forecast.initial.wind.v.from)+' - '+magnetic(forecast.initial.wind.v.to)+' magnetic)';
					}
				}else{
					windCondition += 'Variable in direction, ' + forecast.initial.wind.s + ' ' + forecast.initial.wind.u;
				}
				translation += sectionMaker('Wind',windCondition);
			}
			
			var visibilityCondition:String = forecast.initial.visibility.toString().length > 0? forecast.initial.visibility: '';
			if (visibilityCondition.length > 0){
				var check:RegExp = /^\d{4}$/;
				if (check.test(visibilityCondition)) {
					visibilityCondition = parseInt(visibilityCondition) + ' M';
				}
			}
			translation += sectionMaker('Visibility',visibilityCondition);
			
			var cloudCondition:String = '';
			var iCloud:int = 0;
			forecast.initial.clouds.forEach(function(cloud) {
				if (typeof(cloud) == 'object') {
					if (cloud.type.length > 0) {
						cloudCondition += (iCloud > 0?', ':'')+cloud.type;
						if (cloud.altitude.toString().length > 0 && pf(cloud.altitude)>0) cloudCondition += (' at '+ parseInt(cloud.altitude) + ' feet');
					}
				}else{
					cloudCondition += cloud;
				}
				iCloud++;
			});
			if (cloudCondition.length > 0) {
				translation += sectionMaker('Cloud',cloudCondition);
			}
			if (forecast.vv.length > 0 && pf(forecast.vv) >= 0) {
				translation += sectionMaker('Vertical Visibility',forecast.vv + ' ft');
			}
			
			if (forecast.dewpoint != null && forecast.temp != null) {
				if (forecast.temp.length > 0 && forecast.dewpoint.length > 0) {
					translation += sectionMaker('Temperature',parseInt(forecast.temp) + ' degrees Celsius');
					translation += sectionMaker('Dew point',parseInt(forecast.dewpoint) + ' degrees Celsius');
				}
			}
			
			//forecast.varians.forEach(function(varian) {
			for (var n:int = 0; n < forecast.varians.length; n++){
				var varian:* = forecast.varians[n];
				var from:String = '';
				var to:String = '';
				var title:String = varian.type;
				var contentStr:String = '';
				if (varian.type!='From') {
					/*from = year + '-' + month + '-' + varian.from.date + ' ' + varian.from.hour + ':00 Z';
					to = year + '-' + month + '-' + varian.to.date + ' ' + varian.to.hour + ':00 Z';*/
					from = varian.from.hour + ':00 UTC';
					to = varian.to.hour + ':00 UTC';
					if (forecast.typecode == 'METAR') {
						//title = varian.type;
					}else{
						contentStr = '<i>' + from.replace(/utc/gi,'') + ' - ' + to.replace(/utc/gi,'') + ' UTC';
						contentStr += ' (' + nzt(from.split(' ')[0]) + ' - ' + nzt(to.split(' ')[0]) + ' Local)</i>';
						/*title = varian.type + ' ' + from + ' - ' + to;
						title += ' (' + nzt(from.split(' ')[0]) + ' - ' + nzt(to.split(' ')[0]) + ' Local)';*/
					}
				}else{
					if (forecast.typecode == 'METAR') {
						//title = varian.type;
					}else{
						//title = varian.type + ' '  + varian.from + ' UTC ('+nzt(varian.from)+' Local)';
						contentStr = '<i>' +  varian.from + ' UTC ('+nzt(varian.from)+' Local)</i>';
					}
				}
				
				
				/*var weatherCondition = '';
				
				if (varian.weather.length > 0) {
				weatherCondition += varian.weather;
				}*/
				var cloudCondition:String = '';
				var cloudIndex:int = 0;
				varian.clouds.forEach(function(cloud) {
					if (cloud.type.length > 0) {
						cloudCondition += cloud.type;
						if (cloud.altitude.toString().length > 0) cloudCondition += (' at '+ parseInt(cloud.altitude) + ' feet');
						if (cloudIndex < varian.clouds.length - 1) {
							cloudCondition += ', ';
						}
					}
					cloudIndex++;
				});
				if (cloudCondition.length > 0) {
					contentStr += '<br>Cloud: ' + cloudCondition;
				}
				
				var visibilityCondition:String = varian.visibility.toString().length > 0? varian.visibility: '';
				if (visibilityCondition.length > 0){
					var check:RegExp = /^\d{4}$/;
					if (check.test(visibilityCondition)) {
						visibilityCondition = parseInt(visibilityCondition) + ' M';
					}
				}
				if (visibilityCondition.length > 0) {
					contentStr += '<br>Visibility: ' + visibilityCondition;
				}
				
				if (varian.weather.length > 0) {
					contentStr += '<br>Weather: ' + varian.weather;
				}
				
				//°
				var windCondition:String = '';
				
				if (varian.wind.degree.toString().length > 0 && pf(varian.wind.degree) > 0 && pf(varian.wind.speed) > 0){
					windCondition += parseInt(varian.wind.degree) + '° true ('+magnetic(varian.wind.degree)+' magnetic), ' + varian.wind.speed + ' ' + varian.wind.munit;
					if (varian.wind.gust.v.toString().length > 0) {
						windCondition += ' with gusts of ' + varian.wind.gust.v + ' ' + varian.wind.gust.u;
					}
				}else if (varian.wind.degree == 'VRB'){
					windCondition += 'Variable in direction, ' + varian.wind.speed + ' ' + varian.wind.munit;
				}
				if (windCondition.length > 0) {
					contentStr += '<br>Wind: ' + windCondition;
				}
				
				translation += sectionMaker(title, contentStr);
				translation += '<br>[TO-BE-REPLACED-'+n.toString()+']';
				_replacementTags.push('<br>[TO-BE-REPLACED-'+n.toString()+']');
			}
			
			if (forecast.altitudeWind.length > 0) {
				//forecast.altitudeWind.forEach(function(o:Object):void {
				for (var j:int = 0; j<forecast.altitudeWind.length;j++){
					var o:Object = forecast.altitudeWind[j];
					var awStr:String = '';
					if (o.degree.toString().length > 0 && pf(o.degree) > 0 && pf(o.speed) > 0){
						awStr += parseInt(o.degree) + '° true ('+magnetic(o.degree)+' magnetic), ' + o.speed + ' ' + o.munit;
						if (o.gust.v.toString().length > 0) {
							awStr += ' with gusts of ' + o.gust.v + ' ' + o.gust.u;
						}
					}else if (o.degree == 'VRB'){
						awStr += 'Variable in direction, ' + o.speed + ' ' + o.munit;
					}
					
					var tmp:String = sectionMaker('Wind from ' + o.altitude + ' ft: ', awStr);
					translation = translation.replace('[TO-BE-REPLACED-'+j.toString()+']',tmp);
				}
			}
			
			//_replacementTags.forEach(function(tag:String):void {
			for (var k:int = 0; k < _replacementTags.length; k++){
				translation = translation.replace(_replacementTags[k],'');
			}
			
			_replacementTags = [];
			
			var strWeather:String = '';
			if (forecast.slashes) {
				strWeather += '<i>' + forecast.slashes + '</i>';
			}
			
			translation += sectionMaker('', strWeather);
			
			
			if (forecast.runway.length > 0) {
				forecast.runway.forEach(function(rwInfo):void {
					translation += sectionMaker('Runway ' + rwInfo.index + ' ' + rwInfo.side, 'Visibility: ' + rwInfo.visibility + ' metres, <br>' + rwInfo.trend);
				});
			}
			
			
			
			if (forecast.stacks) {
				//forecast.stacks.forEach(function(cloud):void {
				for each(var cloud:Object in forecast.stacks) {
					
					if (cloud.altitude.toString().length > 0 && cloud.altitude > 0){
						var stackingTitle:String = 'Cloud at ' + parseInt(cloud.altitude) + ' ft'; 
						var stackingCloud:String = cloud.type + (cloud.ext.length > 0?' ('+cloud.ext+')':'');
						
						translation += sectionMaker(stackingTitle,stackingCloud);
					}
				}
			}
			
			var pressureCondition:String = '';
			if (forecast.presures.length > 0) {
				if (forecast.presures.length == 1) {
					if (typeof(forecast.presures[0]) == 'object') {
						pressureCondition += parseInt(forecast.presures[0].mini) + 'hPa - ' + parseInt(forecast.presures[0].maxi) + 'hPa';
					}else{
						pressureCondition += parseInt(forecast.presures[0]) + 'hPa';
					}
					translation += sectionMaker('Pressure Setting', pressureCondition);
				}else{
					for each (var digit:Object in forecast.presures){
						translation += sectionMaker('Pressure setting',digit.mini + 'hPa - ' + digit.maxi + 'hPa');
					}
				}
			}
			
			
			if (forecast.closure.length>0) {
				translation += sectionMaker('',forecast.closure);
			}
			if (forecast.remark != null) {
				var rewind:String = 'Remarks: ' + forecast.remark.rtype + ' ';
				if (!isNaN(parseInt(forecast.remark.degree))){
					rewind += 'wind from ' + parseInt(forecast.remark.degree) + '° true ('+magnetic(forecast.remark.degree)+' magnetic) at '+ forecast.remark.speed + ' knots';
				}else{
					rewind += forecast.remark.string;
				}
				
				translation += sectionMaker('', rewind);
			}
			
			//trace(translation);
			forecast.destruct();
			forecast = null;
			if (_callback) _callback(translation);
			
			
//			return;
//			for (var key in forecast) {
//				if (forecast.hasOwnProperty(key)) {
//					var property = forecast[key];
//					switch (typeof(property)) {
//						case 'string':
//							trace( key + ' -> ' + property);
//							switch (key) {
//								case 'type':
//									
//									break;
//							}
//							break;
//						case 'object':
//							if (property.length == undefined) {
//								trace(key + ': ');
//								nutCracker(property);
//							}else{
//								trace(key + ' (array): ');
//								property.forEach(function(o){
//									nutRecogniser(o);
//								});
//							}
//							break;
//					}
//					
//				}
//			}
		}
		
//		private function nutCracker(o):void {
//			for (var key in o) {
//				if (o.hasOwnProperty(key)) {
//					var property = o[key];
//					switch (typeof(property)) {
//						case 'string':
//							trace( key + ' -> ' + property);
//							break;
//						case 'object':
//							if (property.length == undefined) {
//								trace(key + ': ');
//								nutCracker(property);
//							}
//							break;
//					}
//				}
//			}
//		}
//		
//		private function nutRecogniser(o):void {
//			switch (typeof(o)) {
//				case 'string':
//					trace(o);
//					break;
//				case 'object':
//					if (o.length == undefined) {
//						nutCracker(o);
//					}
//					break;
//			}
//		}
		
		private function magnetic(dgree:String):String {
			var mag:int = int(dgree)-20;
			mag = mag<0?(360+mag):mag;
			return mag+'°';
		}
		
		private function capit(string:String):String
		{
			return string.charAt(0).toUpperCase() + string.slice(1);
		}
		
		
		private function toLocal(utc):String {
			var datePart:Array = utc.split(' ')[0].split('-');
			var reStr:String = datePart[1] + '/' + datePart[2] + '/' + datePart[0] + ' ' + utc.split(' ')[1] + ' ' + 'UTC';
//			trace(reStr);
			var reDate:Date = new Date(reStr);
			var outStr:String = reDate.getFullYear() + '-' + (reDate.getMonth()+1 > 9?reDate.getMonth()+1:('0'+(reDate.getMonth()+1))) + '-' + (reDate.getDate() > 9?reDate.getDate():('0'+(reDate.getDate())));
			outStr += (' ' + (reDate.getHours() > 9?reDate.getHours():('0'+(reDate.getHours()))) + ':' + (reDate.getMinutes() > 9?reDate.getMinutes():('0'+(reDate.getMinutes()))));
			return outStr;
		}
		
		private function findair(code:String):String {
			code = code.toUpperCase();
			var recode:String = '';
			switch (code) {
				case 'NZAA':
					recode = 'Auckland Aerodrome';
					break;
				case 'NZAP':
					recode = 'Taupo Aerodrome';
					break;
				case 'NZAR':
					recode = 'Ardmore Aerodrome';
					break;
				case 'NZASA':
					recode = 'Ashburton';
					break;
				case 'NZAUX':
					recode = 'Arthurs Pass';
					break;
				case 'NZBNW':
					recode = 'Bean Rock';
					break;
				case 'NZBRX':
					recode = 'Brothers Island';
					break;
				case 'NZBWX':
					recode = 'Birchwood';
					break;
				case 'NZCCX':
					recode = 'Cape Campbell';
					break;
				case 'NZCH':
					recode = 'Christchurch Aerodrome';
					break;
				case 'NZCI':
					recode = 'Chatham Is. Aerodrome';
					break;
				case 'NZCKX':
					recode = 'Cape Kidnappers';
					break;
				case 'NZCLW':
					recode = 'Channel Island';
					break;
				case 'NZCNW':
					recode = 'Centre Island';
					break;
				case 'NZCPX':
					recode = 'Castlepoint';
					break;
				case 'NZCRX':
					recode = 'Cape Reinga';
					break;
				case 'NZCTX':
					recode = 'Cape Turnagain';
					break;
				case 'NZCU':
					recode = 'Culverden Aerodrome';
					break;
				case 'NZDN':
					recode = 'Dunedin Aerodrome';
					break;
				case 'NZERX':
					recode = 'East Rangataiki';
					break;
				case 'NZFAX':
					recode = 'Fairlie';
					break;
				case 'NZFHX':
					recode = 'Flat Hills';
					break;
				case 'NZFJX':
					recode = 'Franz Josef';
					break;
				case 'NZFSX':
					recode = 'Farewell Spit';
					break;
				case 'NZFWW':
					recode = 'Cape Foulwind';
					break;
				case 'NZGAX':
					recode = 'Galatea';
					break;
				case 'NZGCE':
					recode = 'Gore';
					break;
				case 'NZGMW':
					recode = 'Great Mercury Island';
					break;
				case 'NZGS':
					recode = 'Gisborne Aerodrome';
					break;
				case 'NZGVX':
					recode = 'Golden Valley Wahi';
					break;
				case 'NZHAX':
					recode = 'Hawera';
					break;
				case 'NZHHX':
					recode = 'Hokitika South';
					break;
				case 'NZHIX':
					recode = 'Hicks Bay';
					break;
				case 'NZHK':
					recode = 'Hokitika Aerodrome';
					break;
				case 'NZHN':
					recode = 'Hamilton Aerodrome';
					break;
				case 'NZHOX':
					recode = 'Hokianga';
					break;
				case 'NZHTX':
					recode = 'Haast';
					break;
				case 'NZJKX':
					recode = 'Kaitaia Hospital';
					break;
				case 'NZJTX':
					recode = 'Taumarunui';
					break;
				case 'NZKAW':
					recode = 'Cape Karikari';
					break;
				case 'NZKHW':
					recode = 'Kaipara Harbour';
					break;
				case 'NZKI':
					recode = 'Kaikoura Aerodrome';
					break;
				case 'NZKK':
					recode = 'Kerikeri/Bay of Islands Aerodrome';
					break;
				case 'NZKLX':
					recode = 'Kelburn';
					break;
				case 'NZKOE':
					recode = 'Kaikohe';
					break;
				case 'NZKRW':
					recode = 'Tongue Point';
					break;
				case 'NZKT':
					recode = 'Kaitaia Aerodrome';
					break;
				case 'NZKXX':
					recode = 'Koromiko';
					break;
				case 'NZLBX':
					recode = 'LeBons Bay';
					break;
				case 'NZLNX':
					recode = 'Levin';
					break;
				case 'NZLUX':
					recode = 'Lumsden';
					break;
				case 'NZLX':
					recode = 'Alexandra Aerodrome';
					break;
				case 'NZLXA':
					recode = 'Alexandra';
					break;
				case 'NZLYX':
					recode = 'Lyttleton';
					break;
				case 'NZMAX':
					recode = 'Mahia Radar';
					break;
				case 'NZMC':
					recode = 'Mount Cook Aerodrome';
					break;
				case 'NZMCA':
					recode = 'Mount Cook';
					break;
				case 'NZMDX':
					recode = 'Mid Dome';
					break;
				case 'NZMF':
					recode = 'Milford Sound Aerodrome';
					break;
				case 'NZMHX':
					recode = 'Mahia';
					break;
				case 'NZMKW':
					recode = 'Manakau Heads';
					break;
				case 'NZMMX':
					recode = 'Mamuka Radar';
					break;
				case 'NZMNX':
					recode = 'Mana Island';
					break;
				case 'NZMO':
					recode = 'Te Anau/Manapouri Aerodrome';
					break;
				case 'NZMS':
					recode = 'Masterton Aerodrome';
					break;
				case 'NZMSX':
					recode = 'East Taratahi';
					break;
				case 'NZMUX':
					recode = 'Mokohinau Island';
					break;
				case 'NZMXW':
					recode = 'Moeraki';
					break;
				case 'NZNBX':
					recode = 'New Brighton Pier';
					break;
				case 'NZNGX':
					recode = 'Nugget Point';
					break;
				case 'NZNP':
					recode = 'New Plymouth Aerodrome';
					break;
				case 'NZNR':
					recode = 'Napier Aerodrome';
					break;
				case 'NZNS':
					recode = 'Nelson Aerodrome';
					break;
				case 'NZNV':
					recode = 'Invercargill Aerodrome';
					break;
				case 'NZNWX':
					recode = 'Ngawihi';
					break;
				case 'NZOH':
					recode = 'Ohakea Aerodrome';
					break;
				case 'NZOKW':
					recode = 'Okahu Island';
					break;
				case 'NZOU':
					recode = 'Oamaru Aerodrome';
					break;
				case 'NZOUT':
					recode = 'Oamaru';
					break;
				case 'NZPAX':
					recode = 'Paeroa';
					break;
				case 'NZPEX':
					recode = 'Purerua';
					break;
				case 'NZPM':
					recode = 'Palmerston North Aerodrome';
					break;
				case 'NZPP':
					recode = 'Paraparaumu Aerodrome';
					break;
				case 'NZPRW':
					recode = 'Passage Rock';
					break;
				case 'NZPYX':
					recode = 'Puysegur Point';
					break;
				case 'NZQN':
					recode = 'Queenstown Aerodrome';
					break;
				case 'NZRIX':
					recode = 'Rimutaka Hill Summit';
					break;
				case 'NZRO':
					recode = 'Rotorua Aerodrome';
					break;
				case 'NZRPW':
					recode = 'Ruapuke Island';
					break;
				case 'NZRUX':
					recode = 'Waiouru';
					break;
				case 'NZRXX':
					recode = 'Roxburgh';
					break;
				case 'NZSCX':
					recode = 'Secretary Island';
					break;
				case 'NZSEW':
					recode = 'Separation Point';
					break;
				case 'NZSIX':
					recode = 'South West Cape';
					break;
				case 'NZSJX':
					recode = 'Springs Junction';
					break;
				case 'NZSLW':
					recode = 'Slipper Island';
					break;
				case 'NZSPX':
					recode = 'Stephens Island';
					break;
				case 'NZTBX':
					recode = 'Tolaga Bay';
					break;
				case 'NZTG':
					recode = 'Tauranga Aerodrome';
					break;
				case 'NZTHE':
					recode = 'Tara Hills';
					break;
				case 'NZTKW':
					recode = 'Tutukaka';
					break;
				case 'NZTKX':
					recode = 'Takapau';
					break;
				case 'NZTRX':
					recode = 'Port Taharoa';
					break;
				case 'NZTU':
					recode = 'Timaru Aerodrome';
					break;
				case 'NZUK':
					recode = 'Pukaki Aerodrome';
					break;
				case 'NZWB':
					recode = 'Woodbourne Aerodrome';
					break;
				case 'NZWF':
					recode = 'Wanaka Aerodrome';
					break;
				case 'NZWHX':
					recode = 'Whangaparoa';
					break;
				case 'NZWIX':
					recode = 'White Island';
					break;
				case 'NZWK':
					recode = 'Whakatane Aerodrome';
					break;
				case 'NZWN':
					recode = 'Wellington Aerodrome';
					break;
				case 'NZWOA':
					recode = 'Wairoa';
					break;
				case 'NZWP':
					recode = 'Whenuapai Aerodrome';
					break;
				case 'NZWQX':
					recode = 'Westport';
					break;
				case 'NZWR':
					recode = 'Whangarei Aerodrome';
					break;
				case 'NZWS':
					recode = 'Westport Aerodrome';
					break;
				case 'NZWT':
					recode = 'Whitianga Aerodrome';
					break;
				case 'NZWU':
					recode = 'Wanganui Aerodrome';
					break;
			}
			return recode;
		}
		
		private function is_num_digit(ch):Boolean
		{
			return ( (ch == '0') || (ch == '1') || (ch == '2') || (ch == '3') ||
				(ch == '4') || (ch == '5') || (ch == '6') || (ch == '7') ||
				(ch == '8') || (ch == '9') );
		}
		
		private function is_alphabetic_char(ch):Boolean
		{
			return ( (ch >= 'A') && (ch <= 'Z') );
		}
		
		private function nzt(utc):String {
			var inArr:Array = utc.split(':');
			var h:int = parseInt(inArr[0]);
			var m:String = inArr[1];
			var nzh:int;
			if (h+aheadHours >= 24) {
				nzh=h+aheadHours-24;
			}else{
				nzh=h+aheadHours;
			}
			
			nzh = int((nzh<10?('0'+nzh.toString()):nzh.toString()));
			
			return (nzh + m).toString();
		}
	}
}