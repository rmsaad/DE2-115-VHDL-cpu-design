library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity LZE is
	port (
		input			:in	std_logic_vector(31 downto 0);	   
		result		:out  std_logic_vector(31 downto 0)  		
	);
end LZE;

architecture LZEIM of LZE is
begin
	result <= "0000000000000000" & input(15 downto 0);
end LZEIM;