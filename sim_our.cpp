#include "Vour.h"
#include <verilated.h>

#define toggle(sc, clk, n) clk = (sc) % (n) == 0 ? !(clk) : clk;

int main(int argc, char **argv, char** evn) {
  VerilatedContext* contextptr = new VerilatedContext; //create class pointer

  contextptr->commandArgs(argc, argv); //pass on the command arguments

  contextptr->traceEverOn(true);

  Vour* top = new Vour{contextptr}; //initializer list

  if (false && argc && argv && evn) {} //escape the inspection of --Wall
  
  Verilated::mkdir("logs");

  top->clk = 0;
  top->finish = 0;

  while (!contextptr->gotFinish()) { 
	if (contextptr->time() == 12) top->finish = 1;
    toggle(contextptr->time(), top->clk, 4);
    top->eval();
	contextptr->timeInc(1);
  }

  top->final();
  delete top;
  delete contextptr;

  return 0;
}
