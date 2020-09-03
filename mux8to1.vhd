library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mux8to1 is
	port (
		in0, in1, in2, in3, in4, in5, in6, in7	:in	std_logic_vector(31 downto 0);	-- Mux in
		sel                                    :in	std_logic_vector(2 downto 0);		-- select
		y                                      :out  std_logic_vector(31 downto 0)		-- Mux out
	);
end mux8to1;

architecture muxImplementation of mux8to1 is
begin
	process(sel, in0, in1, in2, in3, in4, in5, in6, in7)
	begin
		case sel is
			when "000" => y <= in0;		-- send 0 to sig out
			when "001" => y <= in1;		-- send 1 to sig out
			when "010" => y <= in2;		-- send 2 to sig out
			when "011" => y <= in3;		-- send 3 to sig out
			when "100" => y <= in4;		-- send 4 to sig out
			when "101" => y <= in5;		-- send 5 to sig out
			when "110" => y <= in6;		-- send 6 to sig out
			when "111" => y <= in7;		-- send 7 to sig out
			when others => y <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
		end case;
	end process;
end muxImplementation;