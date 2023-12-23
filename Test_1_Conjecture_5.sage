'''
##################################################
# Explanation of the code                        #
##################################################

Every ellitptic curve has a unique label in the L-functions and modular forms database (LMFDB). For a detailed explanation on the way the labbeling code works see: https://www.lmfdb.org/knowledge/show/ec.q.lmfdb_label?timestamp=1677486297381499
We will explain, more or less, some important lines in the script. We will use the example of the elliptic curve 11.a1 and the prime for which E has split multiplicative reduction as 11.

Code:
Label = '11.a1'

Observation:
One has to make sure that the label is contain within quotes, otherwise an issue will arise. This is to make sure that Label is a string type object.

Code:
E = EllipticCurve(Label)

Observation:
This construct the elliptic curve with label Label, in this case '11.a1'. For more information see: https://doc.sagemath.org/html/en/constructions/elliptic_curves.html

Code:
TE = E.tate_curve(Primo)

Observation:
This construct the Tate curve corresponding to the elliptic curve '11.a1' at the prime 11. This will be used to obtain the p-expansion of the Tate p-adic period. For more information see: https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/ell_tate_curve.html

Code:
q_e = TE.parameter()

Observation:
This code recovers the Tate p-adic period of the Tate curve 'TE'. For more imformation see: https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/ell_tate_curve.html#sage.schemes.elliptic_curves.ell_tate_curve.TateCurve.parameter

Code:
ordq_E = E.j_invariant().denominator().valuation(Primo)

Observation:
This code uses the fact that the p-adic valuation of the Tate p-adic period is equal to minus the p-adic valuation of the j-invariant of the elliptic curve. This line calculates the p-adic valuation of the denominator of the j-invariant of E. Because we are considering the p-adic valuation of the denominator and not of the j-invariant, it is not neccessary to multiply by -1.
For more information on the j-invariant see: https://doc.sagemath.org/html/en/constructions/elliptic_curves.html#j-invariant
For more information on the denominator see: https://doc.sagemath.org/html/en/reference/rings_standard/sage/rings/rational.html#sage.rings.rational.Rational.denominator
For more information on the valuation see: https://doc.sagemath.org/html/en/reference/rings_standard/sage/rings/rational.html#sage.rings.rational.Rational.valuation

Code:
q_l = Integer(q_e.unit_part().expansion()[0])

Observation:
This code is used to obtain the first non-zero coefficient on the p-adic expansion of the Tate p-adic period.
The command, unit_part() return the p-adic expansion, in this case, of the Tate p-adic period after multiplying by a power of p, such that it has valuation 0. 
For more information on unit_part see: https://doc.sagemath.org/html/en/reference/padics/sage/rings/padics/padic_fixed_mod_element.html#sage.rings.padics.padic_fixed_mod_element.FMElement.unit_part
Afterwards, the command expansion()[0] converts the p-adic expansion into a ordered list and considers the first entry of such list i.e. the first non-zero coefficient on the p-adic expansion of the Tate p-adic period.
For more information on expansion see: https://doc.sagemath.org/html/en/reference/padics/sage/rings/padics/padic_fixed_mod_element.html#sage.rings.padics.padic_fixed_mod_element.pAdicTemplateElement.expansion
Finally, the command Integer is to guarantee that the output is an integer.

Code:
M = E.modular_symbol(+1, implementation="sage")

Observation:
This initalize the modular space of the elliptic curve. For more information see: https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/ell_modular_symbols.html
For the different implementation for using the modular symbols:

implementation="sage" uses the implementation by SageMath
implementation="num" uses the implementation by C. Wuthrich.
implementation="eclib" uses the implementation by J. Cremona.

Code:
LMS = []
LMSD = []
for a in range(1, Primo):
    V = M(a/Primo)
    LMSD.append(V.denominator())
    LMS.append(V)
D = lcm(LMSD)

Observation:
These lines calculate all the necessary modular symbols (the modular symbols with values of the form a/prime with a\in {1,2,...,prime}) and adds them to the list LMS. At the same time, it also adds to the list LMSD the denominators of the modular symbols. It also calculates the least common multiple between all the denominators of the modular symbols. For more information of the command lcm see: https://doc.sagemath.org/html/en/reference/rings_standard/sage/arith/functions.html#sage.arith.functions.lcm
Also, note that the first entry of the list LMS is the modular symbol of 0.

Code:
tau = E.torsion_order()
Sha = E.sha().an() 
C_E = E.tamagawa_product()
R = q_l^(C_E * Sha * 2 * D)

Observation:
This line of code calculates the right side of the equation for the multiplicative version of conjecture 5. 
For more information about torsion_order see: https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/ell_number_field.html#sage.schemes.elliptic_curves.ell_number_field.EllipticCurve_number_field.torsion_order
For more information about analytic Sha see: https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/sha_tate.html#sage.schemes.elliptic_curves.sha_tate.Sha.an
For more information about Tamagawa product see: https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/ell_number_field.html#sage.schemes.elliptic_curves.ell_number_field.EllipticCurve_number_field.tamagawa_product
For the Reliability of the Data see: https://www.lmfdb.org/EllipticCurve/Q/Reliability

Code:
L = 1
a = 1
for b in LMS:
    L = L*a^(D * b * ordq_E * tau * tau)
    a = a+1

Observation:
This line of code calculates the left side of the equation for the multiplicative version of conjecture 5.

Code:
if L%Primo != R%Primo and L%Primo != -R%Primo:
    print('The elliptic curve {} and the layer {} does not satisfy the multiplicative version of conjecture 5'.format(Label, Prime))
else:
    print(''The elliptic curve {} and the layer {} does satisfy the multiplicative version of conjecture 5'.format(Label, Prime)')

Observation:
This checks if the multiplicative version of conjecture 5 is satisfied or not. 

##################################################
# End Explanation of the code                    #
##################################################
'''

# The following two lines of codes are the ones that should be change by the user. Copy from the next line onwards to check the multiplicative version of conjecture 5.
Label = '11.a1'
Prime = 11

E = EllipticCurve(Label)
TE = E.tate_curve(Prime)
q_e = TE.parameter()
ordq_E = E.j_invariant().denominator().valuation(Prime)


q_l = Integer(q_e.unit_part().expansion()[0])

M = E.modular_symbol(+1, implementation="sage")

LMS = []
LMSD = []
for a in range(1, Prime):
    V = M(a/Prime)
    LMSD.append(V.denominator())
    LMS.append(V)
D = lcm(LMSD)

tau = E.torsion_order()
Sha = E.sha().an() 
C_E = E.tamagawa_product()
R = q_l^(C_E * Sha * 2 * D)


L = 1
a = 1
for b in LMS:
    L = L*a^(D * b * ordq_E * tau * tau)
    a = a+1

if L%Prime != R%Prime and L%Prime != -R%Prime:
    print('The elliptic curve {} and the layer {} does not satisfy the multiplicative version of conjecture 5'.format(Label, Prime))
else:
    print('The elliptic curve {} and the layer {} does satisfy the multiplicative version of conjecture 5'.format(Label, Prime))
