library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rightshift32bit is
	port (
		a_in			:in	std_logic_vector(31 downto 0);	   -- operand1
		result		:out  std_logic_vector(31 downto 0)  		-- result
	);
end rightshift32bit;

architecture rightshift32bitIM of rightshift32bit is
begin
	result(30 downto 0) <= a_in(31 downto 1); -- ROR
	result(31) <= '0';
end rightshift32bitIM;