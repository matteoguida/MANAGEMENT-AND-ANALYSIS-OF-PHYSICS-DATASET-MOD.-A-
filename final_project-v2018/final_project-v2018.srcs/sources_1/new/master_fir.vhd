----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2019 11:43:02 AM
-- Design Name: 
-- Module Name: master_fir - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity master_fir is
  generic(N      : integer := 16);
  Port (
     clk        : in  std_logic;
     rst        : in  std_logic;
     start      : in  std_logic;
     x_in       : in  std_logic_vector(N-1 downto 0);
     y_out      : out std_logic_vector(N-1 downto 0);
     we_out     : out std_logic;                       -- write enable for the dpram
     address_read  : out std_logic_vector(9 downto 0);
     address_write : out std_logic_vector(9 downto 0));
end master_fir;


architecture Behavioral of master_fir is

component fir is
  generic(N      : integer := 16);
  Port (
     clk        : in  std_logic;
     board_clk  : in  std_logic;
     rst        : in  std_logic;
     x_in       : in  std_logic_vector(N-1 downto 0);
     y_out      : out std_logic_vector(N-1 downto 0));
end component;

COMPONENT ila_1

PORT (
	clk : IN STD_LOGIC;
	probe0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	probe1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	probe2 : IN STD_LOGIC_VECTOR(9 DOWNTO 0); 
	probe3 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
);
END COMPONENT  ;

signal we : std_logic;
--signal gen_is_on: std_logic;
--signal address: std_logic_vector(9 downto 0);
signal addr_0, addr_1: std_logic_vector(9 downto 0);
signal fir_clk : std_logic;
signal samples: integer;
signal first_run: std_logic;
type state is (s_idle, s_read, s_write);
signal state_fsm: state;
signal y: std_logic_vector(15 downto 0);
--signal encoded_state : unsigned(1 downto 0);


begin


p_square_wave: process(clk, rst) is
    --variable tcnt: integer;

    begin
           
        if rst = '1' then 
            --tcnt := 0;
            samples <= 0;
            we <= '0';
            state_fsm <= s_idle;
            fir_clk <= '0';
            first_run <= '1';
        
        -- start square wave when en_gen_in is 1, stop after 1024 samples
        elsif rising_edge(clk) then

            case state_fsm is
            when s_idle =>
                we <= '0';
                if (start = '1') and (first_run = '1') then
                    first_run <= '0';
                    --gen_is_on <= '1';
                    addr_0 <= std_logic_vector(to_unsigned(samples, addr_0'length));
                    state_fsm <= s_read;
                else
                    state_fsm <= s_idle;
                end if;
                
            when s_read =>
                we <= '0';
                fir_clk <= '1';
                state_fsm <= s_write;                     
            when s_write =>
                we <= '1';
                addr_1 <= std_logic_vector(to_unsigned(samples, addr_0'length));
                fir_clk <= '0';
                samples <= samples + 1;
                if samples = 1024 then
                    samples <= 0;
                    state_fsm <= s_idle;
                else
                    addr_0 <= std_logic_vector(to_unsigned(samples, addr_0'length));
                    state_fsm <= s_read;
                end if;
            when others =>
                state_fsm <= s_idle;
                    
            end case;
            
            
        end if;        
    end process;


--p_enc_state: process(clk) is
--    begin
--        case state_fsm is
--        when s_idle =>
--            encoded_state <= to_unsigned(0, 2);
--        when s_up =>
--            encoded_state <= to_unsigned(1, 2);
--        when s_down =>
--            encoded_state <= to_unsigned(2, 2);
--        end case;
--    end process;


we_out <= we;
address_read <= addr_0;
address_write <= addr_1;
y_out <= y;

fir_p2 : fir
  port map (clk  => fir_clk, 
            board_clk => clk,
            rst  => rst,
            x_in => x_in,
            y_out  => y);   

master_fir_ila : ila_1
PORT MAP (
	clk => clk,
	probe0 => x_in, 
	probe1 => y, 
	probe2 => addr_0, 
	probe3 => addr_1,
	probe4(0) => fir_clk
);


end Behavioral;