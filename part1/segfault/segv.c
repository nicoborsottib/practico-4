/*
 * Pregunta 7: qué es un segmentation fault y cómo lo maneja un programa.
 *
 *   gcc -Wall -g -o segv segv.c
 *   ./segv            -> sin manejador: el kernel lo termina con SIGSEGV
 *   ./segv manejar    -> instala un manejador y reporta la dirección que falló
 */
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static void manejador(int sig, siginfo_t *info, void *ctx)
{
	(void)ctx;
	/* En un manejador de señales solo se pueden usar funciones async-signal-safe;
	 * para un ejemplo didáctico alcanza con fprintf. */
	fprintf(stderr, "Recibí la señal %d (SIGSEGV) al acceder a %p\n",
		sig, info->si_addr);
	_exit(1); /* volver de aquí reintentaría la instrucción y fallaría otra vez */
}

int main(int argc, char *argv[])
{
	if (argc > 1 && strcmp(argv[1], "manejar") == 0) {
		struct sigaction sa = { 0 };
		sa.sa_sigaction = manejador;
		sa.sa_flags = SA_SIGINFO;
		sigaction(SIGSEGV, &sa, NULL);
		printf("Manejador de SIGSEGV instalado\n");
	}

	int *p = NULL;
	printf("Voy a escribir en la dirección %p...\n", (void *)p);
	fflush(stdout);
	*p = 42; /* no hay ninguna página mapeada en la dirección 0 */

	printf("Esto nunca se imprime\n");
	return 0;
}
