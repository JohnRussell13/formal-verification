library ieee;
use ieee.std_logic_1164.ALL;
entity gen_lut4 is
	port (
		INIT : in std_logic_vector(15 downto 0);
		I0 : in std_logic;
		I1 : in std_logic;
		I2 : in std_logic;
		I3 : in std_logic;
		O : out std_logic
	);

end gen_lut4;
architecture GLT of gen_lut4 is
type quad is array (3 downto 0) of std_logic;
signal x: quad;
begin
	x(3) <= I3;
	x(2) <= I2;
	x(1) <= I1;
	x(0) <= I0;

	with x select O <=
	INIT(0) when "0000",
	INIT(1) when "0001",
	INIT(2) when "0010",
	INIT(3) when "0011",
	INIT(4) when "0100",
	INIT(5) when "0101",
	INIT(6) when "0110",
	INIT(7) when "0111",
	INIT(8) when "1000",
	INIT(9) when "1001",
	INIT(10) when "1010",
	INIT(11) when "1011",
	INIT(12) when "1100",
	INIT(13) when "1101",
	INIT(14) when "1110",
	INIT(15) when others;

end GLT;
