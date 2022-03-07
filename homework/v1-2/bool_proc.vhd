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
type dual is array (0 to 1) of std_logic;
type quad is array (0 to 3) of std_logic;
signal abcd: quad;
signal d0: quad;
signal d1: quad;
signal ef: dual;
signal gh: dual;
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
		o2 <= (((not a and not b and not c and not e and not f) or (a and not b and not c and e and not f) or (not a and b and not c and not e and f) or (a and b and not c and e and f) or (not a and not b and c and not g and not h) or (a and not b and c and g and not h) or (not a and b and c and not g and h) or (a and b and c and g and h)) and not d) or d ;
            end if;
        end if;
    end process;
	abcd(0) <= a;
	abcd(1) <= b;
	abcd(2) <= c;
	abcd(3) <= d;

	ef(0) <= e;
	ef(1) <= f;

	gh(0) <= g;
	gh(1) <= h;

	with ef select d0 <=
		"1000" when "00",
		"0100" when "10",
		"0010" when "01",
		"0001" when others;

	with gh select d1 <=
		"1000" when "00",
		"0100" when "10",
		"0010" when "01",
		"0001" when others;

	with abcd select o_s <=
		d0(0) when "0000",
		d0(1) when "1000",
		d0(2) when "0100",
		d0(3) when "1100",
		d1(0) when "0010",
		d1(1) when "1010",
		d1(2) when "0110",
		d1(3) when "1110",
		'1' when others;

end architecture rtl;
