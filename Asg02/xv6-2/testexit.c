#include "types.h"
#include "stat.h"
#include "user.h"
#include <sys/types.h>    //NOTE: Added


int
main(int argc, char *argv[])
{
  pid_t pid = fork();
  int exit_status = 0;
  // printf(1, "%x", &exit_status);
  // printf(1, "\n");
  if(pid == 0)
  {
    exit2(-1);
  }
  else
  {
    wait2(&exit_status);
  }
  printf(1, "%d", exit_status);
  printf(1, "\n");
  exit2(1);
}
