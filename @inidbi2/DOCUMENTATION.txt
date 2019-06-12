	Description:
	INIDBI 2.06 - A simple server-side database extension using INI files

	Author:  code34 nicolas_boiteux@yahoo.fr

	Copyright (C) 2013-2019 Nicolas BOITEUX 
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function : new 
	Instanciate inidbi object
	Usage: _inidbi = ["new", _databasename] call OO_INIDBI;
	Param: string - the databasename to use. Databasename will be used as name of file on computer 
	where the script is executed. INIDBI automatically add the .ini file extension to the databasename. 
	This file is stored into the addons path into db/ directory.
	Output: inidbi2 object

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function : getVersion
	Usage : "getVersion" call _inidbi;
	Param : none
	Output : string containing the addon version and dll version

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function: exists
	Usage : "exists" call _inidbi;
	Param: none
	Output: true if the Arma has the required permissions and database file exists; 
	otherwise, return false. 

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function : delete
	Usage : "delete" call _inidbi;
	Param: none
	Output: true if the database was deleted successfully, false otherwise

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function: deleteSection
	Usage: ["deleteSection", _section] call _inidbi;
	Param: string _section - name of section to delete
	Output: true if the section was deleted successfully, false otherwise

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function: deleteKey
	Usage : ["deleteKey", [_section, _key]] call _inidbi;
	Param: array 
		string _section - name of section containing the key
		string _key - name of key to delete
	Output: true if the key was deleted successfully, false otherwise

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function: read
	Usage : ["read", [_section, _key]] call _inidbi;

	Param: array
		string _section - name of sectrion containing the key
		string _key - name of key to read
	Output: value of key, if nothing is found return by default: false;

	You can set the default return value as follow (instead of false)
	ex:
	Usage : ["read", ["section", "key", "mydefaultvalueifnothingisfound"]] call _inidbi;
	Usage : ["read", ["section", "key", 0]] call _inidbi;
	Usage : ["read", ["section", "key", true]] call _inidbi;
	Usage : ["read", ["section", "key", ["mydefaultarray"]]] call _inidbi;

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function: write
	Usage: ["write", [_section, _key, _value]] call _inidbi;
	Param:
		string _section - name of sectrion containing the key
		string _key - name of key to write
		string/scalar/array/bool _value - value to write (other type are not supported)
	Output : true if is write was successfull, false if not

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function: encodeBase64 
	Usage: ["encodeBase64", _yourstring] call _inidbi;
	Param:
		string - an utf8 string to encode to base64 (max size 2048)
	Output: the string encode in base64, if error returns empty string

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function: decodeBase64
	Usage: ["decodeBase64", _yourstringbase64] call _inidbi;
	Param:
		string - a base64 string (max size 4096)
	Output: the string decode from base64 to utf8, if error returns empty string

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function: getDbName
	Usage: "getDbName" call _inidbi;
	Param: none
	Output: return the database name

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function: setDbName
	Usage : ["setDbName", _dbname] call _inidbi;
	Param: 
		string - name of the file databasename (without its extension .ini)
	Output : nothing

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function: getTimeStamp
	Usage : _time = "getTimeStamp" call _inidbi;
	Param : none
	Output : an array containing UTC timestamp of the OS system [YYYY, MM, DD, HH, MM, SS]

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function : delete
	Delete inidbi object
	Usage: ["delete", _inidbi] call OO_INIDBI;
	Param: 
		code - delete the _inidbi object
	Output: return nothing

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function : getSeparator
	Usage : "getSeparator" call _inidbi;
	Param : none
	Output : string containing the parameters sepator (default is "|")

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function : setSeparator will add to "|" your string separator
	Usage : ["setSeparator", _separator] call _inidbi;
	Param: 
		string - suffix to add after the original operators "|" 
		ex: 
			_separator = "idb2";
			["setSeparator", _separator] call _inidbi;
			will set separator as "|idb2"
		Output: 
			bool - return true if separator was setted, false if not
	----------------------------------------------------------------------------------------------------------------------------------------------

	Function : getSections
	Usage : "getSections" call _inidbi;
	Param: none
	Output : array containing all string sections (limit to 8K)

	----------------------------------------------------------------------------------------------------------------------------------------------

	Function : getKeys
	Usage : ["getKeys", _section] call _inidbi;
	Param : 
		string _section - name of section containing the keys
	Output : array of string keys declared into the section (limit to 8K)

	----------------------------------------------------------------------------------------------------------------------------------------------