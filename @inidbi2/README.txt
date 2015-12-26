	Description:
	INIDBI 2.05 - A simple server-side database extension using INI files

	Author:  code34 nicolas_boiteux@yahoo.fr

	Copyright (C) 2013-2016 Nicolas BOITEUX 
	
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

	How to install:
	1- Unpack the archive and copy the entire "@inidbi2" folder into the ARMA3 root directory.

		The @inibdi2 folder should look like this:
		../Arma 3/@inidbi2/inidbi2.dll
		../Arma 3/@inidbi2/db/
		../Arma 3/@inidbi2/Addons/inidbi.pbo

	2- check inidbi2.dll execution permissions, right click on it, and authorize it.

	Changelog
	- version 2.05
		- re factory gettimestamp method return array instead string containing system UTC TIME
	- version 2.04
		- add getSections method
	- version 2.02 
		- add methods to tune separators
		- fix write returns
		- fix read types
		- fix buffer overflow of decode/encodebase64
		- fix getTimeStamp
	- version 2.0 - rebuild from scratch C# & SQF++
