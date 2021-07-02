//
// Fusion-C
// My First Program in C
//
#include <stdio.h>
#include "fusion-c/header/msx_fusion.h"
#include "fusion.h"

void main(char *argv[], int argc) 
{
  char c='\0';
  char str[20];

  desktop(argv[0]);
  printf("Argv[0]=%s",argv[0]);

  while ((c=InputChar()) != 'q') {
    Print(">Fusion LOOP<\n");
  }
  Print("Qual a informacao: ");
  InputString(str, 20);
  printf("%s",str);
}
 


void desktop(char *header) {
    Cls();
    Screen(0);
    Width(40);
    printf("Dektop: %s", header);
    Locate(5,10);
}
