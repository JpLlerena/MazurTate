# How to use SageMath
We will mention two ways of using SageMath:
1) The exists the possibility of using SageMath online, by its implementation on CoCalc. To use SageMath on the CoCalc website, follow this link: https://cocalc.com/features/sage.
Unfortunately, this way of using SageMath will not always work, the reason being that the computation time required to calculate the necessary modular symbols may take more time than the maximum allowed, at which point one gets a Timeout error.

2) To bypass the Timeout error, and the method used in the thesis, it is possible to install SageMath on a local computer. For a guide on how to install SageMath see: https://doc.sagemath.org/html/en/installation/index.html.
Unfortunately, there is also a limitation to this method, which is the hardware in which SageMath is installed. Depending on the local computer, calculating the necessary modular symbols may take some seconds or some minutes. In a worst-case scenario, which may happen if the conductor of the elliptic curve in question is large, the computer may freeze if it runs out of RAM (Random Access Memory). 
For the calculations used in the thesis, it took multiple hours of run time, spanning around 3 weeks. 

Remark: For the calculation done in the thesis we used SageMath implementation, this was to avoid possible issues that may arise as the computer was left unsupervised for several hours.

# Programs for conjectures
We will give 3 different codes to compute the conjectures, with ever-increasing complexity (All of them contain an explanation at the beginning of the script):

1) The files Test_1_Conjecture_5.sage and Test_1_Conjecture_6.sage contain the simplest way of calculating the multiplicative versions of conjecture 5 and conjecture 6 presented in the original Mazur and Tate article. This script can be run on CoCalc's website or a local computer.
For the script of conjecture 5: 
For the script of conjecture 6: 

2) The files Test_2_Conjecture_5.sage and Test_2_Conjecture_6.sage files can not be run on CoCalc's website and have to be run on a local computer. Also, some setup has to be done before running the script:
For the script of conjecture 5: 
For the script of conjecture 6: 

3) The files Test_3_Conjecture_5.sage and Test_3_Conjecture_6.sage files can not be run on CoCalc's website and have to be run on a local computer. Also, several setup has to be done before running the script. It is not recommended to use if the user is not familiar with programming:
For the script of conjecture 5: Soon
For the script of conjecture 6: Soon

We also give the original code used for the calculations 'ThesisRaw.sage'. However, it is not recommended to use this code, as some modifications have to be done in the code depending on the purpose.

We also give the equivalent codes for the local conjectures:
1) Local version of the Test_1_Conjecture_5_local.sage and Test_1_Conjecture_6_local.sage files:
For the script of conjecture 5: 
For the script of conjecture 6: 

2) Local version of the Test_2_Conjecture_5_local.sage and Test_2_Conjecture_6_local.sage files:
For the script of conjecture 5: 
For the script of conjecture 6: 

3) Local version of the Test_3_Conjecture_5_local.sage and Test_3_Conjecture_6_local.sage files:
For the script of conjecture 5: Soon
For the script of conjecture 6: Soon

# Thesis code

For the code used in the thesis: 

# Tables
Here we also give the full the full list of elliptic curves that, apparently, do not satisfy the multiplicative version of conjecture 5 and the multiplicative version of conjecture 6. The PDF is identical to the one presented in the thesis only that the full table is given, not only a partial one:
Table for conjecture 5: https://github.com/JpLlerena/MazurTate/blob/ea5124a5f8e7b5c52dffccf11bc190de670e593c/Table_5.pdf
Table for conjecture 6: https://github.com/JpLlerena/MazurTate/blob/ea5124a5f8e7b5c52dffccf11bc190de670e593c/Table_6.pdf
