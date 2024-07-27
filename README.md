# Update
The final version was uploaded June 27 2024

# How to use SageMath
We will mention two ways of using SageMath:
1) At the moment of writting, there exists the possibility of using SageMath online, by its implementation on CoCalc. To use SageMath on the CoCalc website, follow this link: https://cocalc.com/features/sage.

It should be noted that even though this way of using SageMath has some limitations, the biggest limitation is timiwise. The time needed for calculating the space of modular symbols increases as the conductor of the elliptic curve increses and CoCalc has a time computation limitation (at least the free version). So, if this time is surpassed (e.g. calculating the modular symbol space of an elliptic curve of high conductor), then one gets a Timeout error.

2) To bypass the Timeout error given by CoCalc, it is possible to install SageMath on a local computer. This was the method used to run the script during the thesis. For a guide on how to install SageMath see: https://doc.sagemath.org/html/en/installation/index.html.

Unfortunately, there is also a limitation to this method, which is the hardware in which SageMath is installed. Depending on the personal computer, calculating the necessary modular symbols may take some seconds or some minutes. In a worst-case scenario, which may happen if the conductor of the elliptic curve in question is large, the computer may freeze if it runs out of RAM (Random Access Memory). 
For the calculations used in the thesis it took multiple hours of run time spanning around 3 weeks with a computer with 32 GB of RAM.

# Programs for conjectures
We will give 2 different codes to compute the conjectures. The reason being that the actual code that was used for the calculations is not user friendly (it was not created with that objective). Nevertheless, we will still upload it for transparency.

1) The files Test_1_Conjecture_5.sage and Test_1_Conjecture_6.sage contain the simplest way of calculating the multiplicative versions of conjecture 5 and conjecture 6 presented in the original Mazur and Tate article. This script can be run on CoCalc's website or a local computer.
   
For the script of conjecture 5: https://github.com/JpLlerena/MazurTate/blob/1acd58373f06f2e3109aa7a70838bd381603d1b8/Test_1_Conjecture_5.sage

For the script of conjecture 6: https://github.com/JpLlerena/MazurTate/blob/1acd58373f06f2e3109aa7a70838bd381603d1b8/Test_1_Conjecture_6.sage

2) The files Test_2_Conjecture_5.sage and Test_2_Conjecture_6.sage files can not be run on CoCalc's website and have to be run on a local computer. Also, some setup has to be done before running the script:
   
For the script of conjecture 5: https://github.com/JpLlerena/MazurTate/blob/1acd58373f06f2e3109aa7a70838bd381603d1b8/Test_2_Conjecture_5.sage

For the script of conjecture 6: https://github.com/JpLlerena/MazurTate/blob/1acd58373f06f2e3109aa7a70838bd381603d1b8/Test_2_Conjecture_6.sage


We also give the original code used for the calculations 'ThesisRaw.sage'. However, it is not recommended to use this code, as some modifications have to be done in the code depending on the purpose.

We also give the equivalent codes for the local conjectures:

1) Local version of the Test_1_Conjecture_5_local.sage and Test_1_Conjecture_6_local.sage files:

For the script of conjecture 5: https://github.com/JpLlerena/MazurTate/blob/1acd58373f06f2e3109aa7a70838bd381603d1b8/Test_1_Conjecture_5_local.sage

For the script of conjecture 6: https://github.com/JpLlerena/MazurTate/blob/1acd58373f06f2e3109aa7a70838bd381603d1b8/Test_1_Conjecture_6_local.sage

2) Local version of the Test_2_Conjecture_5_local.sage and Test_2_Conjecture_6_local.sage files:

For the script of conjecture 5: https://github.com/JpLlerena/MazurTate/blob/1acd58373f06f2e3109aa7a70838bd381603d1b8/Test_2_Conjecture_5_local.sage

For the script of conjecture 6: https://github.com/JpLlerena/MazurTate/blob/1acd58373f06f2e3109aa7a70838bd381603d1b8/Test_2_Conjecture_6_local.sage

# Thesis code

For the code used in the thesis: https://github.com/JpLlerena/MazurTate/blob/1acd58373f06f2e3109aa7a70838bd381603d1b8/ThesisRaw.sage

# Tables
Here we also give the full list of elliptic curves that, apparently, do not satisfy the multiplicative version of conjecture 5 and the multiplicative version of conjecture 6. The PDF is identical to the one presented in the thesis only that the full table is given, not only a partial one:

Table for conjecture 6: https://github.com/JpLlerena/MazurTate/blob/ea5124a5f8e7b5c52dffccf11bc190de670e593c/Table_6.pdf
