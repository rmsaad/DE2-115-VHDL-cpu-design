library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity UZE is
	port (
		input			:in	std_logic_vector(31 downto 0);	   
		result		:out  std_logic_vector(31 downto 0)  		
	);
end UZE;

architecture UZEIM of UZE is
begin
	result <= input(15 downto 0) & "0000000000000000";
end UZEIM;