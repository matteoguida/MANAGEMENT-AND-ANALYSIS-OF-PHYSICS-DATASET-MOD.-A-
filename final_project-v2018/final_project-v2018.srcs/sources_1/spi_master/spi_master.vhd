library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity spi_master is
   generic (
      WTIME    : integer   := 100;
      TXBITS   : integer   := 16;
      RXBITS   : integer   := 8
      );
   port ( 
      clock    : in  std_logic;
      reset    : in  std_logic;
      txd      : in  std_logic_vector(TXBITS-1 downto 0);
      rxd      : out std_logic_vector(RXBITS-1 downto 0);
      start    : in  std_logic;
      ready    : out std_logic;
      miso     : in  std_logic;
      mosi     : out std_logic;
      sclk     : out std_logic;
      cs       : out std_logic
      );
end spi_master;

architecture Behavioral of spi_master is

type state is (s_idle, s_send, s_receive);
type ready_state is (state_idle, state_ready);
signal state_fsm : state;
signal state_fsm2 : ready_state;
signal mosi_s, sclk_s, cs_s : std_logic;
signal bufout : std_logic_vector(TXBITS-1 downto 0);
signal bufin : std_logic_vector(RXBITS-1 downto 0);
signal startp : std_logic;
signal get_ready_s, ready_s : std_logic;
-- debug signal
signal encoded_state_fsm : std_logic_vector(1 downto 0);


--COMPONENT ila_1

--PORT (
--	clk : IN STD_LOGIC;



--	probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
--	probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
--	probe2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
--	probe3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
--	probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
--	probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
--	probe6 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
--	probe7 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe8 : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
--);
--END COMPONENT  ;

begin

p_fsm: process(clock, reset) is
    variable tcnt : integer;
    variable wcnt : integer;
    variable rcnt : integer;
    
    begin
    if reset = '1' then
        state_fsm <= s_idle;
        tcnt := 0;
        wcnt := TXBITS - 1;
        rcnt := RXBITS - 1;
        bufin <= std_logic_vector(to_unsigned(0, RXBITS)); -- check if necessary to initialize to zero or not
        get_ready_s <= '0';
        
    elsif rising_edge(clock) then
        startp <= start;
        case state_fsm is
            when s_idle => 
                -- start non negato
            get_ready_s <= '0';
            if start = '1' and startp = '0' then
                state_fsm <= s_send;
                bufout <= txd;
                cs_s <= '0';
             else
                state_fsm <= s_idle;
             end if;
                       
            when s_send =>
             -- aumento il conteggio del clock interno fornito dall'FPGA
            tcnt := tcnt + 1;
             -- al primo conteggio (si dà per scontato che parta da zero)
            if  tcnt = 1 then
            -- parte bassa del clock (fino a WTIME/2)
                sclk_s <= '0';
            -- leggo la posizione wcnt di bufout
                mosi_s <= bufout(wcnt);
            -- a metà il segnale di clock viene alzato a 1 
            -- (e quindi c'è il rising edge di sclock)
            elsif tcnt = WTIME / 2 then
                sclk_s <= '1';
            elsif tcnt = WTIME then
                tcnt := 0;
                sclk_s <= '0';
                -- se ho finito di leggere bufout allora metto mosi a 1
                if wcnt = 0 then
                    wcnt := TXBITS - 1;
                    mosi_s <= '1';
                    state_fsm <= s_receive;
                -- altrimenti leggi la posizione successiva
                else
                    wcnt := wcnt - 1;
                end if;
            --else -> should we use it or not?
            end if;
                    
          when s_receive =>
             tcnt := tcnt + 1;
             if  tcnt = 1 then
                 sclk_s <= '0';
             elsif tcnt = WTIME / 4 then
                 bufin(rcnt) <= miso;
             elsif tcnt = WTIME / 2 then
                 sclk_s <= '1';
             elsif tcnt = WTIME then
                 tcnt := 0;
                 sclk_s <= '0';
                 if rcnt = 0 then
                     rcnt := RXBITS - 1;
                     rxd <= bufin;
                     get_ready_s <= '1';
                     state_fsm <= s_idle;
                     cs_s <= '1';
                 else
                     rcnt := rcnt - 1;
                 end if;
          -- else -> should we use it or not?
            end if;
          end case;                
    end if;
    end process;

      
p_ready: process(clock,reset) is
    variable flag : std_logic;
    begin
        if reset = '1' then
            state_fsm2 <= state_idle;
            ready_s <= '0';
            flag := '0';
            
        elsif rising_edge(clock) then
            case state_fsm2 is
                when state_idle =>
                    if get_ready_s = '1' and flag = '0' then
                        state_fsm2 <= state_ready;
                        ready_s <= '1';
                    else
                        state_fsm2 <= state_idle;
                    end if;
                when state_ready =>
                    state_fsm2 <= state_idle;
                    ready_s <= '0';
                    flag := '1';
                end case;
         end if;           
    end process;

-- debug part 

--ila_spi_master : ila_1
--PORT MAP (
--	clk => clock,

--    probe0(0) => start,
--	probe1(0) => reset, 
--	probe2 => txd, 
--	probe3 => bufin, 
--	probe4(0) => miso, 
--	probe5(0) => mosi_s, 
--	probe6(0) => sclk_s, 
--	probe7(0) => cs_s,
--	probe8 => encoded_state_fsm
--);
  -- Convert FSM state into integer values to show them on ILA core
  
  encode_FSM : process(clock) is 
  begin 
    case state_fsm is
        when s_idle =>
            encoded_state_fsm <= std_logic_vector(to_unsigned(0, 2)); -- (value, lenght)
        when s_send =>
            encoded_state_fsm <= std_logic_vector(to_unsigned(1, 2)); -- (value, lenght)
        when s_receive =>
             encoded_state_fsm <= std_logic_vector(to_unsigned(2, 2)); -- (value, lenght)
    end case;
  end process;
  
cs <= cs_s; 
sclk <= sclk_s;
mosi <= mosi_s; 
ready <= get_ready_s;

end Behavioral;
