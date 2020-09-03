library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU is
	port (
		a						:in	  std_logic_vector(31 downto 0);	   -- operand1
		b        			:in	  std_logic_vector(31 downto 0);		-- operand2
		operation         :in     std_logic_vector(2 downto 0);		-- carry in
		result		      :inout  std_logic_vector(31 downto 0);		-- result
		carry_out 		   :out	  std_logic;	                     -- carry out flag
		zero					:out	  std_logic									-- zero flag
	);
end ALU;

architecture ALUIM of ALU is
	-- internal component
	
	-- 32 bit adder
	component adder32bit is
		port (
			a_in			:in	std_logic_vector(31 downto 0);	   -- operand1
			b_in        :in	std_logic_vector(31 downto 0);		-- operand2
			c_in        :in   std_logic;		                     -- carry in
			result		:out  std_logic_vector(31 downto 0);		-- result
			c_out 		:out	std_logic		                     -- carry out
		);
	end component;
	
	-- 32 bit and 
	component and32bit is
		port (
			a_in			:in	std_logic_vector(31 downto 0);	   -- operand1
			b_in        :in	std_logic_vector(31 downto 0);		-- operand2
			result		:out  std_logic_vector(31 downto 0)  		-- result
		);
	end component;
	
	-- 32 bit or
	component or32bit is
		port (
			a_in			:in	std_logic_vector(31 downto 0);	   -- operand1
			b_in        :in	std_logic_vector(31 downto 0);		-- operand2
			result		:out  std_logic_vector(31 downto 0)  		-- result
		);
	end component;
	
	-- 32 bit ROR
	component rightshift32bit is
		port (
			a_in			:in	std_logic_vector(31 downto 0);	   -- operand1
			result		:out  std_logic_vector(31 downto 0)  		-- result
		);
	end component;
	
	-- 32 bit ROL
	component leftshift32bit is
		port (
			a_in			:in	std_logic_vector(31 downto 0);	   -- operand1
			result		:out  std_logic_vector(31 downto 0)  		-- result
		);
	end component;
	
	-- 32 bit 8 to 1 mux
	component mux8to1 is
		port (
			in0, in1, in2, in3, in4, in5, in6, in7	:in	std_logic_vector(31 downto 0);	-- Mux in
			sel                                    :in	std_logic_vector(2 downto 0);		-- select
			y                                      :out  std_logic_vector(31 downto 0)		-- Mux out
		);
	end component;
	
	-- 32 bit 2 to 1 mux
	component mux2to1 is
		port (
			in0, in1 	:in	std_logic_vector(31 downto 0);	-- Mux in
			sel         :in	std_logic;		                  -- select
			y           :out  std_logic_vector(31 downto 0)		-- Mux out
		);
	end component;
	
	-- 32 bit not
	component not32bit is
		port (
			x			:in	std_logic_vector(31 downto 0);	   -- in
			y		   :out  std_logic_vector(31 downto 0)  		-- out
		);
	end component;
	
	-- Internal wires
	signal andResult		:std_logic_vector(31 downto 0);
	signal orResult		:std_logic_vector(31 downto 0);
	signal adderResult	:std_logic_vector(31 downto 0);
	signal lslResult		:std_logic_vector(31 downto 0);
	signal lsrResult		:std_logic_vector(31 downto 0);
	signal bNegOrNot		:std_logic_vector(31 downto 0);
	signal bNot		      :std_logic_vector(31 downto 0);
	
begin
	-- connections to 8 to 1 mux
	mux1:		mux8to1		port map(in0		=> andResult,
											in1		=> orResult,
											in2		=> adderResult,
											in3		=> "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ",
											in4		=> lslResult,
											in5		=> lsrResult,
											in6		=> adderResult,
											in7		=> "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ",
											sel		=> operation,
											y		   => result);
	-- connections to 32 bit adder
	adder1:	adder32bit  port map(a_in		=> a,
										   b_in		=> bNegOrNot,
										   c_in		=> operation(2),
										   result   => adderResult,  
										   c_out    => carry_out);
	-- connections to 32 bit and
	and1:		and32bit		port map(a,b,andResult);
	-- connections to 32 bit or
	or1: 		or32bit		port map(a,b,orResult);
	-- connections to 32 bit LSR
	lsr1: 	rightshift32bit	port map(a, lsrResult);
	-- connections to 32 bit LSL
	lsl1: 	leftshift32bit	   port map(a, lslResult);
	-- connections to b negative decider mux
	negMux:	mux2to1		port map(in0		=> b,
											in1		=> bNot,
											sel      => operation(2),
											y        => bNegOrNot);
	-- connections to 32 bit not
	notber: 	not32bit		port map(b, bNot);
	
	-- zero flag
	zero <= not(result(0) or result(1) or result(2) or result(3) or result(4) or result(5) or result(6) or 
					result(7) or result(8) or result(9) or result(10) or result(11) or result(12) or 
					result(13) or result(14) or result(15) or result(16) or result(17) or result(18) or  
					result(19) or result(20) or result(21) or result(22) or result(23) or result(24) or 
					result(25) or result(26) or result(27) or result(28) or result(29) or result(30) or result(31));
end ALUIM;
	