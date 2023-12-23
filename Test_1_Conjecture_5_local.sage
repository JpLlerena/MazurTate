def FindGenerator(Level):
	for PossibleGenerator in range(1,Level):
		for Exponent in range(1,Level):
				if Exponent == Level - 1:
					return PossibleGenerator
				elif PossibleGenerator**Exponent % Level == 1:
					print('here')

def MorphismFromUnits2Cyclic(Level, Generator, Number):
	for PossibleImage in range(1, Level):
		if (Generator**PossibleImage - Number) % Level == 0:
			return PossibleImage

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
	for ell in list(factor(Prime - 1)):
		if gcd(ell[0], E.modular_degree()) > 1:
			continue
		generator = FindGenerator(Prime)
		Image_Left = MorphismFromUnits2Cyclic(Prime, generator, L)
		Image_Right = MorphismFromUnits2Cyclic(Prime, generator, R)
		if Image_Left % ell[0]**(ell[1]) != Image_Right % ell[0]**(ell[1]):
    		print('The elliptic curve {} and the layer {} does not satisfy the local multiplicative version of conjecture 5'.format(Label, Prime))

