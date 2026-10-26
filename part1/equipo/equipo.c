/*
 * Módulo propio del TP #4 (pregunta 9).
 *
 * Al cargarse imprime en el log del kernel el nombre del equipo (hostname) y
 * los integrantes del grupo; al descargarse se despide. Se ve con `sudo dmesg`.
 */
#include <linux/init.h>     /* __init, __exit */
#include <linux/module.h>   /* Requerido por todos los módulos */
#include <linux/kernel.h>   /* pr_info */
#include <linux/utsname.h>  /* utsname(): hostname, versión del kernel */

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("TP4: imprime el nombre del equipo en el log del kernel");
MODULE_AUTHOR("Borsotti Bosco, Ciacci, Leguizamon");
MODULE_VERSION("1.0");

/* Parámetro opcional: sudo insmod equipo.ko grupo="Otro nombre" */
static char *grupo = "Borsotti Bosco - Ciacci - Leguizamon";
module_param(grupo, charp, 0444);
MODULE_PARM_DESC(grupo, "Integrantes del grupo");

static int __init equipo_init(void)
{
	pr_info("equipo: modulo cargado en el equipo '%s' (kernel %s)\n",
		utsname()->nodename, utsname()->release);
	pr_info("equipo: grupo: %s\n", grupo);

	/* Devolver 0 indica una carga correcta */
	return 0;
}

static void __exit equipo_exit(void)
{
	pr_info("equipo: modulo descargado del equipo '%s'\n",
		utsname()->nodename);
}

module_init(equipo_init);
module_exit(equipo_exit);
