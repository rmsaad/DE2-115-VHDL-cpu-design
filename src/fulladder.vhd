library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fulladder is
	port (
		a			:in	std_logic;	   -- operand1
		b        :in	std_logic;		-- operand2
		cin      :in   std_logic;		-- carry in
		sum		:out  std_logic;		-- result
		cout		:out	std_logic		-- carry out
	);
end fulladder;

architecture fulladderIM of fulladder is
begin
	sum <= (a xor b) xor cin;
	cout <= (a and b) or ((a xor b) and cin);
end fulladderIM;