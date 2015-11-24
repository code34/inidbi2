class CfgPatches {
	class inidbi2 {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};
		author[] = {"Code34", "Naught"};
		authorUrl = "https://github.com/code34";
	};
};

class CfgFunctions
{
	class A3
	{
		class OO {
			class inidbi2 {
				preInit = 1;
				file = "\inidbi2\oo_inidbi.sqf";
			};
		};
	};
};