import os
import sys
import time
import sage.parallel.multiprocessing_sage
import itertools
from multiprocessing import Pool
from sage.databases.cremona import cremona_to_lmfdb, lmfdb_to_cremona
from sage.schemes.elliptic_curves.ell_modular_symbols import ModularSymbolECLIB

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


def TestConjectures(Ep):
	File = open('./Results.txt', 'w')
	if True:
		Error = False
		E_Sage = EllipticCurve(Ep[0])
		E_Cremona = CremonaDatabase().data_from_coefficients(Ep[0])
		M_Sage = E_Sage.modular_symbol(+1, implementation='sage')
		M_Cremona = ModularSymbolECLIB(E_Sage, +1)
		for a in range(Ep[1]):
			if M_Sage(Rational(a/Ep[1])) !=  M_Cremona(Rational(a/Ep[1])):
				Error = True
		if Error:
			print('The elliptic curve:', Ep, 'has problems!!')
		ord_period = E_Sage.j_invariant().denominator().valuation(Ep[1])
		torsion_period = Integer(E_Sage.tate_curve(Ep[1]).parameter().unit_part().expansion()[0])

		C_5_L = 1
		if E_Cremona['rank'] == 0:

			Denominators = []
			for a in range(1, Ep[1]):
				Denominators.append(M_Sage(Rational(a/Ep[1])))
			D = lcm(Denominators)

			LeftSide = 1
			RightSide = 1
			for a in range(1, Ep[1]):
				LeftSide = LeftSide * a**(D * ord_period * M_Sage(Rational(a/Ep[1])) * E_Cremona['torsion_order'] * E_Cremona['torsion_order']) % Ep[1]

			RightSide = torsion_period^(2 * D * E_Cremona['db_extra'][0] * Integer(E_Cremona['db_extra'][-1]))

			if LeftSide % Ep[1] != RightSide % Ep[1] and LeftSide % Ep[1] != - RightSide % Ep[1]:
				C_5 = 0
				for ell in list(factor(Ep[1] - 1)):
					if gcd(ell[0], E_Sage.modular_degree()) > 1:
						continue
					generator = FindGenerator(Ep[1])
					Image_Left = MorphismFromUnits2Cyclic(Ep[1], generator, LeftSide)
					Image_Right = MorphismFromUnits2Cyclic(Ep[1], generator, RightSide)
					if Image_Left % ell[0]**(ell[1]) != Image_Right % ell[0]**(ell[1]) and Image_Left % ell[0]**(ell[1]) != - Image_Right % ell[0]**(ell[1]):
						C_5_L = 0

		else:
			C_5 = -1
			C_5_L = -1

		File.write(str(Ep) + ': ' + str([C_5, C_5_L]))
		File.close()
		return None


if '__main__' == __name__:
	for i in ['00000-09999', '10000-19999', '20000-29999','30000-39999','40000-49999','50000-59999','60000-69999','70000-79999','80000-89999','90000-99999']:
		ModularSymbolsfile = eval(open('./ModularSymbolsReady/{}.txt'.format(i), 'r').readlines()[0])
		for key in ModularSymbolsfile.keys():
			for prime in ModularSymbolsfile[key].keys():
				E = eval(key)
				p = Integer(prime)
				TestConjectures([E,p])