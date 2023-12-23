import os
import sys
import time
import sage.parallel.multiprocessing_sage
import itertools
from multiprocessing import Pool
from sage.databases.cremona import cremona_to_lmfdb, lmfdb_to_cremona
from sage.schemes.elliptic_curves.ell_modular_symbols import ModularSymbolECLIB

def TestConjectures(Ep):
    File = open('./Results.txt', 'a')
    Error = False
    E_Sage = EllipticCurve(Ep[0])
    E_Cremona = CremonaDatabase().data_from_coefficients(Ep[0])
    M_Cremona = ModularSymbolECLIB(E_Sage, +1)

    ord_period = E_Sage.j_invariant().denominator().valuation(Ep[1])
    torsion_period = Integer(E_Sage.tate_curve(Ep[1]).parameter().unit_part().expansion()[0])

	C_6 = 1
	Denominators = []
	for a in range(Ep[1]):
		Denominators.append(M_Cremona(Rational(a/Ep[1])))
	D = lcm(Denominators)
	LeftSide = 1
	RightSide = 1
	for a in range(1, Ep[1]):
		LeftSide = LeftSide * a**(D * ord_period * M_Cremona(Rational(a/Ep[1]))) % Ep[1]

	RightSide = torsion_period^(D * M_Cremona(0))

	if LeftSide % Ep[1] != RightSide % Ep[1] and LeftSide % Ep[1] != - RightSide % Ep[1]:
		C_6 = 0
		File.write(str(Ep) + ': ' + str([C_5, C_5_L, C_6, C_6_L]))
		File.close()
		return None

	File.write(str(Ep) + ': ' + str([C_5, C_5_L, C_6, C_6_L]))
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