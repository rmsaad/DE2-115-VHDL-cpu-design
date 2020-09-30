library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mux3to1 is
	port (
		in0, in1, in2                       	:in	std_logic_vector(31 downto 0);	-- Mux in
		sel                                    :in	std_logic_vector(1 downto 0);		-- select
		y                                      :out  std_logic_vector(31 downto 0)		-- Mux out
	);
end mux3to1;

architecture muxImplementation of mux3to1 is
begin
	process(sel, in0, in1, in2)
	begin
		case sel is
			when "00" => y <= in0;		-- send 0 to sig out
			when "01" => y <= in1;		-- send 1 to sig out
			when "10" => y <= in2;		-- send 2 to sig out
			when others => y <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
		end case;
	end process;
end muxImplementation;