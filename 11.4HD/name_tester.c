#include <stdio.h>
#include <string.h>
#include "terminal_user_input.h"

#define LOOP_COUNT 60

void print_silly_name() {
  printf(" a ");
  int index;
  for(index = 0; index < LOOP_COUNT; index++) {
    printf(" silly ");
  }
  printf("name!\n");
}

int main() {
  my_string name;
  int index;
 
  name = read_string("What is your name? ");

  printf("\nYour name %s is", name.str);

  if (strcmp(name.str, "Afzal") == 0) {
    printf(" an AWESOME name!");
  } else {
    print_silly_name();
  }
  // Move the following code into a procedure
  // ie:  void print_silly_name(my_string name)
  return 0;  
}
