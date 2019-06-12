	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013-2016 Nicolas BOITEUX

	CLASS OO_INIDBI
	
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
	*/

	#include "oop.h"

	CLASS("OO_INIDBI")
		PRIVATE VARIABLE("string","dbname");
		PRIVATE VARIABLE("string","version");
		PRIVATE VARIABLE("string", "separator");
	
		PUBLIC FUNCTION("string","constructor") {
			MEMBER("version", "2.06");
			MEMBER("setDbName", _this);
			MEMBER("getSeparator", nil);
		};

		PUBLIC FUNCTION("", "getDbName") {
			MEMBER("dbname", nil);
		};

		PUBLIC FUNCTION("string", "setDbName") {
			private ["_dbname"];
			_dbname = _this;
			if(_dbname isEqualTo "") then {
				_dbname = "default";
			};
			MEMBER("dbname", _dbname);
		};

		PUBLIC FUNCTION("string", "setSeparator") {
			private ["_newseparator", "_separator", "_result"];
			_result = true;
			_separator = MEMBER("getSeparator", nil);
			_newseparator = "inidbi2" callExtension format["setseparator%1%2", _separator, _this];
			if!(_newseparator isEqualTo ("|"+_this)) then { _result = false;};
			MEMBER("separator", ("|"+_this));
			_result;
		};

		PUBLIC FUNCTION("", "getSeparator") {
			private ["_separator"];
			_separator = "inidbi2" callExtension "getseparator";
			MEMBER("separator", _separator);
			_separator;
		};

		PUBLIC FUNCTION("", "getFileName") {
			private ["_filename"];
			_filename = MEMBER("dbname", nil) + ".ini";
			_filename;
		};

		PUBLIC FUNCTION("string", "encodeBase64") {
			private["_data"];

			if(count (format["%1", _this]) > 2048) then {
				_data = "IniDBI: encodeBase64 failed data too big > 6K";
				MEMBER("log", _data);
			} else {
				_data = "inidbi2" callExtension format["encodebase64%1%2", MEMBER("separator",nil), _this];
			};
			_data;
		};

		PUBLIC FUNCTION("string", "decodeBase64") {
			private["_data"];

			if(count (format["%1", _this]) > 4096) then {
				_data = "IniDBI: decodeBase64 failed data too big > 6K";
				MEMBER("log", _data);
			} else {
				_data = "inidbi2" callExtension format["decodebase64%1%2", MEMBER("separator",nil), _this];
			};
			_data;
		};

		PUBLIC FUNCTION("", "getTimeStamp") {
			private["_data"];
			_data = "inidbi2" callExtension "gettimestamp";
			_data = call compile _data;
			_data;
		};

		PUBLIC FUNCTION("", "getVersion") {
			private["_data"];
			_data = "inidbi2" callExtension "version";
			_data = format["Inidbi: %1 Dll: %2", MEMBER("version", nil), _data];
			_data;
		};

		PUBLIC FUNCTION("", "getSections") {
			private["_file", "_data"];

			_file = MEMBER("getFileName", nil);

			_data = "inidbi2" callExtension format["getsections%1%2",MEMBER("separator",nil), _file];
			_data = call compile _data;
			_data;
		};

		PUBLIC FUNCTION("string", "getKeys") {
			private["_file","_section", "_data"];

			_section = _this;
			_file = MEMBER("getFileName", nil);

			_data = "inidbi2" callExtension format["getkeys%1%2%1%3",MEMBER("separator",nil), _file, _section];
			_data = call compile _data;
			_data;
		};

		PUBLIC FUNCTION("string", "log") {
			hint format["%1", _this];
			diag_log format["%1", _this];
		};

		PUBLIC FUNCTION("", "exists") {
			private["_result"];
			
			_result = "inidbi2" callExtension format["exists%1%2", MEMBER("separator",nil), MEMBER("getFileName", nil)];
			_result = call compile _result;
			_result;
		};

		PUBLIC FUNCTION("", "delete") {
			private["_result"];
		
			_result = "inidbi2" callExtension format["delete%1%2", MEMBER("separator",nil), MEMBER("getFileName", nil)];
			_result = call compile _result;
			_result;
		};

		PUBLIC FUNCTION("array", "deleteKey") {
			private ["_file", "_section", "_result", "_key"];

			_section 	= _this select 0;
			_key		= _this select 1;
			
			_file = MEMBER("getFileName", nil);

			if(isnil "_file") exitWith { MEMBER("log","IniDBI: deletesection failed, databasename is empty"); };
			if(isnil "_section") exitWith { MEMBER("log","IniDBI: deletesection failed, sectionname is empty"); };
			if(isnil "_key") exitWith { MEMBER("log","IniDBI: deletesection failed, key is empty"); };
	
			_result = "inidbi2" callExtension format["deletekey%1%2%1%3%1%4", MEMBER("getSeparator",nil), _file, _section, _key];
			_result = call compile _result;
			_result;
		};		

		PUBLIC FUNCTION("string", "deleteSection") {
			private ["_file", "_section", "_result"];
			
			_file = MEMBER("getFileName", nil);
			_section 	= _this;

			if(isnil "_file") exitWith { MEMBER("log","IniDBI: deletesection failed, databasename is empty"); };
			if(isnil "_section") exitWith { MEMBER("log","IniDBI: deletesection failed, sectionname is empty"); };
	
			_result = "inidbi2" callExtension format["deletesection%1%2%1%3", MEMBER("separator",nil), _file, _section];
			_result = call compile _result;
			_result;
		};

		PUBLIC FUNCTION("array", "read") {
			private ["_count", "_file", "_section", "_key", "_data", "_result", "_defaultvalue"];
			
			_count = count _this;

			if(_count < 2) exitwith { MEMBER("log", "Inidb: read failed not enough parameter"); 	};
			_section 	= _this select 0;
			_key 		= _this select 1;
			if(_count > 2) then {_defaultvalue = _this select 2;};

			_file = MEMBER("getFileName", nil);

			if(isnil "_file") exitWith { MEMBER("log","IniDBI: read failed, databasename is empty"); };
			if(isnil "_section") exitWith { MEMBER("log","IniDBI: read failed, sectionname is empty"); };	
			if(isnil "_key") exitWith { MEMBER("log","IniDBI: read failed, keyname is empty"); };
			if(isnil "_defaultvalue") then { _defaultvalue = false;};
		
			_result = "inidbi2" callExtension format["read%1%2%1%3%1%4",MEMBER("separator",nil), _file, _section, _key];
			_result = call compile _result;
		
			if(_result select 0) then {
				_data = _result select 1;
			} else {
				_data = _defaultvalue;
			};
			_data;
		};

		PUBLIC FUNCTION("array", "parseArray"){
			private ["_data", "_exit", "_array"];

			_exit = _this select 0;
			_data = _this select 1;

			{
				if!(typename _x in ["BOOL", "ARRAY", "STRING", "SCALAR"]) then { _exit = true; };
				if(typename _x == "ARRAY") then { 
					_array = [_exit, _x];
					_exit = MEMBER("parseArray", _array); 
				};
				sleep 0.0001;
			}foreach _data;
			_exit;
		};

		PUBLIC FUNCTION("array", "write") {
			private["_array", "_file", "_section", "_key", "_data", "_exit", "_log"];

			if(count _this < 3) exitwith { 
				MEMBER("log", "Inidb: write failed not enough parameter");
			};

			_section = _this select 0;
			_key = _this select 1;
			_data = _this select 2;	
			
			_file = MEMBER("getFileName", nil);
			_exit = false;

			if(isnil "_file") exitWith {  MEMBER("log", "IniDBI: write failed, databasename is empty"); 	};
			if(isnil "_section") exitWith { MEMBER("log", "IniDBI: write failed, sectionname is empty"); };
			if(isnil "_key") exitWith { MEMBER("log", "IniDBI: write failed, keyname is empty"); };
			if(isnil "_data") exitWith {MEMBER("log", "IniDBI: write failed, data is empty"); };

			if!(typename _data in ["BOOL", "ARRAY", "STRING", "SCALAR"]) then {_exit = true;};
			if(typeName _data == "STRING") then { _data = '"'+ _data + '"'};
			if(typename _data == "ARRAY") then { 
				_array = [false, _data];
				_exit = MEMBER("parseArray", _array); 
			};

			if(_exit) exitWith { 
				_log = format["IniDBI: write failed, %1 %2 data contains object should be ARRAY, SCALAR, STRING type", _section, _key]; 
				MEMBER("log", _log);
			};
		
			if(count (format["%1", _data]) > 8100) then {
				_data = false;
				_log = format["IniDBI: write failed %1 %2 data too big > 8K", _section, _key];
				MEMBER("log", _log);
			} else {
				_data = format['"%1"', _data];
				_data = "inidbi2" callExtension format["write%1%2%1%3%1%4%1%5", MEMBER("separator",nil), _file, _section, _key, _data];
				_data = call compile _data;
			};
			_data;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("version");
			DELETE_VARIABLE("dbname");
			DELETE_VARIABLE("separator");
		};
	ENDCLASS;