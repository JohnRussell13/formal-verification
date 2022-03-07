library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bool_proc is
	port(
		clk	: in std_logic;
		rst	: in std_logic;
		HELP1	: out std_logic;
		RT1	: out std_logic;
		RDY1	: out std_logic;
		START1	: out std_logic;
		ENDD1	: out std_logic;
		ER2	: out std_logic;
		ER3	: out std_logic;
		RDY3	: out std_logic;
		HELP4	: out std_logic;
		RDY4	: out std_logic;
		START4	: out std_logic;
		ENDD5	: out std_logic;
		STOP5	: out std_logic;
		ER5	: out std_logic;
		RDY5	: out std_logic;
		START5	: out std_logic;
		ENDD6	: out std_logic;
		STOP6	: out std_logic;
		ER6	: out std_logic;
		RDY6	: out std_logic;
		ENDD7	: out std_logic;
		START7	: out std_logic;
		STATUS_VALID7	: out std_logic;
		INSTARTSV7	: out std_logic;
		RT8	: out std_logic;
		ENABLE8	: out std_logic;
		RDY9	: out std_logic;
		START9	: out std_logic;
		INTERRUPT9	: out std_logic;
		ACK10	: out std_logic;
		REQ10	: out std_logic
	);
end bool_proc;

architecture rtl of bool_proc is
	signal cnt : unsigned(3 downto 0) := "0000";
	signal h1, h4, s1, s4, s : std_logic;
begin

	-- start, since it skips inital value for cnt
	with cnt select	s <= 
		'1' when "0000",
		'0' when others;

	with cnt select	s1 <= 
		'1' when "0000"|"0001"|"0010"|"0011"|"1000",
		'0' when others;

	with cnt select	s4 <= 
		'1' when "0010",
		'0' when others;

	process(s1, s4, s)
	begin
		if (s = '1') then
			h1 <= '0';
			h4 <= '0';
		end if;
		-- latch
		if (s1 = '0') then
			h1 <= '1';
		end if;

		-- latch
		if (s4 = '1') then
			h1 <= '1';
		end if;
	end process;

	HELP1 <= h1;
	HELP4 <= h4;

	process(clk)
	begin
		if rising_edge(clk) then
			cnt <= cnt + "0001";
		end if;
	end process;

	with cnt select	RT1 <= 
		'1' when "0000"|"0001"|"0010"|"0011"|"1000",
		'0' when others;

	with cnt select	RDY1 <= 
		'1' when "0101",
		'0' when others;

	with cnt select	START1 <= 
		'1' when "1000",
		'0' when others;

	with cnt select	ENDD1 <= 
		'1' when "0110",
		'0' when others;

	with cnt select	ER2 <= 
		'1' when "0001"|"0010"|"0110"|"0111"|"1000"|"1001",
		'0' when others;

	with cnt select	ER3 <= 
		'1' when "0001"|"0101"|"0110"|"1001",
		'0' when others;

	with cnt select	RDY3 <= 
		'1' when "0001"|"0010"|"0101"|"1001",
		'0' when others;

	with cnt select	RDY4 <= 
		'1' when "0110",
		'0' when others;

	with cnt select	START4 <= 
		'1' when "0010",
		'0' when others;

	with cnt select	ENDD5 <= 
		'1' when "0010",
		'0' when others;

	with cnt select	STOP5 <= 
		'0' when others;

	with cnt select	ER5 <= 
		'1' when "1010",
		'0' when others;

	with cnt select	RDY5 <= 
		'1' when "0001"|"0010"|"1000"|"1001"|"1010",
		'0' when others;

	with cnt select	START5 <= 
		'1' when "1000",
		'0' when others;

	with cnt select	ENDD6 <= 
		'1' when "0010",
		'0' when others;

	with cnt select	STOP6 <= 
		'1' when "0101",
		'0' when others;

	with cnt select	ER6 <= 
		'1' when "1010",
		'0' when others;

	with cnt select	RDY6 <= 
		'1' when "0001"|"0010"|"0100"|"0101"|"0110"|"1001"|"1010",
		'0' when others;

	with cnt select	ENDD7 <= 
		'1' when "0011",
		'0' when others;

	with cnt select	START7 <= 
		'1' when "0101",
		'0' when others;

	with cnt select	STATUS_VALID7 <= 
		'1' when "1010",
		'0' when others;

	with cnt select	INSTARTSV7 <= 
		'1' when "0011"|"0100"|"0101"|"0110"|"0111",
		'0' when others;

	with cnt select	RT8 <= 
		'1' when "0000"|"0001"|"0010",
		'0' when others;

	with cnt select	ENABLE8 <= 
		'1' when "0111",
		'0' when others;

	with cnt select	RDY9 <= 
		'1' when "0010"|"0011"|"0100"|"0101"|"0110"|"0111",
		'0' when others;

	with cnt select	START9 <= 
		'1' when "0101"|"0110"|"0111",
		'0' when others;

	with cnt select	INTERRUPT9 <= 
		'1' when "0111",
		'0' when others;

	with cnt select	ACK10 <= 
		'1' when "0110",
		'0' when others;

	with cnt select	REQ10 <= 
		'1' when "0001",
		'0' when others;

end architecture rtl;
