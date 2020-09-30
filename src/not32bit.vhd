library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity not32bit is
	port (
		x			:in	std_logic_vector(31 downto 0);	   -- in
		y		   :out  std_logic_vector(31 downto 0)  		-- out
	);
end not32bit;

architecture not32bitIM of not32bit is
begin
	y <= not x;
end not32bitIM;