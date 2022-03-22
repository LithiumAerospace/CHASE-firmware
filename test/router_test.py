import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge

import util

@cocotb.test()
async def test(dut):
    await util.init(dut)
    await RisingEdge(dut.tx)
    assert await util.RMAPread(dut, 0x2124) == 1 # Port 1 Link up count
