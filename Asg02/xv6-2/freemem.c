#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int i = freemem();
  printf(1, "%d", i, 1);
  printf(1, "\n");
  exit();
}
