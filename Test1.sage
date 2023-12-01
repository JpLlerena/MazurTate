# El label de acuerdo a Lmfdb de la curva elíptica va en la siguiente linea y el primo de multiplicación split en la siguiente. El Label de la cuva elíptica tiene que ir entre comillas i.e para el Label 11.a3 se tiene que colocar como '11.a3'
Label = '11.a1'
Primo = 11
# Las siguientes lineas se encargar de crear la curva elíptica, definir la curva de tate correspondiente (para cálcular el uniformizante) y finalmente obtener el order de este uniformizante usando el hecho de que ord_p(q_E) = -ord_p(j_E).

E = EllipticCurve(Label)
TE = E.tate_curve(Primo)
q_e = TE.parameter()
ordq_E = E.j_invariant().denominator().valuation(Primo)

# La siguiente líneam un poco confuza, se encarga de obtener el coeficiente líder de q_E

q_l = Integer(q_e.unit_part().expansion()[0])

#Ahora se hace la diferencia entre probar la conjetura 5 o la conjetura 6. Primero va a estar el código para la conjetura 6.

# Las siguientes líneas se encargan de cálcular los símbolos modulares y de encontrar el mcm entre los denominadores
M = E.modular_symbol()

LMS = []
LMSD = []
for a in range(Primo):
    V = M(a/Primo)
    LMSD.append(V.denominator())
    LMS.append(V)
D = lcm(LMSD)

# La siguiente línea se encarga de verificar si la curva elíptica satisface o no la conjetura 6
# Lado derecho

R = q_l^(LMS[0] * D)

# Lado izquierdo

L = 1
a = 1
for b in LMS[1:]:
    L = L*a^(D * b * ordq_E)
    a = a+1

# Ahora se comparan si los dos lados son igulaes salvo signo modulo p

if L%Primo != R%Primo and L%Primo != -R%Primo:
    print('No satisface la conjetura')
else:
    print('Si satisface la conjetura')

##########################################################################################################################
# Si se quiere probar solo la conjetura 6 entonces no es necesario copiar las cosas que vienen ahora. Son independientes #
##########################################################################################################################
#Ahora el código para la conjetura 5.

# Las siguientes líneas se encargan de cálcular los símbolos modulares y de encontrar el mcm entre los denominadores
# DIFERENCIA: Cuando se crea la lista de simbolos modulares no se calcula para el simbolo modular \lambda(0,1)
M = E.modular_symbol()

LMS = []
LMSD = []
for a in range(1, Primo):
    V = M(a/Primo)
    LMSD.append(V.denominator())
    LMS.append(V)
D = lcm(LMSD)

# La siguiente línea se encarga de verificar si la curva elíptica satisface o no la conjetura 5
# Variables originales

tau = E.torsion_order()
Sha = E.sha().an() 
#OJO: aca se esta útilizando la implementación de sha analítico de SageMath, hay que tener cuidado ya que asume BSD y aproximaciones, para conductor bajo no hay problema, pero para conductor muy algo se pierde confinza. Mirar: https://www.lmfdb.org/EllipticCurve/Q/Reliability
# Lado derecho
C_E = E.tamagawa_product()
R = q_l^(C_E * Sha * 2 * D)

# Lado izquierdo

L = 1
a = 1
for b in LMS:
    L = L*a^(D * b * ordq_E * tau * tau)
    a = a+1

# Ahora se comparan si los dos lados son igulaes salvo signo modulo p

if L%Primo != R%Primo and L%Primo != -R%Primo:
    print('No satisface la conjetura')
else:
    print('Si satisface la conjetura')
