library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mux2to1 is
	port (
		in0, in1 	:in	std_logic_vector(31 downto 0);	-- Mux in
		sel         :in	std_logic;		                  -- select
		y           :out  std_logic_vector(31 downto 0)		-- Mux out
	);
end mux2to1;

architecture mux2to1IM of mux2to1 is
begin
	process(sel, in0, in1)
	begin
		case sel is
			when '0' => y <= in0;		-- send 0 to sig out
			when '1' => y <= in1;		-- send 1 to sig out
			when others => y <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
		end case;
	end process;
end mux2to1IM;