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
        o1   : out std_logic;
        o2   : out std_logic
        );

end entity bool_proc;

architecture rtl of bool_proc is
type quad is array (3 downto 0) of std_logic;
type trio is array (2 downto 0) of std_logic;
signal adef: quad;
signal bdef: quad;
signal cdef: quad;
signal x: quad;
signal o1_s: std_logic;
signal o2_s: std_logic;
signal def: trio;
begin

	def(0) <= f;
	def(1) <= e;
	def(2) <= d;

	with def select o1_s <=
		b when "000",
		b when "001",
		c when "010",
		a when "011",
		'1' when "100",
		'0' when "101",
		'1' when "110",
		'0' when others;

    process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                o1 <= '0';
		o2 <= '0';
            else
                o1 <= o1_s;
		o2 <= o2_s;
            end if;
        end if;
    end process;
	adef(0) <= f;
	adef(1) <= e;
	adef(2) <= d;
	adef(3) <= a;

	bdef(0) <= f;
	bdef(1) <= e;
	bdef(2) <= d;
	bdef(3) <= b;

	cdef(0) <= f;
	cdef(1) <= e;
	cdef(2) <= d;
	cdef(3) <= c;

	x(3) <= '0';

	with adef select x(2) <=
		'0' when "0000",
		'0' when "0001",
		'0' when "0010",
		'0' when "0011",
		'0' when "0100",
		'0' when "0101",
		'0' when "0110",
		'0' when "0111",
		'0' when "1000",
		'0' when "1001",
		'0' when "1010",
		'1' when "1011",
		'0' when "1100",
		'0' when "1101",
		'0' when "1110",
		'0' when others;

	with bdef select x(1) <=
		'0' when "0000",
		'0' when "0001",
		'0' when "0010",
		'0' when "0011",
		'1' when "0100",
		'0' when "0101",
		'1' when "0110",
		'0' when "0111",
		'1' when "1000",
		'1' when "1001",
		'0' when "1010",
		'0' when "1011",
		'1' when "1100",
		'0' when "1101",
		'1' when "1110",
		'0' when others;

	with cdef select x(0) <=
		'0' when "0000",
		'0' when "0001",
		'0' when "0010",
		'0' when "0011",
		'0' when "0100",
		'0' when "0101",
		'0' when "0110",
		'0' when "0111",
		'0' when "1000",
		'0' when "1001",
		'1' when "1010",
		'0' when "1011",
		'0' when "1100",
		'0' when "1101",
		'0' when "1110",
		'0' when others;

	with x select o2_s <=
		'0' when "0000",
		'1' when "0001",
		'1' when "0010",
		'1' when "0011",
		'1' when "0100",
		'1' when "0101",
		'1' when "0110",
		'1' when "0111",
		'1' when "1000",
		'1' when "1001",
		'1' when "1010",
		'1' when "1011",
		'1' when "1100",
		'1' when "1101",
		'1' when "1110",
		'1' when others;


end architecture rtl;
