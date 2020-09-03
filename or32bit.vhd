library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity or32bit is
	port (
		a_in			:in	std_logic_vector(31 downto 0);	   -- operand1
		b_in        :in	std_logic_vector(31 downto 0);		-- operand2
		result		:out  std_logic_vector(31 downto 0)  		-- result
	);
end or32bit;

architecture or32bitIM of or32bit is
begin
	result <= a_in or b_in;
end or32bitIM;