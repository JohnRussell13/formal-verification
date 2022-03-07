library ieee;
use ieee.std_logic_1164.all;
library work;

entity bool_proc is

    port (
        clk : in std_logic;
        rst : in std_logic;
        a : in std_logic_vector ( 3 downto 0 );
        y1  : out std_logic;
        z1  : out std_logic;
        y2  : out std_logic;
        z2 : out std_logic
        );

end entity bool_proc;

architecture rtl of bool_proc is
signal y1_s: std_logic;
signal y2_s: std_logic;
signal z1_s: std_logic;
signal z2_s: std_logic;
begin

e1: entity work.n1
	port map(a => a, y => y1_s, z => z1_s);

e2: entity work.n1_lec
	port map(a => a, y => y2_s, z => z2_s);

    process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                y1 <= '0';
		y2 <= '0';
                z1 <= '0';
		z2 <= '0';
            else
                y1 <= y1_s;
		y2 <= y2_s;
                z1 <= z1_s;
		z2 <= z2_s;
            end if;
        end if;
    end process;


end architecture rtl;
