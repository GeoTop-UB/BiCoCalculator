_I='The bigraded complex has unspecified names'
_H=' + '
_G='\n'
_F='[{}]'
_E=' '
_D='The bigraded complex does not have bidegree '
_C=False
_B=None
_A=True
from sage.geometry.hyperplane_arrangement.affine_subspace import AffineSubspace
class PuncturedAffineSpace:
	def __init__(A,ambient_space,outer_subspace,inner_subspaces):
		D=outer_subspace;C=ambient_space;A.__ambient_space=C;A.__ambient_dimension=C.rank();A.__outer_subspace=D;A.__inner_subspaces=[];A.__inner_points=[];A.__base=C.base();A.__is_empty=_C
		try:A.__outer_point=D.point()
		except:A.__outer_point=_B;A.__is_empty=_A
		if A.__is_empty==_C:
			for E in inner_subspaces:
				B=E.intersection(A.__outer_subspace)
				try:
					F=B.point()
					if B not in A.__inner_subspaces:A.__inner_subspaces.append(B);A.__inner_points.append(F)
					if B==A.__outer_subspace:A.__is_empty=_A
				except:pass
	@staticmethod
	def unpunctured(ambient_space,outer_subspace):return PuncturedAffineSpace(ambient_space,outer_subspace,[])
	@staticmethod
	def unpunctured_from_vector_space(ambient_space,outer_subspace):A=ambient_space;return PuncturedAffineSpace.unpunctured(A,AffineSubspace(vector([0]*A.rank()),outer_subspace))
	@staticmethod
	def empty(ambient_space):return PuncturedAffineSpace.unpunctured(ambient_space,_B)
	@staticmethod
	def total(ambient_space):A=ambient_space;return PuncturedAffineSpace.unpunctured_from_vector_space(A,A)
	@staticmethod
	def zero(base,dimension):A=VectorSpace(base,dimension);B=AffineSubspace(A.zero(),A.subspace([]));return PuncturedAffineSpace.unpunctured_from_vector_space(A,B)
	@staticmethod
	def kernel(matrix):A=matrix;return PuncturedAffineSpace.unpunctured_from_vector_space(VectorSpace(A.base(),A.ncols()),A.right_kernel())
	def ambient_space(A):return A.__ambient_space
	def outer_subspace(A):return A.__outer_subspace
	def inner_subspaces(A):return A.__inner_subspaces
	def base(A):return A.__base
	def is_empty(A):return A.__is_empty
	def intersection(A,other):
		B=other
		if A.is_empty()or B.is_empty():return PuncturedAffineSpace.empty(A.ambient_space())
		else:C=A.outer_subspace().intersection(B.outer_subspace());return PuncturedAffineSpace(A.ambient_space(),C,A.inner_subspaces()+B.inner_subspaces())
	def remove_subspace(A,remove):return PuncturedAffineSpace(A.ambient_space(),A.outer_subspace(),A.inner_subspaces()+[remove])
	def preimage(B,matrix):
		A=matrix;C=VectorSpace(B.base(),A.ncols());G=PuncturedAffineSpace.unpunctured_from_vector_space(B.ambient_space(),VectorSpace(B.base(),B.__ambient_dimension).subspace(A.columns()));D=B.intersection(G)
		if B.is_empty():return PuncturedAffineSpace.empty(C)
		else:
			try:
				H=A.solve_right(D.get_point());I=AffineSubspace(H,A.right_kernel()+C.subspace([A.solve_right(B)for B in D.outer_subspace().linear_part().basis()]));E=[]
				for F in D.inner_subspaces():
					try:J=A.solve_right(B.__inner_points[D.inner_subspaces().index(F)]);E.append(AffineSubspace(J,A.right_kernel()+C.subspace([A.solve_right(B)for B in F.linear_part().basis()])))
					except:pass
				return PuncturedAffineSpace(C,I,E)
			except:return PuncturedAffineSpace.empty(C)
	def image(A,matrix):
		B=matrix;C=VectorSpace(A.base(),B.nrows())
		if A.is_empty():return PuncturedAffineSpace.empty(C)
		else:
			try:
				F=B*A.__outer_point;G=AffineSubspace(F,C.subspace([B*A for A in A.outer_subspace().linear_part().basis()]));D=[]
				for E in A.inner_subspaces():H=B*A.__inner_points[A.inner_subspaces().index(E)];D.append(AffineSubspace(H,C.subspace([B*A for A in E.linear_part().basis()])))
				return PuncturedAffineSpace(C,G,D)
			except:return PuncturedAffineSpace.empty(C)
	def get_point(A):
		if A.is_empty():return
		elif A.outer_subspace().dimension()==0:return A.__outer_point
		elif A.ambient_space().rank()!=A.outer_subspace().linear_part().rank():
			L=Matrix(A.base(),[A for A in A.outer_subspace().linear_part().basis()]).transpose();G=A.outer_subspace().linear_part().rank();I=VectorSpace(A.base(),G);M=AffineSubspace(vector([0]*G),VectorSpace(A.base(),G));E=[]
			for C in A.inner_subspaces():N=I.subspace([A.outer_subspace().linear_part().coordinates(B)for B in C.linear_part().basis()]);E.append(AffineSubspace(A.outer_subspace().linear_part().coordinates(C.point()-A.__outer_point),N))
			D=PuncturedAffineSpace(I,M,E).get_point()
			if D==_B:return
			else:return L*D+A.__outer_point
		else:
			O=len(A.inner_subspaces());B=A.ambient_space().rank()
			if B>=2:
				P=[vector([int(A==B)for B in range(B)])for A in range(B-2)]
				for Q in range(O+1):
					J=vector([int(A==B-2)for A in range(B)]);J[B-1]=Q;H=AffineSubspace(vector([0]*B),VectorSpace(A.base(),B).subspace(P+[J]));F=_A
					for C in A.inner_subspaces():
						if C==H:F=_C;break
					if F==_A:
						E=[]
						for C in A.inner_subspaces():
							try:K=H.intersection(C);S=K.point();E.append(K)
							except:pass
						D=PuncturedAffineSpace(A.ambient_space(),H,E).get_point();return D
			elif B==1:
				for C in A.inner_subspaces():
					D=C.point()+vector([1]);F=_A
					for R in A.inner_subspaces():
						if D in R:F=_C
					if F==_A:return D
				return A.ambient_space().zero()
class BigradedComplex:
	def __init__(A,base,dell,delbar,names=_B,latex_names=_B,CHECK=_A):
		I='The differentials dell and delbar are not well defined';A.__base=base;A.__dimension={};A.__bidegrees=[];A.__dell=dell;A.__delbar=delbar;A.__delldelbar={};A.__names=names;A.__latex_names=latex_names;A.__CHECK=CHECK;A.__dell_cocycles={};A.__dell_coboundaries={};A.__delbar_cocycles={};A.__delbar_coboundaries={};A.__delldelbar_cocycles={};A.__delldelbar_coboundaries={};A.__dell_and_delbar_cocycles={};A.__dell_and_delbar_coboundaries={};A.__dell_cohomology={};A.__delbar_cohomology={};A.__aeppli_cohomology={};A.__bottchern_cohomology={};A.__reduced_bottchern_cohomology={};A.__reduced_aeppli_cohomology={};A.__squares_basis={};A.__zigzags_decomposition=_B
		for(B,C)in A.__dell:
			if(B,C)not in A.__dimension:A.__dimension[B,C]=A.__dell[B,C].ncols()
		for(B,C)in A.__delbar:
			if(B,C)not in A.__dimension:A.__dimension[B,C]=A.__delbar[B,C].ncols()
		for(B,C)in A.__dimension:
			if(B,C)not in A.__dell:
				if(B+1,C)not in A.__dimension:A.__dell[B,C]=Matrix(A.base(),0,A.__dimension[B,C])
				else:A.__dell[B,C]=Matrix(A.base(),A.__dimension[B+1,C],A.__dimension[B,C])
			if(B,C)not in A.__delbar:
				if(B,C+1)not in A.__dimension:A.__delbar[B,C]=Matrix(A.base(),0,A.__dimension[B,C])
				else:A.__delbar[B,C]=Matrix(A.base(),A.__dimension[B,C+1],A.__dimension[B,C])
		if A.__CHECK:
			for(B,C)in A.bidegrees():
				if(B+1,C)in A.bidegrees()and(B+2,C)in A.bidegrees():
					if A.dell((B+1,C))*A.dell((B,C))!=0:return BaseException('The dell differential does not square to zero')
				if(B,C+1)in A.bidegrees()and(B,C+2)in A.bidegrees():
					if A.delbar((B,C+1))*A.delbar((B,C))!=0:return BaseException('The delbar differential does not square to zero')
				if(B,C+1)in A.bidegrees()and(B+1,C)in A.bidegrees()and(B+1,C+1)in A.bidegrees():
					if A.delbar((B+1,C))*A.dell((B,C))+A.dell((B,C+1))*A.delbar((B,C))!=0:return BaseException('The differentials dell and delbar do not anticommute')
				if A.dell((B,C)).ncols()!=A.delbar((B,C)).ncols():return BaseException(I)
				if(B-1,C)in A.bidegrees()and A.dell((B-1,C)).nrows()!=A.dell((B,C)).ncols():return BaseException(I)
				if(B,C-1)in A.bidegrees()and A.delbar((B,C-1)).nrows()!=A.dell((B,C)).ncols():return BaseException(I)
		D=_B;E=_B;F=_B;G=_B
		for(B,C)in A.bidegrees():
			if D==_B:D=B;E=B;F=C;G=C
			else:
				if B<D:D=B
				if B>E:E=B
				if C<F:F=C
				if C>G:G=C
		A.__min_p=D;A.__max_p=E;A.__min_q=F;A.__max_q=G
		for(B,C)in A.__dimension:
			if(B-1,C-1)not in A.__dimension:A.__delldelbar[B-1,C-1]=Matrix(A.__base,0,A.__dimension[B,C])
			if(B+1,C+1)not in A.__dimension:A.__delldelbar[B,C]=Matrix(A.__base,0,A.__dimension[B,C])
			elif(B,C+1)not in A.__dimension:A.__delldelbar[B,C]=Matrix(A.__base,A.__dimension[B+1,C+1],A.__dimension[B,C])
			elif(B,C)in A.__delbar and(B,C+1)in A.__dell and A.__delbar[B,C]!=Matrix(A.base(),[])and A.__dell[B,C+1]!=Matrix(A.base(),[]):A.__delldelbar[B,C]=A.__dell[B,C+1]*A.__delbar[B,C]
			else:A.__delldelbar[B,C]=Matrix(A.base(),A.__dimension[B+1,C+1],A.__dimension[B,C])
		A.__total_degrees=[];A.__ordered_bidegrees={}
		for(B,C)in A.bidegrees():
			if B+C not in A.__total_degrees:A.__total_degrees.append(B+C);A.__ordered_bidegrees[B+C]=[B]
			else:A.__ordered_bidegrees[B+C].append(B)
		A.__total_degrees=sorted(A.__total_degrees)
		for H in A.__total_degrees:A.__ordered_bidegrees[H]=[(A,H-A)for A in sorted(A.__ordered_bidegrees[H])]
	def base(A):return A.__base
	def dimension(A,bidegree=_B):
		B=bidegree
		if B==_B:return A.__dimension
		elif B not in A.bidegrees():return 0
		else:return A.__dimension[B]
	def dell(B,bidegree=_B):
		A=bidegree
		if A==_B:return B.__dell
		elif A not in B.bidegrees():raise ValueError(_D+str(A))
		else:return B.__dell[A]
	def delbar(B,bidegree=_B):
		A=bidegree
		if A==_B:return B.__delbar
		elif A not in B.bidegrees():raise ValueError(_D+str(A))
		else:return B.__delbar[A]
	def delldelbar(B,bidegree=_B):
		A=bidegree
		if A==_B:return B.__delldelbar
		elif A not in B.bidegrees():raise ValueError(_D+str(A))
		else:return B.__delldelbar[A]
	def names(B,bidegree=_B):
		A=bidegree
		if A==_B:return B.__names
		elif A not in B.bidegrees():raise ValueError(_D+str(A))
		else:return B.__names[A]
	def bidegrees(A):return list(A.__dimension.keys())
	def zigzags_dimension(B,bidegree=_B):
		A=bidegree
		if A==_B:
			C={}
			for A in B.bidegrees():C[A]=B.zigzags_dimension(bidegree=A)
			return C
		else:return len(B.zigzags_basis(A))
	def bigraded_component(A,bidegree):
		B=bidegree
		if A.names()==_B:raise AttributeError(_I)
		elif B not in A.bidegrees():raise ValueError(_D+str(B))
		else:return VectorSpace(A.base(),A.names(B))
	def element(D,bidegree,coordinates):
		H=' - ';G='*';E=coordinates;C=bidegree
		if D.names()==_B:raise AttributeError(_I)
		elif C not in D.bidegrees():raise ValueError(_D+str(C))
		elif len(E)!=D.dimension(C):raise TypeError('The length of the provided coordinates does not coincide with the dimension of the bigraded component at bidegree '+str(C))
		else:
			F=_A;B=''
			for A in range(len(E)):
				if E[A]==1:
					if F:B=str(D.names(C)[A]);F=_C
					else:B=B+_H+str(D.names(C)[A])
				elif E[A]==-1:
					if F:B='-'+str(D.names(C)[A]);F=_C
					else:B=B+H+str(D.names(C)[A])
				elif E[A]<0:
					if F:B=str(E[A])+G+str(D.names(C)[A]);F=_C
					else:B=B+H+str(-E[A])+G+str(D.names(C)[A])
				elif E[A]>0:
					if F:B=str(E[A])+G+str(D.names(C)[A]);F=_C
					else:B=B+_H+str(E[A])+G+str(D.names(C)[A])
			if B=='':B='0'
			return B
	def subcomplex(D,subspace):
		A=subspace;B=[]
		for C in A:
			if A[C]!=[]:B.append(C)
		return BigradedSubcomplex({B:A[B]for B in B},D,CHECK=_C)
	def subcomplex_bidegrees(A,bidegrees):return BigradedSubcomplex({B:[vector([int(C==A)for A in range(A.dimension(B))])for C in range(A.dimension(B))]for B in bidegrees},A,CHECK=_C)
	def total_degrees(A):return A.__total_degrees
	def ordered_bidegrees(A,total_degree=_B):
		B=total_degree
		if B==_B:return A.__ordered_bidegrees
		else:return A.__ordered_bidegrees[B]
	def attach_element(A,bidegree,dell,delbar,name=_B):
		M=bidegree;L='The element can not be attached: dell and delbar would not anticommute.';K=name;G=delbar;F=dell;F=vector(F);G=vector(G);B,C=M
		if(B+1,C)in A.bidegrees()and A.dell((B+1,C))*F!=0:raise BaseException('The element can not be attached: dell would not square to zero.')
		elif(B,C+1)in A.bidegrees()and A.delbar((B,C+1))*G!=0:raise BaseException('The element can not be attached: delbar would not square to zero.')
		if(B+1,C)in A.bidegrees()and(B,C+1)in A.bidegrees():
			if A.delbar((B+1,C))*F+A.dell((B,C+1))*G!=0:raise BaseException(L)
		elif(B+1,C)in A.bidegrees():
			if A.delbar((B+1,C))*F!=0:raise BaseException(L)
		elif(B,C+1)in A.bidegrees():
			if A.dell((B,C+1))*G!=0:raise BaseException(L)
		H={B:A.dell(B)for B in A.bidegrees()};I={B:A.delbar(B)for B in A.bidegrees()}
		if M not in A.bidegrees():
			if(B+1,C)in A.bidegrees():H[B,C]=Matrix(A.base(),[F]).transpose()
			else:H[B,C]=Matrix(A.base(),0,1)
			if(B,C+1)in A.bidegrees():I[B,C]=Matrix(A.base(),[G]).transpose()
			else:I[B,C]=Matrix(A.base(),0,1)
		else:
			if(B+1,C)not in A.bidegrees():H[B,C]=Matrix(A.base(),0,A.dimension((B,C))+1)
			else:
				D=H[B,C].rows()
				for E in range(len(F)):D[E]=list(D[E])+[F[E]]
				H[B,C]=Matrix(A.base(),D)
			if(B,C+1)not in A.bidegrees():I[B,C]=Matrix(A.base(),0,A.dimension((B,C))+1)
			else:
				D=I[B,C].rows()
				for E in range(len(G)):D[E]=list(D[E])+[G[E]]
				I[B,C]=Matrix(A.base(),D)
		if(B-1,C)in A.bidegrees():
			D=H[B-1,C].columns()
			if D==[]:D=[[0]]
			else:
				for E in range(len(D)):D[E]=list(D[E])+[0]
			H[B-1,C]=Matrix(A.base(),D).transpose()
		if(B,C-1)in A.bidegrees():
			D=I[B,C-1].columns()
			if D==[]:D=[[0]]
			else:
				for E in range(len(D)):D[E]=list(D[E])+[0]
			I[B,C-1]=Matrix(A.base(),D).transpose()
		if A.names()!=_B and K!=_B:
			J=A.names()
			if(B,C)in A.bidegrees():J[B,C].append(K)
			else:J[B,C]=[K]
		else:J=_B
		return BigradedComplex(A.base(),H,I,names=J)
	def attach_random_element(A,min_degree=_B,max_degree=_B,min_coefficient=-5,max_coefficient=5,name=_B):
		K=min_coefficient;I=name;F=max_degree;E=min_degree
		def D(V):
			A=V.zero()
			for B in V.basis():C=int(random()*(max_coefficient-K))+K;A+=C*B
			return A
		if E==_B or F==_B:
			J=_C
			while J==_C:
				B,C=A.bidegrees()[int(random()*len(A.bidegrees()))]
				if E!=_B and(B<E or C<E):J=_C
				elif F!=_B and(B>F or C>F):J=_C
				else:J=_A
		else:B=int(random()*(F-E))+E;C=int(random()*(F-E))+E
		if(B+1,C)in A.bidegrees()and(B,C+1)in A.bidegrees()and(B+1,C+1)in A.bidegrees():O=VectorSpace(A.base(),A.dimension((B+1,C+1))).subspace([A.dell((B,C+1))*D for D in A.delbar_cocycles_raw((B,C+1)).basis()]);P=VectorSpace(A.base(),A.dimension((B+1,C+1))).subspace([A.delbar((B+1,C))*D for D in A.dell_cocycles_raw((B+1,C)).basis()]);Q=O.intersection(P);L=D(Q);R=A.delbar((B+1,C)).solve_right(L);S=A.dell((B,C+1)).solve_right(-L);M=AffineSubspace(R,A.delbar_cocycles_raw((B+1,C))).intersection(AffineSubspace(vector([0]*A.dimension((B+1,C))),A.dell_cocycles_raw((B+1,C))));N=AffineSubspace(S,A.dell_cocycles_raw((B,C+1))).intersection(AffineSubspace(vector([0]*A.dimension((B,C+1))),A.delbar_cocycles_raw((B,C+1))));G=M.point()+D(M.linear_part());H=N.point()+D(N.linear_part());return A.attach_element((B,C),G,H,name=I)
		elif(B+1,C)in A.bidegrees()and(B,C+1)in A.bidegrees():G=D(A.dell_cocycles_raw((B+1,C)));H=D(A.delbar_cocycles_raw((B,C+1)));return A.attach_element((B,C),G,H,name=I)
		elif(B+1,C)in A.bidegrees():
			if(B+1,C+1)not in A.bidegrees():G=D(A.dell_cocycles_raw((B+1,C)))
			else:G=D(A.dell_cocycles_raw((B+1,C)).intersection(A.delbar_cocycles_raw((B+1,C))))
			return A.attach_element((B,C),G,vector([]),name=I)
		elif(B,C+1)in A.bidegrees():
			if(B+1,C+1)not in A.bidegrees():H=D(A.delbar_cocycles_raw((B,C+1)))
			else:H=D(A.dell_cocycles_raw((B,C+1)).intersection(A.delbar_cocycles_raw((B,C+1))))
			return A.attach_element((B,C),vector([]),H,name=I)
		else:return A.attach_element((B,C),vector([]),vector([]),name=I)
	@staticmethod
	def zero(base):return BigradedComplex(base,{},{})
	@staticmethod
	def random(base,min_degree=0,max_degree=3,min_coefficient=-5,max_coefficient=5,n_generators=60,names=_B):
		C=n_generators;A=names
		if A==_B:A=['x'+str(A+1)for A in range(C)]
		B=[BigradedComplex.zero(base)]
		for D in range(C):B.append(B[-1].attach_random_element(min_degree=min_degree,max_degree=max_degree,min_coefficient=min_coefficient,max_coefficient=max_coefficient,name=A[D]))
		return B[-1]
	def dell_cocycles(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__dell_cocycles:A.__dell_cocycles[B]=A.dell(B).right_kernel();return A.__dell_cocycles[B]
			else:return A.__dell_cocycles[B]
		else:return VectorSpace(A.base(),[A.element(B,C)for C in A.dell_cocycles(B,raw=_A).basis()])
	def dell_cocycles_raw(A,bidegree):return A.dell_cocycles(bidegree,raw=_A)
	def dell_cocycles_inclusion(A,bidegree):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		else:
			C=A.dell_cocycles(B,raw=_A).basis();D=len(C);E=Matrix(A.base(),A.dimension(B),D)
			for F in range(D):
				for G in range(A.dimension(B)):E[G,F]=C[F][G]
			return E
	def dell_cocycles_projection(A,bidegree):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		else:
			E=A.dell_cocycles(B,raw=_A);D=list(E.gens());F=len(D)
			for C in range(A.dimension(B)):
				G=vector([int(C==A)for A in range(A.dimension(B))])
				if G not in E:D+=[G]
			I=Matrix(A.base(),A.dimension(B),D);H=Matrix(A.base(),F,A.dimension(B))
			for C in range(F):H[C,C]=1
			return H*I
	def dell_coboundaries(A,bidegree,raw=_C):
		B=bidegree;C,D=B
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__dell_coboundaries:
				if(C-1,D)not in A.bidegrees():A.__dell_coboundaries[B]=VectorSpace(A.base(),A.dimension(B)).subspace([0])
				else:A.__dell_coboundaries[B]=VectorSpace(A.base(),A.dimension(B)).subspace(A.dell((C-1,D)).transpose())
			return A.__dell_coboundaries[B]
		else:return VectorSpace(A.base(),[A.element(B,C)for C in A.dell_coboundaries(B,raw=_A).basis()])
	def dell_coboundaries_raw(A,bidegree):return A.dell_coboundaries(bidegree,raw=_A)
	def delbar_cocycles(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__delbar_cocycles:A.__delbar_cocycles[B]=A.delbar(B).right_kernel();return A.__delbar_cocycles[B]
			else:return A.__delbar_cocycles[B]
		else:return VectorSpace(A.base(),[A.element(B,C)for C in A.delbar_cocycles(B,raw=_A).basis()])
	def delbar_cocycles_raw(A,bidegree):return A.delbar_cocycles(bidegree,raw=_A)
	def delbar_cocycles_inclusion(A,bidegree):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		else:
			C=A.delbar_cocycles(B,raw=_A).basis();D=len(C);E=Matrix(A.base(),A.dimension(B),D)
			for F in range(D):
				for G in range(A.dimension(B)):E[G,F]=C[F][G]
			return E
	def delbar_cocycles_projection(A,bidegree):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		else:
			E=A.delbar_cocycles(B,raw=_A);D=list(E.gens());F=len(D)
			for C in range(A.dimension(B)):
				G=vector([int(C==A)for A in range(A.dimension(B))])
				if G not in E:D+=[G]
			I=Matrix(A.base(),A.dimension(B),D);H=Matrix(A.base(),F,A.dimension(B))
			for C in range(F):H[C,C]=1
			return H*I
	def delbar_coboundaries(A,bidegree,raw=_C):
		B=bidegree;C,D=B
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__delbar_coboundaries:
				if(C,D-1)not in A.bidegrees():A.__delbar_coboundaries[B]=VectorSpace(A.base(),A.dimension(B)).subspace([0])
				else:A.__delbar_coboundaries[B]=VectorSpace(A.base(),A.dimension(B)).subspace(A.delbar((C,D-1)).transpose())
			return A.__delbar_coboundaries[B]
		else:return VectorSpace(A.base(),[A.element(B,C)for C in A.delbar_coboundaries(B,raw=_A).basis()])
	def delbar_coboundaries_raw(A,bidegree):return A.delbar_coboundaries(bidegree,raw=_A)
	def delldelbar_cocycles(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__delldelbar_cocycles:A.__delldelbar_cocycles[B]=A.delldelbar(B).right_kernel();return A.__delldelbar_cocycles[B]
			else:return A.__delldelbar_cocycles[B]
		else:return VectorSpace(A.base(),[A.element(B,C)for C in A.delldelbar_cocycles(B,raw=_A).basis()])
	def delldelbar_cocycles_raw(A,bidegree):return A.delldelbar_cocycles(bidegree,raw=_A)
	def delldelbar_cocycles_inclusion(A,bidegree):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		else:
			C=A.delldelbar_cocycles(B,raw=_A).basis();D=len(C);E=Matrix(A.base(),A.dimension(B),D)
			for F in range(D):
				for G in range(A.dimension(B)):E[G,F]=C[F][G]
			return E
	def delldelbar_cocycles_projection(A,bidegree):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		else:
			E=A.delldelbar_cocycles(B,raw=_A);D=list(E.gens());F=len(D)
			for C in range(A.dimension(B)):
				G=vector([int(C==A)for A in range(A.dimension(B))])
				if G not in E:D+=[G]
			H=Matrix(A.base(),A.dimension(B),D);I=Matrix(A.base(),F,A.dimension(B))
			for C in range(F):I[C,C]=1
			return proje35ction*H
	def delldelbar_coboundaries(A,bidegree,raw=_C):
		B=bidegree;C,D=B
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__delldelbar_coboundaries:
				if(C-1,D-1)not in A.bidegrees():A.__delldelbar_coboundaries[B]=VectorSpace(A.base(),A.dimension(B)).subspace([0])
				else:A.__delldelbar_coboundaries[B]=VectorSpace(A.base(),A.dimension(B)).subspace(A.delldelbar((C-1,D-1)).transpose(),A.base())
			return A.__delldelbar_coboundaries[B]
		else:return VectorSpace(A.base(),[A.element(B,C)for C in A.delldelbar_coboundaries(B,raw=_A).basis()])
	def delldelbar_coboundaries_raw(A,bidegree):return A.delldelbar_coboundaries(bidegree,raw=_A)
	def dell_and_delbar_cocycles(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__dell_and_delbar_cocycles:A.__dell_and_delbar_cocycles[B]=A.dell_cocycles(B,raw=_A).intersection(A.delbar_cocycles(B,raw=_A));return A.__dell_and_delbar_cocycles[B]
			else:return A.__dell_and_delbar_cocycles[B]
		else:return VectorSpace(A.base(),[A.element(B,C)for C in A.dell_and_delbar_cocycles(B,raw=_A).basis()])
	def dell_and_delbar_cocycles_raw(A,bidegree):return A.dell_and_delbar_cocycles(bidegree,raw=_A)
	def dell_and_delbar_cocycles_inclusion(A,bidegree):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		else:
			C=A.dell_and_delbar_cocycles(B,raw=_A).basis();D=len(C);E=Matrix(A.base(),A.dimension(B),D)
			for F in range(D):
				for G in range(A.dimension(B)):E[G,F]=C[F][G]
			return E
	def dell_and_delbar_cocycles_projection(A,bidegree):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		else:
			E=A.dell_and_delbar_cocycles(B,raw=_A);D=list(E.gens());F=len(D)
			for C in range(A.dimension(B)):
				G=vector([int(C==A)for A in range(A.dimension(B))])
				if G not in E:D+=[G]
			I=Matrix(A.base(),A.dimension(B),D);H=Matrix(A.base(),F,A.dimension(B))
			for C in range(F):H[C,C]=1
			return H*I
	def dell_cohomology_basis(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:return A.dell_cohomology(B,raw=_A).basis()
		else:C=A.dell_cohomology(B,raw=_A);D=[C.lift(A)for A in C.basis()];return[_F.format(A.element(B,C))for C in D]
	def dell_cohomology(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__dell_cohomology:A.__dell_cohomology[B]=A.dell_cocycles(B,raw=_A)/A.dell_coboundaries(B,raw=_A)
			return A.__dell_cohomology[B]
		else:return VectorSpace(A.base(),A.dell_cohomology_basis(B))
	def dell_cohomology_raw(A,bidegree):return A.dell_cohomology(bidegree,raw=_A)
	def delbar_cohomology_basis(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:return A.delbar_cohomology(B,raw=_A).basis()
		else:C=A.delbar_cohomology(B,raw=_A);D=[C.lift(A)for A in C.basis()];return[_F.format(A.element(B,C))for C in D]
	def delbar_cohomology(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__delbar_cohomology:A.__delbar_cohomology[B]=A.delbar_cocycles(B,raw=_A)/A.delbar_coboundaries(B,raw=_A)
			return A.__delbar_cohomology[B]
		else:return VectorSpace(A.base(),A.delbar_cohomology_basis(B))
	def delbar_cohomology_raw(A,bidegree):return A.delbar_cohomology(bidegree,raw=_A)
	def bottchern_cohomology_basis(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:return A.bottchern_cohomology(B,raw=_A).basis()
		else:C=A.bottchern_cohomology(B,raw=_A);D=[C.lift(A)for A in C.basis()];return[_F.format(A.element(B,C))for C in D]
	def bottchern_cohomology(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__bottchern_cohomology:A.__bottchern_cohomology[B]=A.dell_cocycles(B,raw=_A).intersection(A.delbar_cocycles(B,raw=_A))/A.delldelbar_coboundaries(B,raw=_A)
			return A.__bottchern_cohomology[B]
		else:return VectorSpace(A.base(),A.bottchern_cohomology_basis(B))
	def bottchern_cohomology_raw(A,bidegree):return A.bottchern_cohomology(bidegree,raw=_A)
	def aeppli_cohomology_basis(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:return A.aeppli_cohomology(B,raw=_A).basis()
		else:C=A.aeppli_cohomology(B,raw=_A);D=[C.lift(A)for A in C.basis()];return[_F.format(A.element(B,C))for C in D]
	def aeppli_cohomology(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__aeppli_cohomology:A.__aeppli_cohomology[B]=A.delldelbar_cocycles(B,raw=_A)/(A.dell_coboundaries(B,raw=_A)+A.delbar_coboundaries(B,raw=_A))
			return A.__aeppli_cohomology[B]
		else:return VectorSpace(A.base(),A.aeppli_cohomology_basis(B))
	def aeppli_cohomology_raw(A,bidegree):return A.aeppli_cohomology(bidegree,raw=_A)
	def reduced_bottchern_cohomology_basis(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:return A.reduced_bottchern_cohomology(B,raw=_A).basis()
		else:C=A.reduced_bottchern_cohomology(B,raw=_A);D=[C.lift(A)for A in C.basis()];return[_F.format(A.element(B,C))for C in D]
	def reduced_bottchern_cohomology(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__reduced_bottchern_cohomology:A.__reduced_bottchern_cohomology[B]=(A.dell_coboundaries_raw(B).intersection(A.delbar_cocycles_raw(B))+A.delbar_coboundaries_raw(B).intersection(A.dell_cocycles_raw(B)))/A.delldelbar_coboundaries_raw(B)
			return A.__reduced_bottchern_cohomology[B]
		else:return VectorSpace(A.base(),A.reduced_bottchern_cohomology_basis(B))
	def reduced_bottchern_cohomology_raw(A,bidegree):return A.reduced_bottchern_cohomology(bidegree,raw=_A)
	def reduced_aeppli_cohomology_basis(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:return A.reduced_aeppli_cohomology(B,raw=_A).basis()
		else:C=A.reduced_aeppli_cohomology(B,raw=_A);D=[C.lift(A)for A in C.basis()];return[_F.format(A.element(B,C))for C in D]
	def reduced_aeppli_cohomology(A,bidegree,raw=_C):
		B=bidegree
		if B not in A.bidegrees():raise ValueError(_D+str(B))
		elif raw==_A or A.names()==_B:
			if B not in A.__reduced_aeppli_cohomology:A.__reduced_aeppli_cohomology[B]=A.delldelbar_cocycles(B,raw=_A)/(A.dell_coboundaries(B,raw=_A)+A.delbar_coboundaries(B,raw=_A)+A.dell_cocycles(B,raw=_A).intersection(A.delbar_cocycles(B,raw=_A)))
			return A.__reduced_aeppli_cohomology[B]
		else:return VectorSpace(A.base(),A.reduced_aeppli_cohomology_basis(B))
	def reduced_aeppli_cohomology_raw(A,bidegree):return A.reduced_aeppli_cohomology(bidegree,raw=_A)
	def __find_zigzag(C,already_computed={}):
		S=already_computed;J={}
		for M in C.bidegrees():
			if M in S:J[M]=AffineSubspace(vector([0]*C.dimension(M)),VectorSpace(C.base(),C.dimension(M)).subspace(S[M]))
			else:J[M]=AffineSubspace(vector([0]*C.dimension(M)),VectorSpace(C.base(),C.dimension(M)).subspace([]))
		K=[]
		for V in C.total_degrees():
			if K==[]:
				for(A,B)in C.ordered_bidegrees(V):
					W=PuncturedAffineSpace(VectorSpace(C.base(),C.dimension((A,B))),AffineSubspace(vector([0]*C.dimension((A,B))),C.delldelbar_cocycles_raw((A,B))),[AffineSubspace(vector([0]*C.dimension((A,B))),C.dell_coboundaries_raw((A,B))+C.delbar_coboundaries_raw((A,B))+J[A,B].linear_part())])
					if W.is_empty()==_C:
						if K==[]:K.append((A,B))
						elif(A-1,B+1)in K:K.append((A,B))
		if K==[]:return
		D,E=K[0];T=_C;G={};N={};L=D-1;H={};Q={}
		if(D,E+1)in C.bidegrees():
			X=PuncturedAffineSpace(VectorSpace(C.base(),C.dimension((D,E+1))),AffineSubspace(vector([0]*C.dimension((D,E+1))),C.delbar_coboundaries_raw((D,E+1)).intersection(C.dell_cocycles_raw((D,E+1)))),[AffineSubspace(vector([0]*C.dimension((D,E+1))),C.delldelbar_coboundaries_raw((D,E+1))+J[D,E+1].linear_part())]);I=X.preimage(C.delbar((D,E))).remove_subspace(J[D,E])
			if I.is_empty():I=PuncturedAffineSpace.unpunctured_from_vector_space(VectorSpace(C.base(),C.dimension((D,E))),C.delbar_cocycles_raw((D,E)))
		else:I=PuncturedAffineSpace.total(VectorSpace(C.base(),C.dimension((D,E)))).remove_subspace(J[D,E])
		Q[D,E]=I
		for(A,B)in K:
			if L==D-1:
				G={};N[A,B]={(A,B):PuncturedAffineSpace(VectorSpace(C.base(),C.dimension((A,B))),AffineSubspace(vector([0]*C.dimension((A,B))),C.delldelbar_cocycles_raw((A,B))),[AffineSubspace(vector([0]*C.dimension((A,B))),C.dell_coboundaries_raw((A,B))+C.delbar_coboundaries_raw((A,B))+J[A,B].linear_part())])};O=A-D
				for F in range(O):N[A,B][A-F-1,B+F+1]=N[A,B][A-F,B+F].image(C.delbar((A-F,B+F))).preimage(C.dell((A-1-F,B+1+F))).remove_subspace(J[A-1-F,B+1+F])
				if(A-1,B+1)in N:I=I.intersection(N[A-1,B+1][D,E])
				Q[A,B]=I;G[A,B]=N[A,B][A,B].intersection(PuncturedAffineSpace.unpunctured_from_vector_space(VectorSpace(C.base(),C.dimension((A,B))),C.dell_cocycles_raw((A,B)))).remove_subspace(J[A,B])
				for F in range(O):G[A-F-1,B+F+1]=G[A-F,B+F].image(C.delbar((A-F,B+F))).preimage(C.dell((A-1-F,B+1+F))).remove_subspace(J[A-1-F,B+1+F])
				P=G[D,E].intersection(I).get_point()
				if P!=_B:T=_A;L=A;H[D,E]=P
		if L==D-1:
			G={};R,Y=K[-1]
			for O in range(R-D+1):
				if L==D-1:
					A=R-O;B=Y+O
					if(A+1,B)in C.bidegrees():Z=J[A,B].linear_part()+C.dell_cocycles_raw((A,B))+VectorSpace(C.base(),C.dimension((A,B))).subspace([C.dell((A,B)).solve_right(D)for D in C.delbar_coboundaries_raw((A+1,B)).intersection(C.dell_coboundaries_raw((A+1,B))).basis()]);G[A,B]=PuncturedAffineSpace(VectorSpace(C.base(),C.dimension((A,B))),AffineSubspace(vector([0]*C.dimension((A,B))),C.delldelbar_cocycles_raw((A,B))),[AffineSubspace(vector([0]*C.dimension((A,B))),C.dell_coboundaries_raw((A,B))+C.delbar_coboundaries_raw((A,B))),AffineSubspace(vector([0]*C.dimension((A,B))),Z)])
					else:G[A,B]=PuncturedAffineSpace(VectorSpace(C.base(),C.dimension((A,B))),AffineSubspace(vector([0]*C.dimension((A,B))),C.delldelbar_cocycles_raw((A,B))),[AffineSubspace(vector([0]*C.dimension((A,B))),C.dell_coboundaries_raw((A,B))+C.delbar_coboundaries_raw((A,B))),J[A,B]])
					for F in range(R-D-O):G[A-F-1,B+F+1]=G[A-F,B+F].image(C.delbar((A-F,B+F))).preimage(C.dell((A-F-1,B+F+1)))
					f=G[D,E].intersection(Q[A,B]);P=G[D,E].intersection(Q[A,B]).get_point()
					if P!=_B:L=A;H[D,E]=P
		if L==D-1:return
		if(D,E+1)in C.bidegrees():
			a=C.delbar((D,E))*H[D,E]
			if a!=0:H[D,E+1]=C.delbar((D,E))*H[D,E]
		if(D+1,E)in C.bidegrees():
			b=C.dell((D,E))*H[D,E]
			if b!=0:H[D+1,E]=C.dell((D,E))*H[D,E]
		for A in range(D+1,L+1):
			B=D+E-A
			if A!=D:c=C.delbar((A,B)).solve_right(H[A,B+1]);d=AffineSubspace(c,C.delbar_cocycles_raw((A,B)));I=PuncturedAffineSpace.unpunctured(VectorSpace(C.base(),C.dimension((A,B))),d)
			else:I=PuncturedAffineSpace.total(VectorSpace(C.base(),C.dimension((A,B))))
			for U in range(A,L):e=A+B-U;I=I.intersection(N[U,e][A,B])
			H[A,B]=I.intersection(G[A,B]).get_point()
			if T==_C or A!=L:H[A+1,B]=C.dell((A,B))*H[A,B]
		return H
	def zigzags_decomposition(A,raw=_C):
		G='The zigzags decomposition was not computed successfully'
		if raw==_A:
			if A.__zigzags_decomposition==_B:
				try:
					D=[];E={};F=_C
					while F==_C:
						B=A.__find_zigzag(already_computed=E)
						if B==_B or B=={}:F=_A
						else:
							D.append(B)
							for C in B:
								if C in E:E[C].append(B[C])
								else:E[C]=[B[C]]
					if A._is_zigzag_decomposition(D):A.__zigzags_decomposition=D;return D
					else:raise BaseException(G)
				except:raise BaseException(G)
			else:return A.__zigzags_decomposition
		else:H=A.zigzags_decomposition(raw=_A);return[{B:A.element(B,C[B])for B in C}for C in H]
	def _is_zigzag(D,zigzag):
		C=zigzag
		for(A,B)in C:
			if(A+1,B)in C:
				if D.dell((A,B))*C[A,B]!=C[A+1,B]:return _C
			elif D.dell((A,B))*C[A,B]!=0:return _C
			if(A,B+1)in C:
				if D.delbar((A,B))*C[A,B]!=C[A,B+1]:return _C
			elif D.delbar((A,B))*C[A,B]!=0:return _C
		return _A
	def _is_zigzag_decomposition(A,zigzags):
		B=A.subcomplex({})
		for E in zigzags:
			C=A.subcomplex({A:[E[A]]for A in E})
			if C.is_zigzag()==_C:return _C
			elif sum(B.intersection(C).dimension(A)for A in A.bidegrees())!=0:return _C
			else:B=C.sum(B)
		for D in A.bidegrees():
			if B.dimension(D)!=A.reduced_aeppli_cohomology_raw(D).rank()+A.bottchern_cohomology_raw(D).rank():return _C
		return _A
	def zigzags_subcomplex(A):
		B={A:[]for A in A.bidegrees()}
		for C in A.zigzags_decomposition(raw=_A):
			for D in C:B[D].append(C[D])
		return A.subcomplex(B)
	def zigzags_basis(B,bidegree=_B,raw=_C):
		A=bidegree
		if raw==_A:
			C=B.zigzags_subcomplex()
			if A==_B:return{A:[A for A in C.subspace(A).basis()]for A in B.bidegrees()}
			else:return[A for A in C.subspace(A).basis()]
		else:
			D=B.zigzags_basis(bidegree=A,raw=_A)
			if A==_B:return{A:[B.element(A,C)for C in D[A]]for C in B.bidegrees()}
			else:return[B.element(A,C)for C in D]
	def zigzags_shapes(Q,raw=_C):
		R=Q.zigzags_decomposition(raw=raw);L={};D={}
		for C in R:
			E={};I=len(C);A=_B;B=_B;J=_B;M=_B
			for(F,G)in C:
				if F+G in E:E[F+G]+=1
				else:E[F+G]=1
				if A==_B or F<A or G>B:A=F;B=G
				if J==_B or F>J or G<M:J=F;M=G
			if I%2==0:
				if(A+1,B)in C:N=1
				else:N=2
				S=I/2
				if(A,B,N,I)in L:L[A,B,N,I].append(C[A,B])
				else:L[A,B,N,I]=[C[A,B]]
			elif len(E)==1:
				if(A,B,A+B)in D:D[A,B,A+B].append(C[A,B])
				else:D[A,B,A+B]=[C[A,B]]
			else:
				[O,P]=list(E.keys())
				if E[O]>E[P]:
					K=O
					if P>O:H=A,M,K
					else:H=J,B,K
				else:
					K=P
					if O>P:H=A,M,K
					else:H=J,B,K
				if H in D:D[H].append(C[A,B])
				else:D[H]=[C[A,B]]
		return L,D
	def zigzags_inclusion(A,bidegree):B=bidegree;C=A.zigzags_basis(B,raw=_A);return Matrix(A.__base,len(C),A.__dimension[B],[A for A in C]).transpose()
	def zigzags_projection(A,bidegree):
		B=bidegree;C=A.zigzags_basis(B,raw=_A);D=len(C);G=Matrix(A.base(),A.dimension(B),[A for A in C]+[A for A in A.squares_basis(B,raw=_A)]).transpose().inverse();E=Matrix(A.base(),D,A.dimension(B))
		for F in range(D):E[F,F]=1
		return E*G
	def zigzags_deformation_retract(A):
		F={};H={};I={};M={};N={};J={}
		for(B,C)in A.bidegrees():
			F[B,C]=A.zigzags_basis((B,C))
			if(B+1,C)in A.bidegrees():H[B,C]=A.zigzags_projection((B+1,C))*A.dell((B,C))*A.zigzags_inclusion((B,C))
			else:H[B,C]=Matrix(A.base(),0,len(F[B,C]))
			if(B,C+1)in A.bidegrees():I[B,C]=A.zigzags_projection((B,C+1))*A.delbar((B,C))*A.zigzags_inclusion((B,C))
			else:I[B,C]=Matrix(A.base(),0,len(F[B,C]))
			M[B,C]=A.zigzags_inclusion((B,C));N[B,C]=A.zigzags_projection((B,C))
			if(B-1,C-1)in A.bidegrees():
				O=A.delldelbar((B-1,C-1)).columns();E=[];K=[]
				for D in range(A.dimension((B-1,C-1))):
					if O[D]not in VectorSpace(A.base(),A.dimension((B,C))).subspace(E):E+=[O[D]];K+=[vector([int(A==D)for A in range(A.dimension((B-1,C-1)))])]
				for P in A.squares_basis((B,C),raw=_A):
					if P not in VectorSpace(A.base(),A.dimension((B,C))).subspace(E):E+=[P]
				for D in range(A.dimension((B,C))):
					Q=vector(int(D==A)for A in range(A.dimension((B,C))))
					if Q not in VectorSpace(A.base(),A.dimension((B,C))).subspace(E):E+=[Q]
				R=Matrix(A.base(),A.dimension((B,C)),E).transpose().inverse();G=Matrix(A.base(),A.dimension((B,C)),A.dimension((B-1,C-1)))
				for D in range(len(K)):G[D,:]=K[D]
				G=G.transpose();J[B,C]=G*R
			else:J[B,C]=Matrix(A.base(),A.dimension((B,C)),0)
		L=BigradedComplex(A.base(),H,I,names=F);return L,BigradedComplexMap(L,A,M),BigradedComplexMap(A,L,N),BigradedComplexMap(A,A,J,bidegree=(-1,-1))
	def squares_basis(A,bidegree=_B,raw=_C):
		B=bidegree
		if B!=_B:
			if B not in A.__squares_basis:
				D=A.zigzags_basis(B,raw=_A);A.__squares_basis[B]=[]
				for E in range(A.dimension(B)):
					C=vector([int(E==A)for A in range(A.dimension(B))])
					if C not in VectorSpace(A.base(),A.dimension(B)).subspace(D+A.__squares_basis[B]):A.__squares_basis[B]+=[C]
			if raw==_A or A.names()==_B:return A.__squares_basis[B]
			else:return[A.element(B,C)for C in A.squares_basis(B,raw=_A)]
		else:
			for B in A.bidegrees():A.squares_basis(bidegree=B,raw=_A)
			if raw==_A:return A.__squares_basis
			else:return{B:[A.element(B,C)for C in A.__squares_basis[B]]for B in A.bidegrees()}
	def squares(A,bidegree=_B,raw=_C):
		B=bidegree
		if B!=_B:
			if raw==_A or A.__names==_B:return VectorSpace(A.base(),A.dimension(B)).subspace(A.squares_basis(B,raw=_A))
			else:return VectorSpace(A.base(),A.squares_basis(B))
		else:return{B:A.squares(bidegree=B,raw=raw)for B in A.bidegrees()}
	def squares_decomposition(C,raw=_C):
		if raw==_A:
			F=C.squares_basis(raw=_A);G=[];E={A:[]for A in F};K=C.zigzags_basis(raw=_A)
			for(A,B)in F:
				for D in F[A,B]:
					if C.delldelbar((A,B))*D!=0 and D not in VectorSpace(C.base(),C.dimension((A,B))).subspace(K[A,B]+E[A,B]):H=C.dell((A,B))*D;I=C.delbar((A,B))*D;J=C.delldelbar((A,B))*D;L={(A,B):D,(A+1,B):H,(A,B+1):I,(A+1,B+1):J};E[A,B].append(D);E[A+1,B].append(H);E[A,B+1].append(I);E[A+1,B+1].append(J);G.append(L)
			return G
		else:return[{A:C.element(A,B[A])for A in B}for B in C.squares_decomposition(raw=_A)]
	def total_degree_to_bidegree(B,total_degree,element):
		D={};A=0
		for C in B.ordered_bidegrees(total_degree):D[C]=vector(element[A:A+B.dimension(C)]);A=A+B.dimension(C)
		return D
	def bidegree_to_total_degree(D,element):
		B=element
		if B=={}:return 0
		else:
			E,F=list(B.keys())[0];G=E+F;A=[]
			for C in D.ordered_bidegrees(G):
				if C in B:A=A+list(B[C])
				else:A=A+[0]*D.dimension(C)
			return vector(A)
	def total_dimension(A,total_degree=_B):
		B=total_degree
		if B!=_B:return sum(A.dimension(B)for B in A.ordered_bidegrees(B))
		else:return{B:A.total_dimension(total_degree=B)for B in A.total_degrees()}
	def total_dell(A,total_degree):
		B=[]
		for(C,D)in A.ordered_bidegrees(total_degree):
			for E in A.dell((C,D)).columns():B.append(A.bidegree_to_total_degree({(C+1,D):E}))
		return Matrix(A.base(),B).transpose()
	def total_delbar(A,total_degree):
		B=[]
		for(C,D)in A.ordered_bidegrees(total_degree):
			for E in A.delbar((C,D)).columns():B.append(A.bidegree_to_total_degree({(C,D+1):E}))
		return Matrix(A.base(),B).transpose()
	def total_differential(A,total_degree):
		B=total_degree
		if B in A.total_degrees():
			if B+1 in A.total_degrees():return A.total_dell(B)+A.total_delbar(B)
			else:return Matrix(A.base(),0,A.total_dimension(B))
		elif B+1 in A.total_degrees():return Matrix(A.base(),A.total_dimension(B+1),0)
		else:return Matrix(A.base(),0)
	def total_coboundaries(A,total_degree):
		B=total_degree
		if B not in A.total_degrees():return VectorSpace(A.base(),0)
		elif B-1 not in A.total_degrees():return VectorSpace(A.base(),A.total_dimension(B)).subspace([])
		else:return VectorSpace(A.base(),A.total_dimension(B)).subspace(A.total_differential(B-1).columns())
	def total_cocycles(A,total_degree):
		B=total_degree
		if B not in A.total_degrees():return VectorSpace(A.base(),0)
		else:return A.total_differential(B).right_kernel()
	def horizontal_filtration(A,stage,total_degree):
		C=total_degree
		if C not in A.total_degrees():return VectorSpace(A.base(),0)
		else:
			E=[]
			for(B,D)in A.ordered_bidegrees(C):
				if B>=stage:
					for F in range(A.dimension((B,D))):G=vector([int(F==A)for A in range(A.dimension((B,D)))]);E.append(A.bidegree_to_total_degree({(B,D):G}))
			return VectorSpace(A.base(),A.total_dimension(C)).subspace(E)
	def spectral_sequence_cocycles(A,r,p,total_degree):
		B=total_degree
		if B in A.total_degrees():
			if B+1 not in A.total_degrees():return A.horizontal_filtration(p,B)
			else:C=VectorSpace(A.base(),A.total_dimension(B+1)).subspace([A.total_differential(B)*C for C in A.horizontal_filtration(p,B).basis()]).intersection(A.horizontal_filtration(p+r,B+1));return A.total_cocycles(B).intersection(A.horizontal_filtration(p,B))+VectorSpace(A.base(),A.total_dimension(B)).subspace(A.total_differential(B).solve_right(C)for C in C.basis())
		else:return VectorSpace(A.base(),0)
	def spectral_sequence_coboundaries(A,r,p,total_degree):
		B=total_degree
		if B in A.total_degrees():return A.horizontal_filtration(p,B).intersection(VectorSpace(A.base(),A.total_dimension(B)).subspace([A.total_differential(B-1)*C for C in A.horizontal_filtration(p-r,B-1).basis()]))
		else:return VectorSpace(A.base(),0)
	def spectral_sequence_basis(A,r,p,q,raw=_C):
		if raw==_A or A.names()==_B:return(A.spectral_sequence_cocycles(r,p,p+q)/(A.spectral_sequence_cocycles(r-1,p+1,p+q)+A.spectral_sequence_coboundaries(r-1,p,p+q))).basis()
		else:
			E=A.spectral_sequence(r,p,q,raw=_A);G=[A.total_degree_to_bidegree(p+q,E.lift(B))for B in E.basis()];F=[]
			for B in G:
				C=''
				for D in B:
					if B[D]!=0:C=C+str(A.element(D,B[D]))+_H
				F.append(_F.format(C[:-3]))
			return F
	def spectral_sequence(A,r,p,q,raw=_C):
		if raw==_A or A.names()==_B:return A.spectral_sequence_cocycles(r,p,p+q)/(A.spectral_sequence_cocycles(r-1,p+1,p+q)+A.spectral_sequence_coboundaries(r-1,p,p+q))
		else:return VectorSpace(A.base(),A.spectral_sequence_basis(r,p,q,raw=_C))
	def __ascii_art_table(C,data,n_generators_row):
		O=n_generators_row;M='  |  ';K=data;E={};J={};P=0;D={}
		for Q in C.bidegrees():
			if Q not in K:K[Q]=[]
		for(A,B)in C.__dimension:
			N=len(K[A,B]);D[A,B]=[''];H=0
			for R in range(N-1):
				D[A,B][H]=D[A,B][H]+str(K[A,B][R])+', '
				if R%O==O-1:D[A,B][H]=D[A,B][H][:-1];H+=1;D[A,B]+=['']
			if N!=0:D[A,B][H]=D[A,B][H]+str(K[A,B][N-1])
			if(B in J)==_C:J[B]=H+1
			elif J[B]<H+1:J[B]=H+1
		for(A,B)in C.bidegrees():
			for F in range(len(D[A,B])):
				if(A in E)==_C:E[A]=len(D[A,B][F])
				elif E[A]<len(D[A,B][F]):E[A]=len(D[A,B][F])
		G=len(str(C.__min_p))
		if len(str(C.__max_p))>G:G=len(str(C.__max_p))
		if len(str(C.__min_q))>G:G=len(str(C.__min_q))
		if len(str(C.__max_q))>G:G=len(str(C.__max_q))
		for A in range(C.__min_p,C.__max_p+1):
			if(A in E)==_C:E[A]=G
			elif E[A]<G:E[A]=G
			P+=E[A]
		for B in range(C.__min_q,C.__max_q+1):
			if(B in J)==_C:J[B]=1
		L=['-']*(G+P+5*(C.__max_p-C.__min_p+1)+2);S=2+G
		for A in range(C.__min_p,C.__max_p+1):L[S]='+';S+=E[A]+5
		L=''.join(L)
		for T in range(C.__max_q-C.__min_q+1):
			B=C.__max_q-T;I=['']*J[B]
			for F in range(J[B]):
				if F==0:I[F]=str(B)+_E*(G-len(str(B)))
				else:I[F]=_E*G
				for A in range(C.__min_p,C.__max_p+1):
					if(A,B)in D:
						if F<len(D[A,B]):I[F]+=M+D[A,B][F]+_E*(E[A]-len(D[A,B][F]))
						else:I[F]+=M+_E*E[A]
					else:I[F]+=M+_E*E[A]
				print(I[F])
			print(L)
		I=_E*G
		for A in range(C.__min_p,C.__max_p+1):I+=M+str(A)+_E*(E[A]-len(str(A)))
		print(I)
	def _ascii_art_dell_cohomology(A,n_generators_row=-1):print('Anti-Dolbeault cohomology:\n');A.__ascii_art_table({B:A.dell_cohomology_basis(B)for B in A.bidegrees()},n_generators_row)
	def _ascii_art_delbar_cohomology(A,n_generators_row=-1):print('Dolbeault cohomology:\n');A.__ascii_art_table({B:A.delbar_cohomology_basis(B)for B in A.bidegrees()},n_generators_row)
	def _ascii_art_bottchern_cohomology(A,n_generators_row=-1):print('Bott-Chern cohomology:\n');A.__ascii_art_table({B:A.bottchern_cohomology_basis(B)for B in A.bidegrees()},n_generators_row)
	def _ascii_art_aeppli_cohomology(A,n_generators_row=-1):print('Aeppli cohomology:\n');A.__ascii_art_table({B:A.aeppli_cohomology_basis(B)for B in A.bidegrees()},n_generators_row)
	def _ascii_art_reduced_bottchern_cohomology(A,n_generators_row=-1):print('Reduced Bott-Chern cohomology:\n');A.__ascii_art_table({B:A.reduced_bottchern_cohomology_basis(B)for B in A.bidegrees()},n_generators_row)
	def _ascii_art_reduced_aeppli_cohomology(A,n_generators_row=-1):print('Reduced Aeppli cohomology:\n');A.__ascii_art_table({B:A.reduced_aeppli_cohomology_basis(B)for B in A.bidegrees()},n_generators_row)
	def _ascii_art_cohomologies(A,n_generators_row=-1):B=n_generators_row;A._ascii_art_delbar_cohomology(B);print(_G);A._ascii_art_dell_cohomology(B);print(_G);A._ascii_art_bottchern_cohomology(B);print(_G);A._ascii_art_aeppli_cohomology(B)
	def _ascii_art_zigzags(A,n_generators_row=-1):print('Zig-zags:\n');A.__ascii_art_table({B:A.zigzags_basis(B)for B in A.bidegrees()},n_generators_row)
	def _ascii_art_squares(A,n_generators_row=-1):print('Squares:\n');A.__ascii_art_table({B:A.squares_basis(B)for B in A.bidegrees()},n_generators_row)
	def _ascii_art_zigzags_decomposition(A,raw=_C):
		D=A.zigzags_decomposition(raw=raw);B=1
		for C in D:print('Zigzag #'+str(B)+': \n');A.__ascii_art_table({A:[C[A]]for A in C},n_generators_row=-1);print('\n\n');B+=1
	def _ascii_art_dots(D,n_generators_row=-1):
		E=D.zigzags_decomposition();B={}
		for C in E:
			if len(C)==1:
				for A in C:
					if A in B:B[A].append(C[A])
					else:B[A]=[C[A]]
		D.__ascii_art_table(B,n_generators_row=n_generators_row)
	def _ascii_art_spectral_sequence(A,r,n_generators_row=-1):A.__ascii_art_table({B:A.spectral_sequence_basis(r,B[0],B[1])for B in A.bidegrees()},n_generators_row=n_generators_row)
class BigradedComplexMap:
	def __init__(A,domain,codomain,mapp,bidegree=(0,0)):B=domain;A.__domain=B;A.__codomain=codomain;A.__base=B.base();A.__map=mapp;A.__bidegree=bidegree;A.__dell_boundary={};A.__delbar_boundary={};A.__induced_dell_cohomology={};A.__induced_delbar_cohomology={};A.__induced_bottchern_cohomology={};A.__induced_aeppli_cohomology={};A.__is_morphism=_B;A.__kernel=_B
	def __call__(A,bidegree,element,raw=_C):
		C=element;B=bidegree
		if B not in A.__domain.bidegrees():raise ValueError('The input bidegree '+str(B)+' must be a bidegree in the domain.')
		D,E=A.__bidegree;F,G=B
		if(F+D,G+E)in A.__codomain.bidegrees():
			if raw==_A or A.__codomain.names()==_B:return A.__map[B]*vector(C)
			else:return A.__codomain.element((F+D,G+E),A.__call__(B,C,raw=_A))
		else:return 0
	def domain(A):return A.__domain
	def codomain(A):return A.__codomain
	def bidegree(A):return A.__bidegree
	def base(A):return A.__base
	def map(A,bidegree):return A.__map[bidegree]
	def dell_boundary(A,bidegree=_B):
		B=bidegree
		if B==_B:
			for B in A.__map:
				if(B in A.__dell_boundary)==_C:A.__dell_boundary[B]=A.dell_boundary(B)
			return A.__dell_boundary
		else:
			C,D=B;E,F=A.__bidegree
			if(B in A.__dell_boundary)==_C:
				if(C+E+1,D+F)in A.__codomain.bidegrees():
					A.__dell_boundary[B]=Matrix(A.__base,A.__codomain.dimension((C+E+1,D+F)),A.__domain.dimension(B))
					if(C+E,D+F)in A.__codomain.bidegrees():A.__dell_boundary[B]+=A.__codomain.dell((C+E,D+F))*A.__map[B]
					if(C+1,D)in A.__domain.bidegrees():A.__dell_boundary[B]+=(-1+2*((A.__bidegree[0]+A.__bidegree[1])%2))*A.__map[C+1,D]*A.__domain.dell(B)
				else:A.__dell_boundary[B]=Matrix(A.__base,0,A.__domain.dimension(B))
			return A.__dell_boundary[B]
	def delbar_boundary(A,bidegree=_B):
		B=bidegree
		if B==_B:
			for B in A.__map:
				if(B in A.__delbar_boundary)==_C:A.__delbar_boundary[B]=A.delbar_boundary(B)
			return A.__delbar_boundary
		else:
			C,D=B;E,F=A.__bidegree
			if(B in A.__delbar_boundary)==_C:
				if(C+E,D+F+1)in A.__codomain.bidegrees():
					A.__delbar_boundary[B]=Matrix(A.__base,A.__codomain.dimension((C+E,D+F+1)),A.__domain.dimension(B))
					if(C+E,D+F)in A.__codomain.bidegrees():A.__delbar_boundary[B]+=A.__codomain.delbar((C+E,D+F))*A.__map[B]
					if(C,D+1)in A.__domain.bidegrees():A.__delbar_boundary[B]+=(-1+2*((A.__bidegree[0]+A.__bidegree[1])%2))*A.__map[C,D+1]*A.__domain.delbar(B)
				else:A.__delbar_boundary[B]=Matrix(A.__base,0,A.__domain.dimension(B))
			return A.__delbar_boundary[B]
	def is_morphism(A):
		if A.__is_morphism==_B:
			if A.__bidegree==(0,0):
				A.__is_morphism=_A;D=A.dell_boundary();E=A.delbar_boundary()
				for(B,C)in A.__map:
					if((B+1,C)in A.__codomain.dimension())==_C:
						if D[B,C]!=Matrix(A.__base,0,A.__domain.dimension((B,C))):A.__is_morphism=_C
					elif D[B,C]!=Matrix(A.__base,A.__codomain.dimension((B+1,C)),A.__domain.dimension((B,C))):A.__is_morphism=_C
					if((B,C+1)in A.__codomain.dimension())==_C:
						if E[B,C]!=Matrix(A.__base,0,A.__domain.dimension((B,C))):A.__is_morphism=_C
					elif E[B,C]!=Matrix(A.__base,A.__codomain.dimension((B,C+1)),A.__domain.dimension((B,C))):A.__is_morphism=_C
			else:A.__is_morphism=_C
		return A.__is_morphism
	def _ascii_art_map(A):
		C=0
		for B in A.__domain.names():
			for E in A.__domain.names()[B]:
				if len(str(E))>C:C=len(str(E))
		F,G=A.__bidegree
		for B in A.__domain.dimension():
			H,I=B;L=(H+F,I+G)in A.__codomain.bidegrees();print('Bidegree '+str(B)+':')
			for J in range(A.__domain.dimension(B)):
				D=A.__domain.names()[B][J];K=len(str(D))
				if L:print('\t'+str(D)+_E*(C+2-K)+'|---->  '+str(A.__codomain.element((H+F,I+G),A.__map[B].column(J))))
				else:print('\t'+str(D)+_E*(C+2-K)+'|---->  0')
			print(_G)
class BigradedSubcomplex(BigradedComplex):
	def __init__(A,basis,parent,CHECK=_C):
		F=basis;A.__parent=parent;D={A:[]for A in F}
		for(B,C)in F:
			for E in F[B,C]:
				D[B,C].append(E);G=A.__parent.dell((B,C))*E;H=A.__parent.delbar((B,C))*E;I=A.__parent.delldelbar((B,C))*E
				if G!=0:
					if(B+1,C)not in D:D[B+1,C]=[G]
					else:D[B+1,C].append(G)
				if H!=0:
					if(B,C+1)not in D:D[B,C+1]=[H]
					else:D[B,C+1].append(H)
				if I!=0:
					if(B+1,C+1)not in D:D[B+1,C+1]=[I]
					else:D[B+1,C+1].append(I)
		A.__subspace={B:VectorSpace(A.__parent.base(),A.__parent.dimension(B)).subspace(D[B])for B in D};J={};K={}
		for(B,C)in A.__subspace:
			if(B+1,C)not in A.__subspace:J[B,C]=Matrix(A.__parent.base(),0,A.__subspace[B,C].rank())
			else:J[B,C]=Matrix(A.__parent.base(),[A.__subspace[B+1,C].coordinates(A.__parent.dell((B,C))*D)for D in A.__subspace[B,C].basis()]).transpose()
			if(B,C+1)not in A.__subspace:K[B,C]=Matrix(A.__parent.base(),0,A.__subspace[B,C].rank())
			else:K[B,C]=Matrix(A.__parent.base(),[A.__subspace[B,C+1].coordinates(A.__parent.delbar((B,C))*D)for D in A.__subspace[B,C].basis()]).transpose()
		if A.__parent.names()!=_B:L={B:['('+str(A.__parent.element(B,C))+')'for C in A.__subspace[B].basis()]for B in A.__subspace}
		else:L=_B
		BigradedComplex.__init__(A,A.__parent.base(),J,K,names=L,CHECK=CHECK);M={B:Matrix(A.__parent.base(),[A for A in A.__subspace[B].basis()]).transpose()for B in A.__subspace};A.__inclusion=BigradedComplexMap(A,A.__parent,M)
	def subspace(A,bidegree=_B):
		B=bidegree
		if B==_B:return A.__subspace
		elif B in A.bidegrees():return A.__subspace[B]
		else:return VectorSpace(A.base(),A.parent().dimension(B)).subspace([])
	def inclusion(A):return A.__inclusion
	def parent(A):return A.__parent
	def parent_element(A,bidegree,element,raw=_A):return A.__inclusion(bidegree,element,raw=raw)
	def element(A,bidegree,element):B=bidegree;return A.parent().element(B,A.parent_element(B,element))
	def intersection(B,subcomplex):
		D=subcomplex;C={}
		for A in B.bidegrees():
			if A in D.bidegrees():C[A]=B.subspace(bidegree=A).intersection(D.subspace(bidegree=A))
		return B.parent().subcomplex({A:C[A].basis()for A in C})
	def sum(C,subcomplex):
		D=subcomplex;B={}
		for A in C.bidegrees():
			if A in D.bidegrees():B[A]=C.subspace(bidegree=A)+D.subspace(bidegree=A)
			else:B[A]=C.subspace(bidegree=A)
		for A in D.bidegrees():
			if A not in B:
				if A in C.bidegrees():B[A]=C.subspace(bidegree=A)+D.subspace(bidegree=A)
				else:B[A]=D.subspace(bidegree=A)
		return C.parent().subcomplex({A:B[A].basis()for A in B})
	def is_zigzag(A):
		if len(A.bidegrees())==0:return _C
		elif len(A.bidegrees())==1:return A.dimension(A.bidegrees()[0])==1
		else:
			D=A.total_degrees();E=A.ordered_bidegrees()
			if len(D)!=2:return _C
			if D[1]!=D[0]+1:return _C
			for(B,C)in A.bidegrees():
				if A.dimension((B,C))!=1:return _C
			F,G=E[D[0]][0];H,I=E[D[0]][-1]
			for(B,C)in E[D[0]]:
				if(B,C)==(F,G):
					if(F,G)!=(H,I):
						if(F+1,G)not in A.bidegrees()or A.dell((F,G))==0:return _C
				elif(B,C)==(H,I):
					if(H,I+1)not in A.bidegrees()or A.delbar((H,I))==0:return _C
				elif(B+1,C)not in A.bidegrees()or(B,C+1)not in A.bidegrees()or A.dell((B,C))==0 or A.delbar((B,C))==0:return _C
			for(B,C)in E[D[0]]:
				if(A.parent().dell_coboundaries_raw((B,C))+A.parent().delbar_coboundaries_raw((B,C))).intersection(A.subspace((B,C))).rank()!=0:return _C
			return _A
class BidifferentialBigradedCommutativeAlgebra(BigradedComplex):
	def __init__(A,algebra,dell_dictionary,delbar_dictionary,min_deg,max_deg):
		H=delbar_dictionary;G=algebra;D=dell_dictionary;A.__zigzags=_B;A.__zigzags_i=_B;A.__zigzags_p=_B;A.__zigzags_h11=_B;A.__zigzags_h10=_B;A.__zigzags_h01=_B;A.__algebra=G;A.__min_deg=min_deg;A.__max_deg=max_deg;I=D[list(D.keys())[0]]not in G;J={}
		if I:E=D;F=H
		else:E={};F={}
		for B in range(A.__min_deg,A.__max_deg+1):
			for C in range(A.__min_deg,A.__max_deg+1):
				K=A.__algebra.basis((B,C))
				if K!=[]:
					J[B,C]=K
					if not I:E[B,C]=A.__algebra.differential(D).differential_matrix_multigraded((B,C)).transpose();F[B,C]=A.__algebra.differential(H).differential_matrix_multigraded((B,C)).transpose()
		BigradedComplex.__init__(A,A.__algebra.base(),E,F,names=J)
	def algebra(A):return A.__algebra
	def min_deg(A):return A.__min_deg
	def max_deg(A):return A.__max_deg
	def zigzags_i(A):
		if A.__zigzags_i==_B:A.__compute_zigzags_deformation_retract()
		return A.__zigzags_i
	def zigzags_p(A):
		if A.__zigzags_p==_B:A.__compute_zigzags_deformation_retract()
		return A.__zigzags_p
	def zigzags_h11(A):
		if A.__zigzags_h11==_B:A.__compute_zigzags_deformation_retract()
		return A.__zigzags_h11
	def zigzags_h10(A):
		if A.__zigzags_h10==_B:A.__compute_zigzags_deformation_retract()
		return A.__zigzags_h10
	def zigzags_h01(A):
		if A.__zigzags_h01==_B:A.__compute_zigzags_deformation_retract()
		return A.__zigzags_h01
	def subalgebra(C,subalgebra_generators):
		K=subalgebra_generators;W=[];X=[];Y=[];P=['x'+str(A)for A in range(len(K))];Z=[];a=[];b=[];Q=[A.degree()for A in K];c=[];d=[];e=[];L=0
		for G in K:
			A,B=G.degree()
			if(A+1,B)in C.bidegrees()and C.dell((A,B))*vector(G.basis_coefficients())!=0:W+=[C.element((A+1,B),C.dell((A,B))*vector(G.basis_coefficients()))];Z+=['y'+str(L)];c+=[(A+1,B)]
			if(A,B+1)in C.bidegrees()and C.delbar((A,B))*vector(G.basis_coefficients())!=0:X+=[C.element((A,B+1),C.delbar((A,B))*vector(G.basis_coefficients()))];a+=['z'+str(L)];d+=[(A,B+1)]
			if(A+1,B+1)in C.bidegrees()and C.delldelbar((A,B))*vector(G.basis_coefficients())!=0:Y+=[C.element((A+1,B+1),C.delldelbar((A,B))*vector(G.basis_coefficients()))];b+=['w'+str(L)];e+=[(A+1,B+1)]
			L+=1
		Q=Q+c+d+e;R=K+W+X+Y;P=P+Z+a+b;I={}
		for H in range(len(R)):
			A,B=Q[H]
			if A+B in I:I[A+B]+=[H]
			else:I[A+B]=[H]
		f=list(I.keys());f.sort();g=[];h=[];M=''
		for l in f:
			for H in I[l]:g+=[R[H].degree()];h+=[R[H]];M+=P[H]+','
		M=M[:-1];F=GradedCommutativeAlgebra(C.__algebra.base(),names=M,degrees=g);S=Hom(F,C.algebra())(h);J={};T={};i=[]
		for D in C.bidegrees():n=VectorSpace(C.base(),C.algebra().basis(D));J[D]=Matrix(C.base(),[S(A).basis_coefficients()if S(A)!=0 else vector([0 for A in range(C.dimension(D))])for A in F.basis(D)]).transpose();T[D]=J[D].pseudoinverse();m=J[D].right_kernel().basis();i+=[sum(A*B for(A,B)in zip(A,F.basis(D)))for A in m]
		E=F.quotient(F.ideal(i));N={};O={}
		for D in C.bidegrees():
			if F.basis(D)!=[]:
				if E.basis(D)==[]:N[D]=Matrix(C.base(),0,len(F.basis(D)))
				else:N[D]=Matrix(C.base(),[E(A).basis_coefficients()if E(A)!=0 else vector(0 for A in range(len(E.basis(D))))for A in F.basis(D)]).transpose()
			if E.basis(D)!=[]:
				if F.basis(D)==[]:O[D]=Matrix(C.base(),0,len(E.basis(D)))
				else:O[D]=Matrix(C.base(),[F(A.lift()).basis_coefficients()if A.lift()!=0 else vector([0 for A in range(len(F.basis(D)))])for A in E.basis(D)]).transpose()
		U={};V={}
		for(A,B)in C.bidegrees():
			if E.basis((A,B))!=[]:
				if E.basis((A+1,B))==[]:U[A,B]=Matrix(C.base(),0,len(E.basis((A,B))))
				else:U[A,B]=N[A+1,B]*T[A+1,B]*C.dell((A,B))*J[A,B]*O[A,B]
				if E.basis((A,B+1))==[]:V[A,B]=Matrix(C.base(),0,len(E.basis((A,B))))
				else:V[A,B]=N[A,B+1]*T[A,B+1]*C.delbar((A,B))*J[A,B]*O[A,B]
		j={}
		for D in C.bidegrees():
			for k in E.basis(D):j[k]=S(F(k.lift()))
		return BidifferentialBigradedCommutativeAlgebra(E,U,V,C.__min_deg,C.__max_deg),j
	@staticmethod
	def from_nilmanifold(lie_algebra,ac_structure,labels=_B,normalization_coefficients=_B,latex_generators=_B):
		M=normalization_coefficients;L=labels;G=lie_algebra;Q=G.gens();A=len(Q)
		if M==_B:M=[1 for A in range(A)]
		if A%2==1:raise'The Lie algebra must be even-dimensional.'
		elif A==0:return BidifferentialBigradedCommutativeAlgebra.unit(G.base())
		else:
			if L==_B:L=['a%s'%A for A in range(A/2)]+['b%s'%A for A in range(A/2)]
			J=ac_structure.eigenvectors_right()
			if J[0][0]==I:N=J[0][1]+J[1][1]
			else:N=J[1][1]+J[0][1]
			H=[M[B]*sum(N[B][A]*Q[A]for A in range(A))for B in range(A)];K=Matrix(G.base(),A,A,N).transpose().inverse();R=GradedCommutativeAlgebra(G.base(),names=L,degrees=tuple([(1,0)for A in range(A/2)]+[(0,1)for A in range(A/2)]));D=R.gens();O={A:0 for A in D};P={A:0 for A in D};E={}
			for F in range(A/2):
				for B in range(A/2):
					for C in range(B+1,A/2):
						if(B,C)not in E:E[B,C]=-K*vector(G.bracket(H[B],H[C]))
						O[D[F]]+=E[B,C][F]*D[B]*D[C]
					for C in range(A/2,A):
						if(B,C)not in E:E[B,C]=-K*vector(G.bracket(H[B],H[C]))
						P[D[F]]+=E[B,C][F]*D[B]*D[C]
			for F in range(A/2,A):
				for B in range(A/2):
					for C in range(A/2,A):
						if(B,C)not in E:E[B,C]=-K*vector(G.bracket(H[B],H[C]))
						O[D[F]]+=E[B,C][F]*D[B]*D[C]
				for B in range(A/2,A):
					for C in range(B+1,A):
						if(B,C)not in E:E[B,C]=-K*vector(G.bracket(H[B],H[C]))
						P[D[F]]+=E[B,C][F]*D[B]*D[C]
			return BidifferentialBigradedCommutativeAlgebra(R,O,P,0,A)
	def __compute_zigzags_deformation_retract(A):
		A.__zigzags,A.__zigzags_i,A.__zigzags_p,A.__zigzags_h11=A.zigzags_deformation_retract();A.__zigzags_h10=BigradedComplexMap(A,A,A.__zigzags_h11.delbar_boundary(),bidegree=(-1,0));A.__zigzags_h01=A.__zigzags_h11.dell_boundary()
		for B in A.__zigzags_h01:A.__zigzags_h01[B]=-A.__zigzags_h01[B]
		A.__zigzags_h01=BigradedComplexMap(A,A,A.__zigzags_h01,bidegree=(0,-1))
	def operation(D,arity,operation_bidegree,show_progress=_C,compute_symmetries=_A):
		T='%';S='Progress: ';Q=operation_bidegree;O=show_progress;N=arity;K=compute_symmetries
		if D.__zigzags==_B:D.__compute_zigzags_deformation_retract()
		J={};P=Tuples(D.bidegrees(),N)
		if O==_A:L=0;R=len(P);M=0
		if N==3 and Q==(-1,0):
			C={}
			for B in P:
				if K or B[0][0]+B[1][0]+B[2][0]<=B[0][1]+B[1][1]+B[2][1]:
					for A in cartesian_product([D.zigzags_basis(A)for A in B]):
						G=B[0][0]+B[1][0]+B[2][0]-1,B[0][1]+B[1][1]+B[2][1]
						if G in D.bidegrees()and(K or(A[2],A[1],A[0])not in J):
							if(A[0],A[1])not in C:
								E=A[0]*A[1]
								if E==0 or(B[0][0]+B[1][0],B[0][1]+B[1][1])not in D.bidegrees():C[A[0],A[1]]=0
								else:C[A[0],A[1]]=D.__zigzags_h10((B[0][0]+B[1][0],B[0][1]+B[1][1]),(A[0]*A[1]).basis_coefficients())
							if(A[1],A[2])not in C:
								E=A[1]*A[2]
								if E==0 or(B[1][0]+B[2][0],B[1][1]+B[2][1])not in D.bidegrees():C[A[1],A[2]]=0
								else:C[A[1],A[2]]=D.__zigzags_h10((B[1][0]+B[2][0],B[1][1]+B[2][1]),(A[1]*A[2]).basis_coefficients())
							H=C[A[0],A[1]]*A[2]-A[0]*C[A[1],A[2]]
							if H!=0:
								I=D.__zigzags_p(G,H.basis_coefficients())
								if I!=0:J[tuple(A)]=I
				if O==_A:
					L+=1;F=int(100*L/R)
					if F>M:print(S+str(F)+T)
					M=F
		elif N==3 and Q==(0,-1):
			C={}
			for B in P:
				if K or B[0][0]+B[1][0]+B[2][0]<=B[0][1]+B[1][1]+B[2][1]:
					for A in cartesian_product([D.zigzags_basis(A)for A in B]):
						G=B[0][0]+B[1][0]+B[2][0],B[0][1]+B[1][1]+B[2][1]-1
						if G in D.bidegrees()and(K or(A[2],A[1],A[0])not in J):
							if(A[0],A[1])not in C:
								E=A[0]*A[1]
								if E==0 or(B[0][0]+B[1][0],B[0][1]+B[1][1])not in D.bidegrees():C[A[0],A[1]]=0
								else:C[A[0],A[1]]=D.__zigzags_h01((B[0][0]+B[1][0],B[0][1]+B[1][1]),(A[0]*A[1]).basis_coefficients())
							if(A[1],A[2])not in C:
								E=A[1]*A[2]
								if E==0 or(B[1][0]+B[2][0],B[1][1]+B[2][1])not in D.bidegrees():C[A[1],A[2]]=0
								else:C[A[1],A[2]]=D.__zigzags_h01((B[1][0]+B[2][0],B[1][1]+B[2][1]),(A[1]*A[2]).basis_coefficients())
							H=C[A[0],A[1]]*A[2]-A[0]*C[A[1],A[2]]
							if H!=0:
								I=D.__zigzags_p(G,H.basis_coefficients())
								if I!=0:J[tuple(A)]=I
				if O==_A:
					L+=1;F=int(100*L/R)
					if F>M:print(S+str(F)+T)
					M=F
		elif N==3 and Q==(-1,-1):
			C={}
			for B in P:
				if K or B[0][0]+B[1][0]+B[2][0]<=B[0][1]+B[1][1]+B[2][1]:
					for A in cartesian_product([D.zigzags_basis(A)for A in B]):
						G=B[0][0]+B[1][0]+B[2][0]-1,B[0][1]+B[1][1]+B[2][1]-1
						if G in D.bidegrees()and(K or(A[2],A[1],A[0])not in J):
							if(A[0],A[1])not in C:
								E=A[0]*A[1]
								if E==0 or(B[0][0]+B[1][0],B[0][1]+B[1][1])not in D.bidegrees():C[A[0],A[1]]=0
								else:C[A[0],A[1]]=D.__zigzags_h11((B[0][0]+B[1][0],B[0][1]+B[1][1]),(A[0]*A[1]).basis_coefficients())
							if(A[1],A[2])not in C:
								E=A[1]*A[2]
								if E==0 or(B[1][0]+B[2][0],B[1][1]+B[2][1])not in D.bidegrees():C[A[1],A[2]]=0
								else:C[A[1],A[2]]=D.__zigzags_h11((B[1][0]+B[2][0],B[1][1]+B[2][1]),(A[1]*A[2]).basis_coefficients())
							H=C[A[0],A[1]]*A[2]-A[0]*C[A[1],A[2]]
							if H!=0:
								I=D.__zigzags_p(G,H.basis_coefficients())
								if I!=0:J[tuple(A)]=I
				if O==_A:
					L+=1;F=int(100*L/R)
					if F>M:print(S+str(F)+T)
					M=F
		return J
class BidifferentialBigradedCommutativeAlgebraMap(BigradedComplexMap):
	def __init__(A,domain,codomain,mapp):BigradedComplexMap.__init__(A,domain,codomain,mapp)
	@staticmethod
	def from_image_generators(domain,codomain,image_generators):C=codomain;B=domain;D=B.algebra();A=C.algebra();E=GCAlgebra.Hom(D,A)(image_generators);F={A:Matrix(D.base(),B.dimension(A),C.dimension(A),[E(B).basis_coefficients()if E(B)!=0 else[0 for A in range(C.dimension(A))]for B in D.basis(A)]).transpose()for A in B.bidegrees()};return BidifferentialBigradedCommutativeAlgebraMap(B,C,F)
class BidifferentialBigradedCommutativeAlgebraExample:
	__QQi=QuadraticField(-1,'I')
	@staticmethod
	def KodairaThurston(acs=_B,names=_B):
		B=names;A=acs;C=LieAlgebra(BidifferentialBigradedCommutativeAlgebraExample.__QQi,'X,Y,Z,W',{('X','Y'):{'Z':-1}})
		if A==_B:A=Matrix(BidifferentialBigradedCommutativeAlgebraExample.__QQi,4,[[0,-1,0,0],[1,0,0,0],[0,0,0,-1],[0,0,1,0]])
		if B==_B:B=['a','b','abar','bbar']
		return BidifferentialBigradedCommutativeAlgebra.from_nilmanifold(C,A,B)
	@staticmethod
	def Iwasawa(acs=_B,names=_B):
		B=names;A=acs;C=LieAlgebra(BidifferentialBigradedCommutativeAlgebraExample.__QQi,'p,ip,q,iq,z,iz',{('p','q'):{'z':1},('p','iq'):{'iz':1},('ip','q'):{'iz':1},('ip','iq'):{'z':-1}})
		if A==_B:A=Matrix(BidifferentialBigradedCommutativeAlgebraExample.__QQi,6,[[0,1,0,0,0,0],[-1,0,0,0,0,0],[0,0,0,1,0,0],[0,0,-1,0,0,0],[0,0,0,0,0,1],[0,0,0,0,-1,0]])
		if B==_B:B=['a','b','c','abar','bbar','cbar']
		return BidifferentialBigradedCommutativeAlgebra.from_nilmanifold(C,A,B,normalization_coefficients=[1/2,1,1,1/2,1,1])

def build(lie_names, lie_bracket, acs_matrix, acs_names, normalization_coefficients=None):
    bfield = QuadraticField(-1, 'I')

    lie_algebra = LieAlgebra(bfield, lie_names, lie_bracket)
    acs = Matrix(bfield, len(acs_names), acs_matrix)

    return BidifferentialBigradedCommutativeAlgebra.from_nilmanifold(lie_algebra, acs, acs_names, normalization_coefficients)

def mapByBidegree(bbc : BigradedComplex, method: str):
    return {
        str(bidegree): list(map(lambda a: str(a), getattr(bbc, method)(bidegree)))
        for bidegree in bbc.bidegrees()
    }

def compute(lie_names, lie_bracket, acs_matrix, acs_names, norm):
    import json
    lie_bracket = {tuple(k.split(",")): v for  k, v in lie_bracket.items()}
    normalization_coefficients = list(map(QQ, norm)) if norm else None
    bbc = build(lie_names, lie_bracket, acs_matrix, acs_names, normalization_coefficients)
    return json.dumps({
        "n": int(max(map(lambda t: t[0], bbc.dimension().keys())) + 1),
        "m": int(max(map(lambda t: t[1], bbc.dimension().keys())) + 1),
        "cohomology": {
            cohomology: mapByBidegree(bbc, f"{cohomology}_cohomology_basis")
            for cohomology in [
                "dell",
                "delbar",
                "bottchern",
                "aeppli",
                "reduced_aeppli",
                "reduced_bottchern"
            ]
        },
        "zigzags": list(map(lambda a: {str(bidegree): str(v) for (bidegree, v) in a.items()}, bbc.zigzags_decomposition())),
        "squares": list(map(lambda a: str(a), bbc.squares_decomposition()))
    })