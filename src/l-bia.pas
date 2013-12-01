{*
 *  Lua Built-In program (L-Bia)
 *  A self-running Lua interpreter. It turns your Lua program with all
 *  required modules and an interpreter into a single stand-alone program.
 *  Copyright (c) 2007,08,09,10,13 Breno Ramalho Lemes
 *
 *  L-Bia comes with ABSOLUTELY NO WARRANTY; This is free software, and you
 *  are welcome to redistribute it under certain conditions; see LICENSE
 *  for details.
 *
 *  Report bugs to <breno@br-lemes.net>
 *  http://l-bia.sourceforge.net/
 *  http://www.br-lemes.net/
 *}

{$mode delphi}

{$IFDEF WINDOWS}
	{$apptype gui}
	{$R ../etc/l-bia.rc}
{$ENDIF}

uses lbaux;

{$IFDEF UNIX}
function execv(const path: pchar; const argv: ppchar): integer; cdecl; external;
function getenv(const name: pchar): pchar; cdecl; external;
function setenv(const name, value: pchar; overwrite: boolean): integer; cdecl; external;
{$ENDIF}

var
	i: integer;
	L: lua_State;

begin
	chdir(lb_prgpath);
	{$IFDEF UNIX}
	if getenv('LD_LIBRARY_PATH') <> '.' then
	begin
		setenv('LD_LIBRARY_PATH', '.', true);
		execv(argv[0], argv);
	end;
	{$ENDIF}
	lb_loadlua;
	L := luaL_newstate;
	luaL_openlibs(L);
	lua_newtable(L);
	for i := 0 to paramcount do
	begin
		lua_pushstring(L, pchar(paramstr(i)));
		lua_rawseti(L, -2, i);
	end;
	lua_setglobal(L, 'arg');
	if luaL_loadfile(L, pchar(lb_prgname + '.lua')) = 0 then
	begin
		for i := 1 to paramcount do
			lua_pushstring(L, pchar(paramstr(i)));
		if lua_pcall(L, paramcount, 0, 0) <> 0 then
			lb_error(lua_tostring(L, -1));
	end else
		lb_error(lua_tostring(L, -1));
	lua_close(L);
end.
