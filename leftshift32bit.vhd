library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity leftshift32bit is
	port (
		a_in			:in	std_logic_vector(31 downto 0);	   -- operand1
		result		:out  std_logic_vector(31 downto 0)  		-- result
	);
end leftshift32bit;

architecture leftshift32bitIM of leftshift32bit is
begin
	result(31 downto 1) <= a_in(30 downto 0); -- ROR
	result(0) <= '0';
end leftshift32bitIM;