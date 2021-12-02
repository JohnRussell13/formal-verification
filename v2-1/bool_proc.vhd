library ieee;
use ieee.std_logic_1164.all;

entity bool_proc is

    port (
        clk : in std_logic;
        rst : in std_logic;
        a   : in std_logic;
        b   : in std_logic;
        c   : in std_logic;
        d   : in std_logic;
        e   : in std_logic;
        f   : in std_logic;
        g   : in std_logic;
        h   : in std_logic;
        o1   : out std_logic;
        o2   : out std_logic
        );

end entity bool_proc;

architecture rtl of bool_proc is
type trio is array (2 downto 0) of std_logic;
signal abc: trio;
signal def: trio;
signal agb: trio;
signal agh: trio;
signal x1: trio;
signal x2: trio;
signal o_s: std_logic;
begin

    process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                o1 <= '0';
		o2 <= '0';
            else
                o1 <= o_s;
		o2 <= not (
			(not (
				(not (
					(not b) and (not c) and (not (g and b)) 
				and 
				(not (g and h)))) 
				and 
				a)) 
			and 
			(not (
				d and e and f
			)));
            end if;
        end if;
    end process;
	abc(0) <= c;
	abc(1) <= b;
	abc(2) <= a;

	def(0) <= f;
	def(1) <= e;
	def(2) <= d;

	agb(0) <= b;
	agb(1) <= g;
	agb(2) <= a;

	agh(0) <= h;
	agh(1) <= g;
	agh(2) <= a;

	x1(2) <= '0';

	with agb select x1(1) <=
		'0' when "000",
		'0' when "001",
		'0' when "010",
		'0' when "011",
		'0' when "100",
		'0' when "101",
		'0' when "110",
		'1' when others;

	with agh select x1(0) <=
		'0' when "000",
		'0' when "001",
		'0' when "010",
		'0' when "011",
		'0' when "100",
		'0' when "101",
		'0' when "110",
		'1' when others;

	with abc select x2(2) <=
		'0' when "000",
		'0' when "001",
		'0' when "010",
		'0' when "011",
		'0' when "100",
		'1' when "101",
		'1' when "110",
		'1' when others;

	with def select x2(1) <=
		'0' when "000",
		'0' when "001",
		'0' when "010",
		'0' when "011",
		'0' when "100",
		'0' when "101",
		'0' when "110",
		'1' when others;

	with x1 select x2(0) <=
		'0' when "000",
		'1' when "001",
		'1' when "010",
		'1' when "011",
		'1' when "100",
		'1' when "101",
		'1' when "110",
		'1' when others;

	with x2 select o_s <=
		'0' when "000",
		'1' when "001",
		'1' when "010",
		'1' when "011",
		'1' when "100",
		'1' when "101",
		'1' when "110",
		'1' when others;

end architecture rtl;
