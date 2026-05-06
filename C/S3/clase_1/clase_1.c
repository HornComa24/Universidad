
// #include <stdio.h> // Incluye la biblioteca estándar de entrada/salida
//
// int main() {
//   // Aquí va el código del programa
//   printf("¡Hola, mundo!\n"); // Imprime "¡Hola, mundo!" en la consola
//   return 0; // Indica que el programa se ejecutó con éxito
// }

// #include <stdio.h>
//
// int main() {
//   int edad = 25;       // Declara una variable entera llamada edad y la
//   inicializa con 25 float altura = 1.75;  // Declara una variable de punto
//   flotante llamada altura y la inicializa con 1.75 char inicial = 'A';  //
//   Declara una variable de tipo carácter llamada inicial y la inicializa con
//   'A' double pi = 3.14159; // Declara una variable de punto flotante de doble
//   precisión llamada pi printf("El valor de int es = %d, el valor de float =
//   %f, el valor de char = %c, y el double es %lf", edad, altura, inicial, pi);
// }

// #include <stdio.h>
//
// int main() {
//   int a = 10, b = 5;
//   int suma = a + b;       // Suma: 10 + 5 = 15
//   int resta = a - b;      // Resta: 10 - 5 = 5
//   int multiplicacion = a * b; // Multiplicación: 10 * 5 = 50
//   float division = (float)a / b; // División: 10 / 5 = 2.0 (se castea a float
//   para obtener decimal) int modulo = a % b;     // Módulo (resto de la
//   división): 10 % 5 = 0 printf("Los valores son a = %d y b = %d\n", a, b);
//   printf("La suma de a + b = %d\n", suma);
//   printf("La resta de a - b = %d\n", resta);
//   printf("La multiplicacion de a * b = %d\n", multiplicacion);
//   printf("La división de a / b = %f\n", division);
//   printf("El modulo de a / b = %d\n", modulo);
//   printf("La suma de a++ = %d\n", a++); // Incremento (a = a + 1)
//   printf("La resta de b-- = %d\n", b--); // Decremento (b = b - 1)
// }

// #include <stdio.h>
//
// int main() {
//   int edad;
//   printf("Ingresa tu edad: "); // Imprime un mensaje en la consola
//   scanf("%d", &edad);        // Lee un entero de la consola y lo almacena en
//   la variable edad printf("Tu edad es: %d años\n", edad); // Imprime el valor
//   de la variable edad
// }

// #include <stdio.h>
//
// int sumar(int x, int y); // Declaración de la función (prototype)
//
// int main() {
//   int num1 = 5, num2 = 3;
//   int resultado = sumar(num1, num2); // Llamada a la función sumar()
//   printf("La suma es: %d\n", resultado);
//   return 0;
// }
//
// // Definición de la función
// int sumar(int x, int y) {
//   return x + y; // Retorna la suma de x e y
// }

// INFO Ejercicio propuesto Escribe un programa que pida al usuario dos números
// y calcule su suma, resta, multiplicación y división.

// #include <stdio.h>
//
// int sumar(int x, int y) {
//   return x + y;
// }
//
// int restar(int x, int y) {
//   return x - y;
// }
//
// int dividir(int x, int y) {
//   return x / y;
// }
//
// int multiplicar(int x, int y) {
//  return x * y;
// }
//
// int main() {
//   int n1,n2;
//   printf("Escriba los numeros que quiera sumar, restar, multiplicar y
//   dividir:\n"); printf("Primer numero: "); scanf("%d", &n1); printf("Segundo
//   numero: "); scanf("%d", &n2); int suma = sumar(n1,n2); int resta =
//   restar(n1,n2); float división = dividir(n1,n2); int multiplicación =
//   multiplicar(n1,n2); printf("Los resultados son suma = %d, resta = %d,
//   division = %f y multiplicación = %d\n",suma,resta,división,multiplicación);
// }

// INFO Escribe un programa que convierta grados Celsius a Fahrenheit.

// #include <stdio.h>
//
// int convesor(int c) {
//   return (c * 9/5 ) + 32;
// }
//
// int main() {
//   int g;
//   printf("Escribe la cantidad de grados celcius que quieras convertir a
//   grados Fahrenheit: "); scanf("%d",&g); float f = convesor(g);
//   printf("Tendras %.2f grados Fahrenheit", f);
// }

// INFO Escribe un programa que calcule el área de un círculo.

// INFOEscribe una función que calcule el factorial de un número.
