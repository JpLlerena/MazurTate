# MazurTate

NOTA IMPORTANTE: Es la primera vez que ocupo esta documentación de Github así que voy a intentar que quedo lo más claro posible y tal vez la modifique para agregar los hypervínculos.

Vamos a mencionar 2 formas de usar SageMath:

1) Existe la posibilidad de usar la página CoCalc, que tiene una implementación de SageMath y se puede usar en la misma página web de CoCalc. La página de CoCalc es la siguiente: https://cocalc.com/features/sage
Lamentablemente esta forma no siempre va a funcionar para calcular los símbolos modulares, ya que CoCalc tiene un límite de cuanto se puede demorar el programa y si el programa se demora más de ese tiempo, entonces no va a devolver la respuesta. Esto es un problema ya que calcular los símbolos modulares de una curva elíptica con un conductor muy grande e.g. 20.000, va a tomar mucho más tiempo de que permite CoCalc. 

2) Para evitar la limitante del tiempo, que fué lo que se hizo para la tesis, fué instalar el programa de SageMath directamente en el computador. Para eso se pueden seguir las intrucciones de: https://doc.sagemath.org/html/en/installation/index.html. Lamentablemente existe otra limitante de esta forma, que es el computador que uno esta utilizando. Sin importar el método que uno este utilizando, si el computador que uno esta utilizando es lento, entonces los SageMath puede demorarse mucho tiempo en devolver el valor de los símbolos modulares. Para obtener los más de 500.000 pares utilizandos en la tesis, no sé calculo exactamente el tiempo total, pero fueron alrededor de 8 horas diarias a los largo de 3 semanas. La otra limitante de usarlo en el computador personal es que para asegurarme de que SageMath no iba a devolver algún error, para el cálculo inicial, utilicé la implementación ya que es más lento pero a veces más seguro y se puede dejar el computador sin supervización (Lo cual el método de C. Wuthrich lamentablemente puede presentar en algunas curvas elípticas).


Ahora: Se van a presentar 3 programas con varios niveles de complejidad, el último siendo el que se ocupo en la tesis para calcular los símbolos modulares:

1) En el archivo test1.sage se encuentra la forma más fácil de calcular la versión multiplicativa de la conjetura 5 y la conjetura 6 de Mazur-Tate 1987. Codigo: https://github.com/JpLlerena/MazurTate/blob/e29ebd6c02d86b4f4824266c3aa0a129218055d3/Test1.sage 
   
2) En el archivo test2.sage se encuentra una forma que SÓLO va a funcionar si se tiene SageMath instalado instalado en el computador y además si se tiene descargado e instalado la base de curvas elíptícas de Cremona.

3) En el archivo TesisRaw.sage se encuentre el archivo original que se ocupo en la tesis. Ahora, en el momento de hacer la tesis se pensó probar más conjeturas y a diferentes niveles. Por lo tanto, hay muchas lineas/funciones/objetos definidos que no sirven o directamente no se ocuparon. En el archivo Tesis.sage, se encuentra el mismo código pero solo con las líneas que se utilizaron y con mejor nombre de variables. La complejidad de se debe a que porque como los símbolos modulares se demoran mucho en cálcular, en cambio de dejar el computador prendido sin detenerse, se implemento una forma de primero cálcular símbolos modulares, guardarlos en un archivo .txt, cosa de que se puede apagar el computador y luego cuando se vuelva a iniciar el programa, siga calculando los símbolos modulares sin necesidad de cálcular los que están guardados en el .txt. Adicionalmente, para acelerar el proceso, se utilizó la implementación de multiprocessing de python para calcular varios símbolos modulares a la vez. Esto puede ser muy demandante para el computador y además puede utilizar mucha RAM, dependiendo de cuantos símbolos modulares se están cálculando a la vez y del conductor de estas. Hubo momentos que el programa llegó a utilizar más de 20 GB de memoria RAM, esto fué cuando se ocuparon 8 procesos (es decir 8 curvas elípticas simultaneamente), pero una forma de remediar eso es solo ocupa 1 proceso, es decir, una curva elíptica a la vez. Esto es mucho menos demandante que varios a la vez y ocupa menos memoria RAM. Pero es otra limitante de utilizar este programa a diferencia de los dos anteriores, posiblemente para gente no familiarizada.

# Tablas
Las tablas con todos las curvas elipticas se encuentran en el siguiente formato: El texto es identico al del apendice, solo que ahora se agregaron todas las curvas elípticas. Para la conjetura 5 de MT es la tabla Table_5.pdf (pesa bastante) y para la conjetura 6 de MT es la tabla Table_6.pdf.
Table 5: https://github.com/JpLlerena/MazurTate/blob/ea5124a5f8e7b5c52dffccf11bc190de670e593c/Table_5.pdf
Table 6: https://github.com/JpLlerena/MazurTate/blob/ea5124a5f8e7b5c52dffccf11bc190de670e593c/Table_6.pdf
