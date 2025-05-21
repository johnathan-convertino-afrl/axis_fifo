# AXIS FIFO
### FIFO for AXI streaming

![image](docs/manual/img/AFRL.png)

---

  author: Jay Convertino  
  
  date: 2021.06.29  
  
  details: Verilog AXIS FIFO provides a dual clock FIFO capable of async or sync clocks.  
  
  license: MIT   
   
  Actions:  

  [![Lint Status](../../actions/workflows/lint.yml/badge.svg)](../../actions)  
  [![Manual Status](../../actions/workflows/manual.yml/badge.svg)](../../actions)  
  
---

### Version
#### Current
  - V1.0.0 - initial release

#### Previous
  - none

### DOCUMENTATION
  For detailed usage information, please navigate to one of the following sources. They are the same, just in a different format.

  - [axis_fifo.pdf](docs/manual/axis_fifo.pdf)
  - [github page](https://johnathan-convertino-afrl.github.io/axis_fifo/)

### PARAMETERS

* FIFO_DEPTH : Depth of the fifo, must be a power of two number(divisable aka 256 = 2^8). Any non-power of two will be rounded up to the next closest.
* COUNT_WIDTH: Data count output width in bits. Should be the same power of two as fifo depth(256 for fifo depth... this should be 8).
* BUS_WIDTH  : Width of the axis data bus input/output in bytes.
* USER_WIDTH : Width of the axis user bus input/output in bits.
* DEST_WIDTH : Width of the axis dest bus input/output in bits.
* RAM_TYPE   : RAM type setting.
* PACKET_MODE: Set axis fifo to wait for tlast before allowing a read on master port output.
* COUNT_DELAY: Delay count by one clock cycle of the data count clock.
* COUNT_ENA  : Set this to 0 to disable (only disable if read/write/data_count are on the same clock domain!).

### COMPONENTS
#### SRC

* axis_fifo_ctrl.v
  * controls axis fifo behavior.
* axis_fifo.v
  * Wrapper for axis fifo components.
  
#### TB

* tb_axis.v
* tb_cocotb.v
* tb_cocotb.py
  
### FUSESOC

* fusesoc_info.core created.
* Simulation uses icarus to run data through the core.

#### Targets

* RUN WITH: (fusesoc run --target=sim VENDER:CORE:NAME:VERSION)
  - default (for IP integration builds)
  - lint
  - sim
  - sim_rand_data
  - sim_rand_ready_rand_data
  - sim_8bit_count_data
  - sim_rand_ready_8bit_count_data
  - sim_cocotb
