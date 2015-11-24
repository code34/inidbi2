	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014 Nicolas BOITEUX

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
	
		PUBLIC FUNCTION("string","constructor") {
			MEMBER("version", "2.01");
			MEMBER("setDbName", _this);
		};

		PUBLIC FUNCTION("string", "setDbName") {
			private ["_dbname"];
			_dbname = _this;
			if(_dbname == "") then {
				_dbname = "default";
			};
			MEMBER("dbname", _dbname);
		};

		PUBLIC FUNCTION("", "getDbName") {
			MEMBER("dbname", nil);
		};		

		PRIVATE FUNCTION("", "getFileName") {
			private ["_filename"];
			_filename = MEMBER("dbname", nil) + ".ini";
			_filename;
		};

		PUBLIC FUNCTION("string", "encodeBase64") {
			private["_data"];
			_data = "inidbi2" callExtension format["encodebase64|%1", _this];
			_data;
		};

		PUBLIC FUNCTION("string", "decodeBase64") {
			private["_data"];
			_data = "inidbi2" callExtension format["decodebase64|%1", _this];
			_data;
		};

		PUBLIC FUNCTION("", "getTimeStamp") {
			private["_data"];
			_data = "inidbi2" callExtension "timestamp";
			_data = [_data, "SCALAR"];
			_data = MEMBER("cast", _data);
			_data;
		};

		PUBLIC FUNCTION("", "getVersion") {
			private["_data"];
			_data = "inidbi2" callExtension "version";
			_data = format["Inidbi: %1 Dll: %2", MEMBER("version", nil), _data];
			_data;
		};

		PUBLIC FUNCTION("string", "log") {
			hint format["%1", _this];
			diag_log format["%1", _this];
		};

		PUBLIC FUNCTION("", "exists") {
			private["_result"];
			
			_result = "inidbi2" callExtension format["exists|%1", MEMBER("getFileName", nil)];
			_result = call compile _result;
			_result;
		};

		PUBLIC FUNCTION("", "delete") {
			private["_result"];
		
			_result = "inidbi2" callExtension format["delete|%1", MEMBER("getFileName", nil)];
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
	
			_result = "inidbi2" callExtension format["deletekey|%1|%2|%3", _file, _section, _key];
			_result = call compile _result;
			_result;
		};		

		PUBLIC FUNCTION("string", "deleteSection") {
			private ["_file", "_section", "_result"];
			
			_file = MEMBER("getFileName", nil);
			_section 	= _this;

			if(isnil "_file") exitWith { MEMBER("log","IniDBI: deletesection failed, databasename is empty"); };
			if(isnil "_section") exitWith { MEMBER("log","IniDBI: deletesection failed, sectionname is empty"); };
	
			_result = "inidbi2" callExtension format["deletesection|%1|%2", _file, _section];
			_result = call compile _result;
			_result;
		};

		PUBLIC FUNCTION("array", "read") {
			private ["_count", "_file", "_section", "_key", "_type", "_data", "_result", "_defaultvalue"];
			
			_count = count _this;

			if(_count < 2) exitwith { MEMBER("log", "Inidb: read failed not enough parameter"); 	};
			_section 	= _this select 0;
			_key 		= _this select 1;
			if(_count > 2) then { _type = _this select 2;};
			if(_count > 3) then {_defaultvalue = _this select 3;};

			_file = MEMBER("getFileName", nil);

			if(isnil "_file") exitWith { MEMBER("log","IniDBI: read failed, databasename is empty"); };
			if(isnil "_section") exitWith { MEMBER("log","IniDBI: read failed, sectionname is empty"); };	
			if(isnil "_key") exitWith { MEMBER("log","IniDBI: read failed, keyname is empty"); };
			if(isnil "_type") then { _type = "STRING";};
			if!(_type in ["ARRAY", "SCALAR", "STRING", "BOOL"]) exitWith { MEMBER("log","IniDBI: read failed, data type parameter must be ARRAY, SCALAR, STRING, BOOL"); };
			if(isnil "_defaultvalue") then { _defaultvalue = false;};
		
			_result = "inidbi2" callExtension format["read|%1|%2|%3", _file, _section, _key];
			_result = call compile _result;
		
			if(count _result > 1) then {
				_data = _result select 1;
				_data = [_data, _type];
				_data = MEMBER("cast", _data);
			} else {
				_data = _defaultvalue;
			};
			_data;
		};

		PRIVATE FUNCTION("array", "parseArray"){
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

			_section 	= _this select 0;
			_key 		= _this select 1;
			_data 		= _this select 2;	
			
			_file = MEMBER("getFileName", nil);
			_exit 		= false;

			if(isnil "_file") exitWith {  MEMBER("log", "IniDBI: write failed, databasename is empty"); 	};
			if(isnil "_section") exitWith { MEMBER("log", "IniDBI: write failed, sectionname is empty"); };
			if(isnil "_key") exitWith { MEMBER("log", "IniDBI: write failed, keyname is empty"); };
			if(isnil "_data") exitWith {MEMBER("log", "IniDBI: write failed, data is empty"); };

			if!(typename _data in ["BOOL", "ARRAY", "STRING", "SCALAR"]) then {_exit = true;};
			if(typename _data == "ARRAY") then { 
				_array = [false, _data];
				_exit = MEMBER("parseArray", _array); 
			};

			if(_exit) exitWith { 
				_log = format["IniDBI: write failed, %1 %2 data contains object should be ARRAY, SCALAR, STRING type", _section, _key]; 
				MEMBER("log", _log);
			};
		
			if(count (toarray(format["%1", _data])) > 10230) then {
				_data = false;
				_log = format["IniDBI: write failed %1 %2 data too big > 10K", _section, _key];
				MEMBER("log", _log);
			} else {
				_data = format['"%1"', _data];
				_data = "inidbi2" callExtension format["write|%1|%2|%3|%4", _file, _section, _key, _data];
			};
			_data;
		};

		PRIVATE FUNCTION("array", "cast") {
			private["_data", "_type"];

			_data = _this select 0;
			_type = _this select 1;
			
			switch (toupper(_type)) do {
				case "ARRAY": {
					if((_data isEqualTo "") or (typeName _data != "ARRAY")) then {
						_data = [];
					};
				};
		
				case "SCALAR": {
					if ((_data isEqualTo "") or (typeName _data != "SCALAR")) then {
						_data = 0;
					} ;
				};

				case "BOOL": {
					if((_data isEqualTo "") or (typeName _data != "BOOL")) then {
						_data = false;
					};
				};
		
				default {
					_data = format["%1", _data];
				};
				
			};
			_data;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("version");
			DELETE_VARIABLE("dbname");
		};
	ENDCLASS;