#include "frida-core.h"

#include <errno.h>
#include <unistd.h>
#include <sys/stat.h>

guint
frida_helper_factory_spawn_helper (const gchar * path, gchar ** argv, int argv_length, GError ** error)
{
  gchar ** envp;
  pid_t pid;

  chmod (path, S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);

  envp = g_get_environ ();

  pid = vfork ();
  if (pid < 0)
    goto handle_vfork_error;

  if (pid == 0)
  {
    execve (path, argv, envp);
    _exit (1);
  }

  g_strfreev (envp);

  return pid;

handle_vfork_error:
  {
    g_strfreev (envp);
    g_set_error (error,
        FRIDA_ERROR,
        FRIDA_ERROR_INVALID_ARGUMENT,
        "Unable to spawn helper executable at “%s”: %s",
        path, g_strerror (errno));
    return 0;
  }
}
