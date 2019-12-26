library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity square_wave is
  generic( PERIOD      : integer := 20; -- in number of clock cycles
           DUTY_CYC    : integer := 50; -- in number of clock cycles
           SAMPLE_N    : integer := 1024
  );
  Port (clk        : in  std_logic;  
        rst        : in  std_logic; 
        en_gen_in  : in  std_logic;                       -- start signal
        we_out     : out std_logic;                       -- write enable for the dpram
        address_out: out std_logic_vector(9 downto 0);    -- address for the dpram 
        y_out      : out std_logic_vector(31 downto 0));  -- data to write in the dpram
end square_wave;


architecture Behavioral of square_wave is

constant duty_cyc_perc: real := real(DUTY_CYC)/real(100);
constant up_cycles : integer := integer(real(PERIOD) * duty_cyc_perc);
constant down_cycles : integer := integer(real(PERIOD) * (real(1) - duty_cyc_perc));

signal y : std_logic_vector(31 downto 0);
signal gen_is_on: std_logic;
signal address: std_logic_vector(9 downto 0);
signal samples: integer;

type state is (s_idle, s_up, s_down);
signal state_fsm: state;
--signal encoded_state : unsigned(1 downto 0);


begin

p_square_wave: process(clk, rst) is
    variable tcnt: integer;

    begin
           
        if rst = '1' then 
            tcnt := 0;
            samples <= 0;
            gen_is_on <= '0';
            state_fsm <= s_idle;
            y <= std_logic_vector(to_signed(0, y'length));
        
        -- start square wave when en_gen_in is 1, stop after 1024 samples
        elsif rising_edge(clk) then

            case state_fsm is
            when s_idle =>
                if en_gen_in = '1' then
                    gen_is_on <= '1';
                    y <= std_logic_vector(to_signed(1024 , y'length)); 
                    --y <= std_logic_vector(to_signed(8 , y'length)); 
                    state_fsm <= s_up;
                else
                    state_fsm <= s_idle;
                end if;  
                
            when s_up => 
                if tcnt = up_cycles-1 then
                    tcnt := 0;
                    y <= std_logic_vector(to_signed(-1024, y'length));
                    --y <= std_logic_vector(to_signed(-8, y'length));
                    state_fsm <= s_down;
                else
                    tcnt := tcnt + 1;
                end if;
                    
            when s_down =>
                if tcnt = down_cycles-1 then
                    tcnt := 0;
                    if gen_is_on = '1' then
                        y <= std_logic_vector(to_signed(1024 , y'length)); 
                        --y <= std_logic_vector(to_signed(8 , y'length)); 
                        state_fsm <= s_up;
                    else 
                        y <= std_logic_vector(to_signed(0, y'length));
                        state_fsm <= s_idle;
                    end if;
                else
                    tcnt := tcnt + 1;
                end if;           

            when others =>
                state_fsm <= s_idle;
                    
            end case;
            
            -- handle addresses of dpram  
            if gen_is_on = '1' then
                address <= std_logic_vector(to_unsigned(samples, address'length));
                if samples = SAMPLE_N then
                    samples <= 0;
                    gen_is_on <= '0';
                else
                    samples <= samples + 1;
                end if;
            end if;
            
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


y_out <= y;
we_out <= gen_is_on;
address_out <= address;


end Behavioral;