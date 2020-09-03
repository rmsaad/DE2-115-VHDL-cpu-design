library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RED is
	port (
		input			:in	std_logic_vector(31 downto 0);	   
		result		:out  unsigned(7 downto 0)  		
	);
end RED;

architecture REDIM of RED is
begin
	result <= unsigned(input(7 downto 0));
end REDIM;