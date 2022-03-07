library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bool_proc is
	port(
		clk	: in std_logic;
		rst	: in std_logic;
		RT	: out std_logic;
		RDY	: out std_logic;
		START	: out std_logic;
		ENDD	: out std_logic
	);
end bool_proc;

architecture rtl of bool_proc is
	signal cnt : unsigned(3 downto 0) := "0000";
begin

	process(clk)
	begin
		if rising_edge(clk) then
			cnt <= cnt + "0001";
		end if;
	end process;

	with cnt select	RT <= 
		'1' when "0000"|"0001"|"0010",
		'0' when others;

	with cnt select	RDY <= 
		'1' when "0011",
		'0' when others;

	with cnt select	START <= 
		'1' when "0100",
		'0' when others;

	with cnt select	ENDD <= 
	'1' when "0101",
	'0' when others;

end architecture rtl;
