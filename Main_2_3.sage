import os
import sys
import time
import sage.parallel.multiprocessing_sage
import itertools
from multiprocessing import Pool
from sage.databases.cremona import cremona_to_lmfdb, lmfdb_to_cremona

file_names = ['00000-09999', '10000-19999', '20000-29999','30000-39999','40000-49999','50000-59999','60000-69999','70000-79999','80000-89999','90000-99999']

class GroupAlebra:

	def __init__(self, Level):
		self.Level = Level
		self.Coefficients = {}
		self.Base = Level.coprime_integers(Level)
		for index in self.Base:
			self.Coefficients[index] = 0
	
	def ScalarMultiplication(self, Scalar):
		for Index in self.Base:
			self.Coefficients[Index] = self.Coefficients[Index] * Scalar
		
	def Add(self, Other):
		if self.Level != Other.Level:
			print('Not same Level')
			return 0
		Sum = GroupAlebra(self.Level)
		for Index in self.Base:
			Sum.Coefficients[Index] = self.Coefficients[Index] + Other.Coefficients[Index]
		return Sum
	
	def Multiply(self, Other):
		if self.Level != Other.Level:
			print('Not same Level')
			return 0
		MonomialProduct = []
		for index1 in self.Base:
			for index2 in Other.Base:
				MonomialProduct.append([self.Coefficients[index1] * Other.Coefficients[index2], index1 * index2 % self.Level])

		Product = GroupAlebra(self.Level)
		for Monomial in MonomialProduct:
			Product.Coefficients[Monomial[1]] = Product.Coefficients[Monomial[1]] + Monomial[0]
		return Product
	
	def SetCoefficients(self, Coefficients):
		for Coefficient in Coefficients:
			self.Coefficients[Coefficient[1]] = Coefficient[0]
	
	def SetCoefficientsReturn(self, Coefficients):
		for Coefficient in Coefficients:
			self.Coefficients[Coefficient[1]] = Coefficient[0]
		return self
	
	def Print(self):
		print(self.Coefficients)
	
	def OnlyCoefficients(self):
		OnlyCoefficients = []
		for BaseElement in self.Base:
			OnlyCoefficients.append(self.Coefficients[BaseElement])
		return OnlyCoefficients

	
class AugmentedIdealPower:

	def __init__(self, Level):
		self.Level = Level
		self.ElementsInGroup = Level.coprime_integers(Level)
		self.Bases = {}

	def SetBaseGivenDepth(self, Depth):
		tiempo_2 = time.time()
		Base = []
		for index in range(1,len(self.ElementsInGroup)):
			Base.append(GroupAlebra(self.Level).SetCoefficientsReturn([[-1,1], [1, self.ElementsInGroup[index]]]))
		if Depth > 1:
			DepthStep = Depth
			TempBase = Base.copy()
			while DepthStep > 1:
				PrimalBase = TempBase.copy()
				TempBase = []
				DepthStep -= 1
				for StepElement in PrimalBase:
					for PrimalElement in Base:
						TempBase.append(PrimalElement.Multiply(StepElement))
			IndependentElementsVectors = []
			for TempElement in TempBase:
				IndependentElementsVectors.append(TempElement.OnlyCoefficients())
			FreeModule = span(IndependentElementsVectors, ZZ)
			Base = []
			print(FreeModule.gens(), 'ren')
			quit()
			for BaseVector in FreeModule.gens():
				print(BaseVector)
				TempElement = GroupAlebra(self.Level)
				Base.append(TempElement.SetCoefficientsReturn(BaseVector))

		self.Bases[Depth] = Base

	def FindAllBases(self,MaxDepth):
		for AugmentedPower in range(1, Depth):
			self.AllBases[AugmentedPower] = FindBaseGivenDepth(AugmentedPower)
		return 1
	
	def IsZero(self, Vector, Depth):
		FreeModule = span(self.Bases[Depth], ZZ)
		try:
			FreeModule.coordinate_vector(Vector, check=True)
			return True
		except ArithmeticError:
			return False

class EllipticCurveClass:
	
	def __init__(self, CremonaName, Conductor, EquationCoefficients, AlgebraicRank, Torsion, TamagawaNumber, Sha, ModularDegree):

		# Number from Cremona table
		self.EquationCoefficients = EquationCoefficients
		self.SplitPrimes = []
		self.NonSplitPrimes = []
		self.FindNonSplitPrimes()
		self.FindSplitPrimes()
	
	def ReturnAllData(self):
		return [self.CremonaName, self.Conductor, self.EquationCoefficients, self.AlgebraicRank, self.Torsion, self.TamagawaNumber, self.Sha, self.ModularDegree]
	
	def FindSplitPrimes(self):
		Factorization = list(factor(self.Conductor))
		for Prime in Factorization:
			if EllipticCurve(self.EquationCoefficients).has_split_multiplicative_reduction(Prime[0]):
				self.SplitPrimes.append(Prime[0])

	def FindNonSplitPrimes(self):
		Factorization = list(factor(self.Conductor))
		for Prime in Factorization:
			if EllipticCurve(self.EquationCoefficients).has_nonsplit_multiplicative_reduction(Prime[0]):
				self.NonSplitPrimes.append(Prime[0])
	

def DumpData(ListEllipticCurvesObjects):
	DumpDataFile = open('./Data/DumpData.txt')
	for EllipticCurve in ListEllipticCurvesObjects:
		DumpDataFile.write(Elliptic_curve.ReturnAllData() + '\n')
	DumpData.close()
	return True

def ReadData():
	ListEllipticCurvesObjects = []
	DumpDataFile = open('./Data/DumpData.txt')
	for EllipticCurveLineComplete in DumpDataFile.readlines():
		EllipticCurveLine = EllipticCurveLineComplete[:-1].split(';')
		ListEllipticCurvesObjects.append(EllipticCurveClass(EllipticCurveLine[0], eval(EllipticCurveLine[1]), eval(EllipticCurveLine[2]), eval(EllipticCurveLine[3]), eval(EllipticCurveLine[4]), eval(EllipticCurveLine[5]), eval(EllipticCurveLine[6]), eval(EllipticCurveLine[7])))
	return ListEllipticCurvesObjects

def FindGenerator(Level):
	for PossibleGenerator in range(1,Level):
		for Exponent in range(1,Level):
				if Exponent == Level - 1:
					return PossibleGenerator
				elif PossibleGenerator**Exponent % Level == 1:
					break

def MorphismFromUnits2Cyclic(Level, Generator, Number):
	for PossibleImage in range(1, Level):
		if (Generator**PossibleImage - Number) % Level == 0:
			return PossibleImage

def TestRefinedConjeture(EllipticCurveObject, SplitPrimesWithExponent, Level, Depth):
	EllipticCurveSage = EllipticCurve(EllipticCurveObject.EquationCoefficients)
	jInvariant = EllipticCurveSage.j_invariant()
	ModularSymbol = EllipticCurveSage.modular_symbol()
	for SplitPrimeData in SplitPrimesWithExponent:
		TateCurve = EllipticCurveSage.tate_curve(SplitPrimeData[0])
		pAdicParameter = TateCurve.parameter()
		OrderpAdicParameter = jInvariant.denominator().valuation(SplitPrimeData[0])
		TorsionpAdicParameter = (pAdicParameter * SplitPrimeData[0]^(-1 * OrderpAdicParameter)).unit_part().expansion()[0]
	ListValuesModularSymbols = ComputatioComputationModularSymbols(EllipticCurveObject, EllipticCurveSage, Level)
	ListCommonDenominators = []	
	CommonDenominatorModularSymbols = lcm(ListValuesModularSymbols)
	LeftSide = []
	LeftSideElement = GroupAlebra(Level)
	for a, index in zip(Level.coprime_integers(Level), range(0, euler_phi(Level))):
		LeftSide.append([CommonDenominatorModularSymbols * OrderpAdicParameter * ListValuesModularSymbols[index], a])
	LeftSideElement.SetCoefficients(LeftSide)
	RightSideElement = GroupAlebra(Level)
	RightSide = ListValuesModularSymbols[-1] * CommonDenominatorModularSymbols
	RightSideElement.SetCoefficients([[ListValuesModularSymbols[-1] * CommonDenominatorModularSymbols, 1],[ListValuesModularSymbols[-1] * CommonDenominatorModularSymbols, TorsionpAdicParameter]])


	
def ComputatioComputationModularSymbols(EllipticCurveObject, EllipticCurveSage, Level):
	ListModularSymbolsValues = []
	if os.path.exists('./ModularSymbols/{}/{}'.format(EllipticCurveObject.CremonaName, Level)):
		ModularSymbolsFile = open('./ModularSymbols/{}_{}'.format(EllipticCurveObject.CremonaName, Level), 'r').readlines()[0][1:-1].split(',')
		for ValueModularSymbol in ModularSymbolsFile:
			ListModularSymbolsValues.append(Rational(ValueModularSymbol))
		return ListModularSymbolsValues
	ModularSymbol = EllipticCurveSage.modular_symbol()
	for a in range(1, Level):
		if gcd(a, Level) > 1:
			continue
		ListModularSymbolsValues.append(ModularSymbol(a/Level))
	ListModularSymbolsValues.append(ModularSymbol(0))
	ModularSymbolsFile = open('./ModularSymbols/{}/{}'.format(EllipticCurveObject.CremonaName, Level), 'w')
	ModularSymbolsFile.write(str(ListModularSymbolsValues))
	return ListModularSymbolsValues

def MultiprocessingComputatioComputationModularSymbols(Index):
	Numbers = file_names[Index]
	if not os.path.exists('./ToCalculate/{}.txt'.format(Numbers)):
		return None
	filesomething = open('./ToCalculate/{}.txt'.format(Numbers), 'r')
	Done = open('./Done/{}'.format(Numbers), 'w')
	Done.close()
	Done = open('./Done/{}'.format(Numbers), 'w')
	RandomValuesFile = open('./RandomValues/{}'.format(Numbers), 'w')
	RandomValuesFile.close()
	RandomValuesFile = open('./RandomValues/{}'.format(Numbers), 'w')
	for line in filesomething.readlines():
		lines = line.split(';')
		ListModularSymbolsValues = []
		equation = eval(lines[0])
		E = EllipticCurve(equation)
		ModularSymbol = E.modular_symbol()
		Level = eval(lines[1])
		for a in range(1, Level):
			if gcd(a, Level) > 1:
				continue
			ListModularSymbolsValues.append(ModularSymbol(a/Level))
		ListModularSymbolsValues.append(ModularSymbol(0))
		RandomValuesFile.write(str(ListModularSymbolsValues)+';'+line)
		RandomValuesFile.close()
		RandomValuesFile = open('./RandomValues/{}'.format(Numbers), 'a')
		Done.write(line)
		Done.close()
		Done = open('./Done/{}'.format(Numbers), 'a')

def TestConjecture6():
	file = open('./Results.txt', 'w')
	for i in ['00000-09999', '10000-19999', '20000-29999','30000-39999','40000-49999','50000-59999','60000-69999','70000-79999','80000-89999','90000-99999']:
		ModularSymbolsfile = eval(open('./ModularSymbolsReady/{}.txt'.format(i), 'r').readlines()[0])
		print(i)
		for key in ModularSymbolsfile.keys():
			for prime in ModularSymbolsfile[key].keys():
				EllipticCurveSage = EllipticCurve(eval(key))
				jajaj = Integer(prime)
				if not EllipticCurveSage.has_split_multiplicative_reduction(jajaj):
					continue
				listmodularsymbolsstring = ModularSymbolsfile[key][prime]
				denominators = []
				ModularSymbolsraw = listmodularsymbolsstring[1:-1].split(',')
				ModularSymbols = []
				for a in ModularSymbolsraw:
					ModularSymbols.append(Rational(a))
				for a in ModularSymbols:
					denominators.append(a.denominator())
				TateCurve = EllipticCurveSage.tate_curve(jajaj)
				meh = EllipticCurveSage.j_invariant().denominator().valuation(int(prime))
				period = TateCurve.parameter()
				torsion = Integer(period.unit_part().expansion()[0]) 
				CommonDenominatorModularSymbols = lcm(denominators)
				LeftSide = 1
				index = 0
				for a in ModularSymbols[:-1]:
					index += 1
					LeftSide *= index**(CommonDenominatorModularSymbols * a * meh) % jajaj
				RightSide = torsion^(ModularSymbols[-1] * CommonDenominatorModularSymbols)
				if LeftSide % jajaj != RightSide % jajaj and LeftSide % jajaj != - RightSide % jajaj:
					file.write(cremona_to_lmfdb(str(EllipticCurveSage.cremona_label())) + ";" + str(jajaj) + ';' + str(LeftSide % jajaj) + ';' + str(RightSide % jajaj) + ';' + str(EllipticCurveSage.rank()) + ';' +'${}\\cdot{}^{} + O({}^{})$'.format(torsion, jajaj, meh, jajaj, meh + 1) + ';' + str(EllipticCurveSage.modular_degree()) +  '\n')
					print('here')
def TestConjecture5():
	file = open('./Results.txt', 'w')
	for i in ['00000-09999', '10000-19999', '20000-29999','30000-39999','40000-49999','50000-59999','60000-69999','70000-79999','80000-89999','90000-99999']:
		ModularSymbolsfile = eval(open('./ModularSymbolsReady/{}.txt'.format(i), 'r').readlines()[0])
		print(i)
		for key in ModularSymbolsfile.keys():
			for prime in ModularSymbolsfile[key].keys():
				EllipticCurveSage = EllipticCurve(eval(key))
				jajaj = Integer(prime)
				if not EllipticCurveSage.has_split_multiplicative_reduction(jajaj):
					continue
				listmodularsymbolsstring = ModularSymbolsfile[key][prime]
				denominators = []
				ModularSymbolsraw = listmodularsymbolsstring[1:-1].split(',')
				ModularSymbols = []
				for a in ModularSymbolsraw[:-1]:
					ModularSymbols.append(Rational(a))
				for a in ModularSymbols[:-1]:
					denominators.append(a.denominator())
				TateCurve = EllipticCurveSage.tate_curve(jajaj)
				meh = EllipticCurveSage.j_invariant().denominator().valuation(int(prime))
				period = TateCurve.parameter()
				torsion = Integer(period.unit_part().expansion()[0]) 
				CommonDenominatorModularSymbols = lcm(denominators)
				CremonaEllipticCurve = CremonaDatabase().data_from_coefficients(eval(key))
				LeftSide = 1
				index = 0
				if CremonaEllipticCurve['rank'] > 0:
					continue
				for a in ModularSymbols[:-1]:
					index += 1
					LeftSide *= index**(CommonDenominatorModularSymbols * a * meh * CremonaEllipticCurve['torsion_order']) % jajaj
				RightSide = torsion^(2 * CommonDenominatorModularSymbols * CremonaEllipticCurve['db_extra'][0] * Integer(CremonaEllipticCurve['db_extra'][-1]))
				if LeftSide % jajaj != RightSide % jajaj and LeftSide % jajaj != - RightSide % jajaj:
					file.write(cremona_to_lmfdb(str(EllipticCurveSage.cremona_label())) + ";" + str(jajaj) + ';' + str(LeftSide % jajaj) + ';' + str(RightSide % jajaj) + ';' + str(CremonaEllipticCurve['rank']) + ';' +'${}\\cdot{}^{} + O({}^{})$'.format(torsion, jajaj, meh, jajaj, meh + 1) + ';' + str(EllipticCurveSage.modular_degree()) +  '\n')
					print('here')
def TestConjecture5local():
	file = open('./Results.txt', 'w')
	for i in ['00000-09999', '10000-19999', '20000-29999','30000-39999','40000-49999','50000-59999','60000-69999','70000-79999','80000-89999','90000-99999']:
		ModularSymbolsfile = eval(open('./ModularSymbolsReady/{}.txt'.format(i), 'r').readlines()[0])
		print(i)
		for key in ModularSymbolsfile.keys():
			for prime in ModularSymbolsfile[key].keys():
				EllipticCurveSage = EllipticCurve(eval(key))
				jajaj = Integer(prime)
				if not EllipticCurveSage.has_split_multiplicative_reduction(jajaj):
					continue
				listmodularsymbolsstring = ModularSymbolsfile[key][prime]
				denominators = []
				ModularSymbolsraw = listmodularsymbolsstring[1:-1].split(',')
				ModularSymbols = []
				for a in ModularSymbolsraw[:-1]:
					ModularSymbols.append(Rational(a))
				for a in ModularSymbols[:-1]:
					denominators.append(a.denominator())
				TateCurve = EllipticCurveSage.tate_curve(jajaj)
				meh = EllipticCurveSage.j_invariant().denominator().valuation(int(prime))
				period = TateCurve.parameter()
				torsion = Integer(period.unit_part().expansion()[0]) 
				CommonDenominatorModularSymbols = lcm(denominators)
				CremonaEllipticCurve = CremonaDatabase().data_from_coefficients(eval(key))
				LeftSide = 1
				index = 0
				if CremonaEllipticCurve['rank'] > 0:
					continue
				if CremonaEllipticCurve['torsion_order'] > 0:
					continue
				for a in ModularSymbols[:-1]:
					index += 1
					LeftSide *= index**(CommonDenominatorModularSymbols * a * meh * CremonaEllipticCurve['torsion_order']*CremonaEllipticCurve['torsion_order']) % jajaj
				RightSide = torsion^(2 * CommonDenominatorModularSymbols * CremonaEllipticCurve['db_extra'][0] * Integer(CremonaEllipticCurve['db_extra'][-1]))
				if LeftSide % jajaj != RightSide % jajaj and LeftSide % jajaj != - RightSide % jajaj:
					good_primes = jajaj
					for ell in list(factor(good_primes - 1)):
						if ell[0] < 5:
							continue
						if gcd(ell[0], EllipticCurveSage.modular_degree()) > 1:
							continue
						generator = FindGenerator(good_primes)
						Image_Left = MorphismFromUnits2Cyclic(good_primes, generator, LeftSide)
						Image_Right = MorphismFromUnits2Cyclic(good_primes, generator, RightSide)
						if Image_Left % ell[0]**(ell[1]) != Image_Right % ell[0]**(ell[1]) and Image_Left % ell[0]**(ell[1]) != - Image_Right % ell[0]**(ell[1]):
							file.write(str(Integer(CremonaEllipticCurve['db_extra'][-1])) + ";" + str(CremonaEllipticCurve['db_extra'][0]) + ';' + str(LeftSide % good_primes) + ';' + str(RightSide % good_primes) + ';' + str(ell) + ';' +'${}\\cdot{}^{} + O({}^{})$'.format(torsion, good_primes, meh, good_primes, meh + 1) + ';' + str(2) +  '\n')
							print('here')
							quit()


def TestConjecture6Local():
	file = open('./listcounterexamples', 'w')
	for i in ['00000-09999', '10000-19999', '20000-29999','30000-39999','40000-49999','50000-59999','60000-69999','70000-79999','80000-89999','90000-99999']:
		print(i)
		ModularSymbolsfile = eval(open('./ModularSymbolsReady/{}.txt'.format(i), 'r').readlines()[0])
		for key in ModularSymbolsfile.keys():
			for prime in ModularSymbolsfile[key].keys():
				EllipticCurveSage = EllipticCurve(eval(key))
				good_primes = Integer(prime)
				if not EllipticCurveSage.has_split_multiplicative_reduction(good_primes):
					continue
				listmodularsymbolsstring = ModularSymbolsfile[key][prime]
				denominators = []
				ModularSymbolsraw = listmodularsymbolsstring[1:-1].split(',')
				ModularSymbols = []
				for a in ModularSymbolsraw:
					ModularSymbols.append(Rational(a))
				for a in ModularSymbols:
					denominators.append(a.denominator())

				TateCurve = EllipticCurveSage.tate_curve(good_primes)
				meh = EllipticCurveSage.j_invariant().denominator().valuation(int(prime))
				period = TateCurve.parameter()
				torsion = Integer(period.unit_part().expansion()[0])
				CommonDenominatorModularSymbols = lcm(denominators)
				LeftSide = 1
				index = 0
				for a in ModularSymbols[:-1]:
					index += 1
					LeftSide *= index**(CommonDenominatorModularSymbols * a * meh) % good_primes
				RightSide = torsion^(ModularSymbols[-1] * CommonDenominatorModularSymbols)
				if LeftSide % good_primes != RightSide % good_primes and LeftSide % good_primes != - RightSide % good_primes:
					LeftSide = LeftSide % good_primes
					RightSide = RightSide % good_primes
					for ell in list(factor(good_primes - 1)):
						if ell[0] < 5:
							continue
						if gcd(ell[0], EllipticCurveSage.modular_degree()) > 1:
							continue
						generator = FindGenerator(good_primes)
						Image_Left = MorphismFromUnits2Cyclic(good_primes, generator, LeftSide)
						Image_Right = MorphismFromUnits2Cyclic(good_primes, generator, RightSide)
						if Image_Left % ell[0]**(ell[1]) != Image_Right % ell[0]**(ell[1]) and Image_Left % ell[0]**(ell[1]) != - Image_Right % ell[0]**(ell[1]):
							file.write(cremona_to_lmfdb(str(EllipticCurveSage.cremona_label())) + ";" + str(generator) + ';' + str(LeftSide % good_primes) + ';' + str(RightSide % good_primes) + ';' + str(ell) + ';' +'${}\\cdot{}^{} + O({}^{})$'.format(torsion, good_primes, meh, good_primes, meh + 1) + ';' + str(2) +  '\n')
							print('here')
							quit()

def CleanData():
	for nameFile in file_names:
		if not os.path.exists('./ModularSymbolsReady/{}.txt'.format(nameFile)):
			Dictionary = {}
		else:
			Dictionary = eval(open('./ModularSymbolsReady/{}.txt'.format(nameFile), 'r').readlines()[0])
		if not os.path.exists('./RandomValues/{}'.format(nameFile)):
			continue
		ToAdd = open('./RandomValues/{}'.format(nameFile), 'r')
		for line in ToAdd.readlines():
			lines = line[:-1].split(';')
			if lines[1] in Dictionary:
				Dictionary[lines[1]][lines[2]] = lines[0]
			else:
				Dictionary[lines[1]] = {lines[2]:lines[0]}
		ReadyData = open('./ModularSymbolsReady/{}.txt'.format(nameFile), 'w')
		ReadyData.write(str(Dictionary))
		ReadyData.close()

	return None

#184000
if __name__ == '__main__':
	TestConjecture5local()
	quit()
	ListEllipticCurves = []
	for nameFile in file_names:
		ListEllipticCurves = open('./allbsd/allbsd.{}'.format(nameFile), 'r').readlines()
		Output = open('./Trash/{}.txt'.format(nameFile), 'w')
		for lines in ListEllipticCurves:
			splitlines = lines.split(' ')
			for prime in list(factor(eval(splitlines[0]))):
				if prime[1] > 1:
					continue
				Eliiptic = EllipticCurve(eval(splitlines[3]))
				if not Eliiptic.has_split_multiplicative_reduction(prime[0]):
					continue
				Output.write(str(splitlines[3]) + ';' +  str(prime[0]) + '\n')

		Output.close()
	quit()
	for nameFile in file_names:
		if not os.path.exists('./ModularSymbolsReady/{}.txt'.format(nameFile)):
			Dictionary = {}
		else:
			Dictionary =  eval(open('./ModularSymbolsReady/{}.txt'.format(nameFile), 'r').readlines()[0])
		NewValues = []
		TempFileTrash = open('./Trash/{}.txt'.format(nameFile), 'r')
		for line in TempFileTrash.readlines():
			lines = line[:-1].split(';')
			if not lines[0] in Dictionary.keys():
				NewValues.append(line)
			elif not lines[1] in Dictionary[lines[0]]:
				NewValues.append(line)
		if len(NewValues) > 0:
			TempFile = open('./ToCalculate/{}.txt'.format(nameFile), 'w')
			for NewValue in NewValues:
				TempFile.write(NewValue)
			TempFile.close()
	tiempo = time.time()
	Number = range(len(file_names))
	p = Pool(processes=7)
	resuls = p.map(MultiprocessingComputatioComputationModularSymbols, Number)
	p.close()
	p.join()
	print(int(time.time() - tiempo))
