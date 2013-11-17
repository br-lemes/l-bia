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
 *  Report bugs to <br_lemes@yahoo.com.br>
 *  http://l-bia.sourceforge.net/
 *}

{$mode delphi}

unit lbaux;

interface

uses dynlibs;

type
	lua_State = type pointer;

var
	luaL_newstate:    function: lua_State; cdecl;
	luaL_openlibs:    procedure(L: lua_State); cdecl;
	lua_createtable:  procedure(L: lua_State; narr, nrec: integer); cdecl;
	lua_pushstring:   procedure(L: lua_State; const s: pchar); cdecl;
	lua_rawseti:      procedure(L: lua_State; idx, n: integer); cdecl;
	lua_setfield:     procedure(L: lua_State; idx: integer; const k: pchar ); cdecl;
	luaL_loadfile:    function(L: lua_State; const filename: pchar; const mode: pchar = nil): integer; cdecl;
	lua_pcall:        function(L: lua_State; nargs, nresults, errfunc: integer; ctx: integer = 0; k: pointer = nil): integer; cdecl;
	lua_tolstring:    function(L: lua_State; idx: integer; var len: cardinal): pchar; cdecl;
	lua_close:        procedure(L: lua_State); cdecl;
	lua_setglobal:    procedure(L: lua_State; const name: pchar); cdecl;


procedure lua_newtable(L: lua_State); inline;
function lua_tostring(L: lua_State; idx: integer): pchar; inline;

function lb_prgname: string;
function lb_prgpath: string;
procedure lb_error(const msg: string); inline;
procedure lb_loadlua(const libname: string);

implementation

const
	LUA_GLOBALSINDEX  = -10002;

var
	lb_handler: thandle = 0;

procedure lua_newtable(L: lua_State); inline;
begin
	lua_createtable(L, 0, 0);
end;

function lua_tostring(L: lua_State; idx: integer): pchar; inline;
var
	len: cardinal;
begin
	result := lua_tolstring(L, idx, len)
end;

function lb_prgname: string;
var
	f: string;
	i: integer;
begin
	result := '';
	f := paramstr(0);
	for i := length(f) downto 1 do
	begin
		case f[i] of
			'.': result := '';
			'/', '\': break;
			else result := f[i] + result;
		end;
	end;
end;

function lb_prgpath: string;
var
	f: string;
	i: integer;
	b: boolean = false;
begin
	result := '';
	f := paramstr(0);
	for i := length(f) downto 1 do
	begin
		if (f[i] = '/') or (f[i] = '\') then b := true;
		if b then result := f[i] + result;
	end;
end;

procedure lb_error(const msg: string); inline;
begin
	writeln(stderr, lb_prgname + ': ' + msg);
	halt(1);
end;

procedure lb_setglobal(L: lua_State; const name: pchar); cdecl; inline;
begin
	lua_setfield(L, LUA_GLOBALSINDEX, name);
end;

procedure lb_loadlua(const libname: string);
var
	p: pointer;
	function lb_getprocaddress(handler: thandle; const name: string; e: boolean = true): pointer;
	begin
		p := getprocaddress(handler, name);
		if e and (p = nil) then lb_error('cannot load ' + name);
		result := p
	end;
begin
	lb_handler := loadlibrary(libname);
	{$IF FPC_FULLVERSION >= 20602}
	if lb_handler = 0 then lb_error(getloaderrorstr);
	{$ELSE}
	if lb_handler = 0 then lb_error('cannot load ' + libname);
	{$ENDIF}
	luaL_newstate   := lb_getprocaddress(lb_handler, 'luaL_newstate');
	luaL_openlibs   := lb_getprocaddress(lb_handler, 'luaL_openlibs');
	lua_createtable := lb_getprocaddress(lb_handler, 'lua_createtable');
	lua_pushstring  := lb_getprocaddress(lb_handler, 'lua_pushstring');
	lua_rawseti     := lb_getprocaddress(lb_handler, 'lua_rawseti');
	lua_setfield    := lb_getprocaddress(lb_handler, 'lua_setfield');
	luaL_loadfile   := lb_getprocaddress(lb_handler, 'luaL_loadfilex', false);
	if p = nil then
		luaL_loadfile := lb_getprocaddress(lb_handler, 'luaL_loadfile');
	lua_pcall       := lb_getprocaddress(lb_handler, 'lua_pcallk', false);
	if p = nil then
		lua_pcall := lb_getprocaddress(lb_handler, 'lua_pcall');
	lua_tolstring   := lb_getprocaddress(lb_handler, 'lua_tolstring');
	lua_close       := lb_getprocaddress(lb_handler, 'lua_close');
	lua_setglobal   := lb_getprocaddress(lb_handler, 'lua_setglobal', false);
	if p = nil then
		lua_setglobal := lb_setglobal;
end;

finalization
	if lb_handler <> 0 then freelibrary(lb_handler);
end.
