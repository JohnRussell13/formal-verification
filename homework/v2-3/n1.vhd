library ieee;
use ieee.std_logic_1164.all;
entity n1 is
Port ( a : in std_logic_vector (3 downto 0);
y : out std_logic;
z : out std_logic);
end n1;
architecture RTL of n1 is
signal t: std_logic_vector (1 downto 0);
begin
t(1) <= a(1) xor a(0);
t(0) <= a(3) and a(2);
with t select
y <= '0' when "01",
'1' when others;
with t select
z <= '1' when "00",
'1' when "11",
'0' when others;
end RTL;
