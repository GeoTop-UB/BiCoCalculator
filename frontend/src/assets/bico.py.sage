class BigradedComplex():
    def __init__(self, base, dell, delbar, names=None, latex_names=None, CHECK=False):
        self.__base = base
        self.__dimension = {}
        self.__bidegrees = []
        self.__dell = dell
        self.__delbar = delbar
        self.__delldelbar = {}
        self.__names = names
        self.__latex_names = latex_names

        self.__dell_cocycles = {}
        self.__dell_coboundaries = {}
        self.__delbar_cocycles = {}
        self.__delbar_coboundaries = {}
        self.__delldelbar_cocycles = {}
        self.__delldelbar_coboundaries = {}
        self.__dell_and_delbar_cocycles = {}
        self.__dell_and_delbar_coboundaries = {}
        self.__dell_cohomology = {}
        self.__delbar_cohomology = {}
        self.__aeppli_cohomology = {}
        self.__bottchern_cohomology = {}
        self.__reduced_bottchern_cohomology = {}
        self.__reduced_aeppli_cohomology = {}
        self.__zigzags_basis = {}
        self.__squares_basis = {}

        for (p,q) in self.__dell:
            if ((p,q) in self.__dimension) == False:
                self.__dimension[(p,q)] = self.__dell[(p,q)].ncols()
        for (p,q) in self.__delbar:
            if ((p,q) in self.__dimension) == False:
                self.__dimension[(p,q)] = self.__delbar[(p,q)].ncols()

        min_p = None
        max_p = None
        min_q = None
        max_q = None
        for (p,q) in self.bidegrees():
            if (min_p == None):
                min_p = p
                max_p = p
                min_q = q
                max_q = q
            else:
                if p < min_p:
                    min_p = p
                if p > max_p:
                    max_p = p
                if q < min_q:
                    min_q = q
                if q > max_q:
                    max_q = q
        self.__min_p = min_p
        self.__max_p = max_p
        self.__min_q = min_q
        self.__max_q = max_q

        for (p,q) in self.__dimension:
            if (p-1, q-1) not in self.__dimension:
                self.__delldelbar[(p-1,q-1)] = Matrix(self.__base, 0, self.__dimension[(p,q)])
            if (p+1,q+1) not in self.__dimension:
                self.__delldelbar[(p,q)] = Matrix(self.__base, 0, self.__dimension[(p,q)])
            elif (p,q+1) not in self.__dimension:
                self.__delldelbar[(p,q)] = Matrix(self.__base, self.__dimension[(p+1,q+1)], self.__dimension[(p,q)])
            else:
                self.__delldelbar[(p,q)] = self.__dell[(p,q+1)] * self.__delbar[(p,q)]

    def base(self):
        return self.__base

    def dimension(self, bidegree=None):
        if bidegree == None:
            return self.__dimension
        else:
            if bidegree not in self.bidegrees():
                return 0
            else:
                return self.__dimension[bidegree]

    def dell(self, bidegree=None):
        if bidegree == None:
            return self.__dell
        else:
            if bidegree not in self.bidegrees():
                raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
            else:
                return self.__dell[bidegree]

    def delbar(self, bidegree=None):
        if bidegree == None:
            return self.__delbar
        else:
            if bidegree not in self.bidegrees():
                raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
            else:
                return self.__delbar[bidegree]

    def delldelbar(self, bidegree=None):
        if bidegree == None:
            return self.__delldelbar
        else:
            if bidegree not in self.bidegrees():
                raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
            else:
                return self.__delldelbar[bidegree]

    def names(self, bidegree=None):
        if bidegree == None:
            return self.__names
        else:
            if bidegree not in self.bidegrees():
                raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
            else:
                return self.__names[bidegree]

    def bidegrees(self):
        return self.__dimension.keys()

    def zigzags_dimension(self, bidegree=None):
        if bidegree == None:
            dimensions = {}
            for bidegree in self.bidegrees():
                dimensions[bidegree] = self.zigzags_dimension(bidegree=bidegree)
            return dimensions
        else:
            return len(self.zigzags_basis(bidegree))

    def bigraded_component(self, bidegree):
        if self.names() == None:
            raise AttributeError("The bigraded complex has unspecified names")
        else:
            if bidegree not in self.bidegrees():
                raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
            else:
                return VectorSpace(self.base(), self.names(bidegree))

    def element(self, bidegree, coordinates):
        if self.names() == None:
            raise AttributeError("The bigraded complex has unspecified names")
        elif bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif len(coordinates) != self.dimension(bidegree):
            raise TypeError("The length of the provided coordinates does not coincide with the dimension of the bigraded component at bidegree " + str(bidegree))
        else:
            return sum(c * b for (c, b) in zip(coordinates, self.names(bidegree)))

    def dell_cocycles(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__dell_cocycles:
                self.__dell_cocycles[bidegree] = self.dell(bidegree).right_kernel()
                return self.__dell_cocycles[bidegree]
            else:
                return self.__dell_cocycles[bidegree]
        else:
            return VectorSpace(self.base(), [self.element(bidegree, b) for b in self.dell_cocycles(bidegree, raw=True).basis()])
    
    def dell_cocycles_raw(self, bidegree):
        return self.dell_cocycles(bidegree, raw=True)

    def dell_cocycles_inclusion(self, bidegree):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        else:
            dell_cocycles = self.dell_cocycles(bidegree, raw=True).basis()
            n = len(dell_cocycles)
            matrix = Matrix(self.base(), self.dimension(bidegree), n)
            for i in range(n):
                for j in range(self.dimension(bidegree)):
                    matrix[j,i] = dell_cocycles[i][j]
            return matrix

    def dell_cocycles_projection(self, bidegree):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        else:
            dell_cocycles = self.dell_cocycles(bidegree, raw=True)
            basis = list(dell_cocycles.gens())
            n = len(basis)
            for i in range(self.dimension(bidegree)):
                v = vector([int(i == j) for j in range(self.dimension(bidegree))])
                if v not in dell_cocycles:
                    basis += [v]
            change_basis = Matrix(self.base(), self.dimension(bidegree), basis)
            projection = Matrix(self.base(), n, self.dimension(bidegree))
            for i in range(n):
                projection[i,i] = 1
            return projection * change_basis

    def dell_coboundaries(self, bidegree, raw=False):
        (p,q) = bidegree
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__dell_coboundaries:
                if (p-1,q) not in self.bidegrees():
                    self.__dell_coboundaries[bidegree] = VectorSpace(self.base(), self.dimension(bidegree)).subspace([0])
                else:
                    self.__dell_coboundaries[bidegree] = VectorSpace(self.base(), self.dimension(bidegree)).subspace(self.dell((p-1,q)).transpose(), self.base())
            return self.__dell_coboundaries[bidegree]
        else:
            return VectorSpace(self.base(), [self.element(bidegree, b) for b in self.dell_coboundaries(bidegree, raw=True).basis()])

    def dell_coboundaries_raw(self, bidegree):
        return self.dell_coboundaries(bidegree, raw=True)

    def delbar_cocycles(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__delbar_cocycles:
                self.__delbar_cocycles[bidegree] = self.delbar(bidegree).right_kernel()
                return self.__delbar_cocycles[bidegree]
            else:
                return self.__delbar_cocycles[bidegree]
        else:
            return VectorSpace(self.base(), [self.element(bidegree, b) for b in self.delbar_cocycles(bidegree, raw=True).basis()])

    def delbar_cocycles_raw(self, bidegree):
        return self.delbar_cocycles(bidegree, raw=True)

    def delbar_cocycles_inclusion(self, bidegree):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        else:
            delbar_cocycles = self.delbar_cocycles(bidegree, raw=True).basis()
            n = len(delbar_cocycles)
            matrix = Matrix(self.base(), self.dimension(bidegree), n)
            for i in range(n):
                for j in range(self.dimension(bidegree)):
                    matrix[j,i] = delbar_cocycles[i][j]
            return matrix

    def delbar_cocycles_projection(self, bidegree):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        else:
            delbar_cocycles = self.delbar_cocycles(bidegree, raw=True)
            basis = list(delbar_cocycles.gens())
            n = len(basis)
            for i in range(self.dimension(bidegree)):
                v = vector([int(i == j) for j in range(self.dimension(bidegree))])
                if v not in delbar_cocycles:
                    basis += [v]
            change_basis = Matrix(self.base(), self.dimension(bidegree), basis)
            projection = Matrix(self.base(), n, self.dimension(bidegree))
            for i in range(n):
                projection[i,i] = 1
            return projection * change_basis

    def delbar_coboundaries(self, bidegree, raw=False):
        (p,q) = bidegree
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__delbar_coboundaries:
                if (p,q-1) not in self.bidegrees():
                    self.__delbar_coboundaries[bidegree] = VectorSpace(self.base(), self.dimension(bidegree)).subspace([0])
                else:
                    self.__delbar_coboundaries[bidegree] = VectorSpace(self.base(), self.dimension(bidegree)).subspace(self.delbar((p,q-1)).transpose(), self.base())
            return self.__delbar_coboundaries[bidegree]
        else:
            return VectorSpace(self.base(), [self.element(bidegree, b) for b in self.delbar_coboundaries(bidegree, raw=True).basis()])

    def delbar_coboundaries_raw(self, bidegree):
        return self.delbar_coboundaries(bidegree, raw=True)

    def delldelbar_cocycles(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__delldelbar_cocycles:
                self.__delldelbar_cocycles[bidegree] = self.delldelbar(bidegree).right_kernel()
                return self.__delldelbar_cocycles[bidegree]
            else:
                return self.__delldelbar_cocycles[bidegree]
        else:
            return VectorSpace(self.base(), [self.element(bidegree, b) for b in self.delldelbar_cocycles(bidegree, raw=True).basis()])

    def delldelbar_cocycles_raw(self, bidegree):
        return self.delldelbar_cocycles(bidegree, raw=True)

    def delldelbar_cocycles_inclusion(self, bidegree):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        else:
            delldelbar_cocycles = self.delldelbar_cocycles(bidegree, raw=True).basis()
            n = len(delldelbar_cocycles)
            matrix = Matrix(self.base(), self.dimension(bidegree), n)
            for i in range(n):
                for j in range(self.dimension(bidegree)):
                    matrix[j,i] = delldelbar_cocycles[i][j]
            return matrix

    def delldelbar_cocycles_projection(self, bidegree):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        else:
            delldelbar_cocycles = self.delldelbar_cocycles(bidegree, raw=True)
            basis = list(delldelbar_cocycles.gens())
            n = len(basis)
            for i in range(self.dimension(bidegree)):
                v = vector([int(i == j) for j in range(self.dimension(bidegree))])
                if v not in delldelbar_cocycles:
                    basis += [v]
            change_basis = Matrix(self.base(), self.dimension(bidegree), basis)
            projection = Matrix(self.base(), n, self.dimension(bidegree))
            for i in range(n):
                projection[i,i] = 1
            return projection * change_basis

    def delldelbar_coboundaries(self, bidegree, raw=False):
        (p,q) = bidegree
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__delldelbar_coboundaries:
                if (p-1,q-1) not in self.bidegrees():
                    self.__delldelbar_coboundaries[bidegree] = VectorSpace(self.base(), self.dimension(bidegree)).subspace([0])
                else:
                    self.__delldelbar_coboundaries[bidegree] = VectorSpace(self.base(), self.dimension(bidegree)).subspace(self.delldelbar((p-1,q-1)).transpose(), self.base())
            return self.__delldelbar_coboundaries[bidegree]
        else:
            return VectorSpace(self.base(), [self.element(bidegree, b) for b in self.delldelbar_coboundaries(bidegree, raw=True).basis()])

    def delldelbar_coboundaries_raw(self, bidegree):
        return self.delldelbar_coboundaries(bidegree, raw=True)

    def dell_and_delbar_cocycles(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__dell_and_delbar_cocycles:
                self.__dell_and_delbar_cocycles[bidegree] = self.dell_cocycles(bidegree, raw=True).intersection(self.delbar_cocycles(bidegree, raw=True))
                return self.__dell_and_delbar_cocycles[bidegree]
            else:
                return self.__dell_and_delbar_cocycles[bidegree]
        else:
            return VectorSpace(self.base(), [self.element(bidegree, b) for b in self.dell_and_delbar_cocycles(bidegree, raw=True).basis()])

    def dell_and_delbar_cocycles_raw(self, bidegree):
        return self.dell_and_delbar_cocycles(bidegree, raw=True)

    def dell_and_delbar_cocycles_inclusion(self, bidegree):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        else:
            dell_and_delbar_cocycles = self.dell_and_delbar_cocycles(bidegree, raw=True).basis()
            n = len(dell_and_delbar_cocycles)
            matrix = Matrix(self.base(), self.dimension(bidegree), n)
            for i in range(n):
                for j in range(self.dimension(bidegree)):
                    matrix[j,i] = dell_and_delbar_cocycles[i][j]
            return matrix

    def dell_and_delbar_cocycles_projection(self, bidegree):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        else:
            dell_and_delbar_cocycles = self.dell_and_delbar_cocycles(bidegree, raw=True)
            basis = list(dell_and_delbar_cocycles.gens())
            n = len(basis)
            for i in range(self.dimension(bidegree)):
                v = vector([int(i == j) for j in range(self.dimension(bidegree))])
                if v not in dell_and_delbar_cocycles:
                    basis += [v]
            change_basis = Matrix(self.base(), self.dimension(bidegree), basis)
            projection = Matrix(self.base(), n, self.dimension(bidegree))
            for i in range(n):
                projection[i,i] = 1
            return projection * change_basis

    def dell_cohomology_basis(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            return self.dell_cohomology(bidegree, raw=True).basis()
        else:
            dell_cohomology_raw = self.dell_cohomology(bidegree, raw=True)
            raw_basis = [dell_cohomology_raw.lift(b) for b in dell_cohomology_raw.basis()]
            return ['[{}]'.format(self.element(bidegree, b)) for b in raw_basis]

    def dell_cohomology(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__dell_cohomology:
                self.__dell_cohomology[bidegree] = self.dell_cocycles(bidegree, raw=True)/self.dell_coboundaries(bidegree, raw=True)
            return self.__dell_cohomology[bidegree]
        else:
            return VectorSpace(self.base(), self.dell_cohomology_basis(bidegree))

    def dell_cohomology_raw(self, bidegree):
        return self.dell_cohomology(bidegree, raw=True)

    def delbar_cohomology_basis(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            return self.delbar_cohomology(bidegree, raw=True).basis()
        else:
            delbar_cohomology_raw = self.delbar_cohomology(bidegree, raw=True)
            raw_basis = [delbar_cohomology_raw.lift(b) for b in delbar_cohomology_raw.basis()]
            return ['[{}]'.format(self.element(bidegree, b)) for b in raw_basis]

    def delbar_cohomology(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__delbar_cohomology:
                self.__delbar_cohomology[bidegree] = self.delbar_cocycles(bidegree, raw=True)/self.delbar_coboundaries(bidegree, raw=True)
            return self.__delbar_cohomology[bidegree]
        else:
            return VectorSpace(self.base(), self.dell_cohomology_basis(bidegree))

    def delbar_cohomology_raw(self, bidegree):
        return self.delbar_cohomology(bidegree, raw=True)

    def bottchern_cohomology_basis(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            return self.bottchern_cohomology(bidegree, raw=True).basis()
        else:
            bottchern_cohomology_raw = self.bottchern_cohomology(bidegree, raw=True)
            raw_basis = [bottchern_cohomology_raw.lift(b) for b in bottchern_cohomology_raw.basis()]
            return ['[{}]'.format(self.element(bidegree, b)) for b in raw_basis]

    def bottchern_cohomology(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__bottchern_cohomology:
                self.__bottchern_cohomology[bidegree] = (self.dell_cocycles(bidegree, raw=True).intersection(self.delbar_cocycles(bidegree, raw=True)))/self.delldelbar_coboundaries(bidegree, raw=True)
            return self.__bottchern_cohomology[bidegree]
        else:
            return VectorSpace(self.base(), self.bottchern_cohomology_basis(bidegree))

    def bottchern_cohomology_raw(self, bidegree):
        return self.bottchern_cohomology(bidegree, raw=True)

    def aeppli_cohomology_basis(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            return self.aeppli_cohomology(bidegree, raw=True).basis()
        else:
            aeppli_cohomology_raw = self.aeppli_cohomology(bidegree, raw=True)
            raw_basis = [aeppli_cohomology_raw.lift(b) for b in aeppli_cohomology_raw.basis()]
            return ['[{}]'.format(self.element(bidegree, b)) for b in raw_basis]

    def aeppli_cohomology(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__aeppli_cohomology:
                self.__aeppli_cohomology[bidegree] = self.delldelbar_cocycles(bidegree, raw=True) / (self.dell_coboundaries(bidegree, raw=True) + self.delbar_coboundaries(bidegree, raw=True))
            return self.__aeppli_cohomology[bidegree]
        else:
            return VectorSpace(self.base(), self.aeppli_cohomology_basis(bidegree))

    def aeppli_cohomology_raw(self, bidegree):
        return self.aeppli_cohomology(bidegree, raw=True)

    def reduced_bottchern_cohomology_basis(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            return self.reduced_bottchern_cohomology(bidegree, raw=True).basis()
        else:
            reduced_bottchern_cohomology_raw = self.reduced_bottchern_cohomology(bidegree, raw=True)
            raw_basis = [reduced_bottchern_cohomology_raw.lift(b) for b in reduced_bottchern_cohomology_raw.basis()]
            return ['[{}]'.format(self.element(bidegree, b)) for b in raw_basis]

    def reduced_bottchern_cohomology(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__reduced_bottchern_cohomology:
                self.__reduced_bottchern_cohomology[bidegree] = (self.dell_coboundaries_raw(bidegree).intersection(self.delbar_cocycles_raw(bidegree)) + self.delbar_coboundaries_raw(bidegree).intersection(self.dell_cocycles_raw(bidegree))) / self.delldelbar_coboundaries_raw(bidegree)
            return self.__reduced_bottchern_cohomology[bidegree]
        else:
            return VectorSpace(self.base(), self.reduced_bottchern_cohomology_basis(bidegree))

    def reduced_bottchern_cohomology_raw(self, bidegree):
        return self.reduced_bottchern_cohomology(bidegree, raw=True)

    def reduced_aeppli_cohomology_basis(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            return self.reduced_aeppli_cohomology(bidegree, raw=True).basis()
        else:
            reduced_aeppli_cohomology_raw = self.reduced_aeppli_cohomology(bidegree, raw=True)
            raw_basis = [reduced_aeppli_cohomology_raw.lift(b) for b in reduced_aeppli_cohomology_raw.basis()]
            return ['[{}]'.format(self.element(bidegree, b)) for b in raw_basis]

    def reduced_aeppli_cohomology(self, bidegree, raw=False):
        if bidegree not in self.bidegrees():
            raise ValueError("The bigraded complex does not have bidegree " + str(bidegree))
        elif raw == True or self.names() == None:
            if bidegree not in self.__reduced_aeppli_cohomology:
                self.__reduced_aeppli_cohomology[bidegree] = self.delldelbar_cocycles(bidegree, raw=True) / (self.dell_coboundaries(bidegree, raw=True) + self.delbar_coboundaries(bidegree, raw=True) + self.dell_cocycles(bidegree, raw=True).intersection(self.delbar_cocycles(bidegree, raw=True)))
            return self.__reduced_aeppli_cohomology[bidegree]
        else:
            return VectorSpace(self.base(), self.reduced_aeppli_cohomology_basis(bidegree))

    def reduced_aeppli_cohomology_raw(self, bidegree):
        return self.reduced_aeppli_cohomology(bidegree, raw=True)
    
    def zigzags_basis(self, bidegree=None, raw=False):
        if bidegree != None:
            if bidegree not in self.__zigzags_basis:
                reduced_aeppli = self.reduced_aeppli_cohomology_raw(bidegree)
                bottchern = self.bottchern_cohomology_raw(bidegree)
                self.__zigzags_basis[bidegree] = [reduced_aeppli.lift(b) for b in reduced_aeppli.basis()] + [bottchern.lift(b) for b in bottchern.basis()]
            if raw == True or self.names() == None:
                return self.__zigzags_basis[bidegree]
            else:
                return [self.element(bidegree, b) for b in self.__zigzags_basis[bidegree]]
        else:
            for bidegree in self.bidegrees():
                self.zigzags_basis(bidegree=bidegree, raw=True)
            if raw == True:
                return self.__zigzags_basis
            else:
                return {bidegree: [self.element(bidegree, b) for b in self.__zigzags_basis[bidegree]] for bidegree in self.bidegrees()}

    def zigzags(self, bidegree=None, raw=False):
        if bidegree != None:
            if raw == True or self.names() == None:
                return VectorSpace(self.base(), self.dimension(bidegree)).subspace(self.zigzags_basis(bidegree, raw=True))
            else:
                return VectorSpace(self.base(), self.zigzags_basis(bidegree))
        else:
            return {bidegree: self.zigzags(bidegree=bidegree, raw=raw) for bidegree in self.bidegrees()}        

    def zigzags_decomposition(self, raw=False):
        if raw == True:
            endpoints_redundant = {}
            for bidegree in self.bidegrees():
                complementary_basis = []
                dell_coboundaries = list(self.dell_coboundaries(bidegree=bidegree, raw=True).basis())
                for i in range(self.dimension(bidegree)):
                    v = vector([i == j for j in range(self.dimension(bidegree))])
                    if v not in VectorSpace(self.base(), self.dimension(bidegree)).subspace(dell_coboundaries + complementary_basis):
                        complementary_basis.append(v)
                endpoints_redundant[bidegree] = self.zigzags(bidegree=bidegree, raw=True).intersection(self.delbar_cocycles(bidegree=bidegree, raw=True)).intersection(VectorSpace(self.base(), self.dimension(bidegree)).subspace(complementary_basis))
            endpoints = {bidegree: VectorSpace(self.base(), self.dimension(bidegree)).subspace(endpoints_redundant[bidegree]).basis() for bidegree in endpoints_redundant}
            zigzags = []
            for bidegree in endpoints:
                for endpoint in endpoints[bidegree]:
                    zigzag = self.find_zigzag(bidegree, endpoint, raw=True)
                    # TODO: Check if there are zigzags that become linearly dependent at some point
                    # AQUÍ CAL AFEGIR-HI ALGO! ALTRAMENT ESTÀ MALAMENT LA FUNCIÓ...
                    zigzags.append(zigzag)
            return zigzags
        else:
            zigzags_raw = self.zigzags_decomposition(raw=True)
            return [{bidegree: self.element(bidegree, zigzag[bidegree]) for bidegree in zigzag} for zigzag in zigzags_raw]

    def find_zigzag(self, bidegree, coordinates, raw=False, previous_data={}):
        if raw == True:
            (p,q) = bidegree
            if coordinates in self.dell_and_delbar_cocycles(bidegree, raw=True):
                # It is a sink
                if previous_data == {}:
                    zigzag = {bidegree:coordinates}
                else:
                    zigzag = previous_data
                next_source = self.__next_source(bidegree, coordinates)
                if next_source != 0:
                    zigzag[(p,q-1)] = next_source
                    zigzag = self.find_zigzag((p,q-1), next_source, raw=True, previous_data=zigzag)
            elif coordinates in self.delldelbar_cocycles(bidegree, raw=True):
                # It is a source
                if previous_data == {}:
                    zigzag = {bidegree:coordinates}
                else:
                    zigzag = previous_data
                next_sink = self.__next_sink(bidegree, coordinates)
                if next_sink != 0:
                    zigzag[(p+1,q)] = next_sink
                    zigzag = self.find_zigzag((p+1,q), next_sink, raw=True, previous_data=zigzag)
            return zigzag
        if raw == False:
            raw_zigzag = self.find_zigzag(bidegree, coordinates, raw=True, zigzag={})
            return {bidegree: self.element(bidegree, raw_zigzag[bidegree]) for bidegree in raw_zigzag}

    def __next_source(self, bidegree, element):
        (p,q) = bidegree
        try: return self.delbar((p,q-1)).solve_right(element)
        except: return 0

    def __next_sink(self, bidegree, element):
        return self.dell(bidegree)*element

    def zigzags_inclusion(self, bidegree):
        zigzags = self.zigzags_basis(bidegree, raw=True)
        return Matrix(self.__base, len(zigzags), self.__dimension[bidegree], [z for z in zigzags]).transpose()
    
    def zigzags_projection(self, bidegree):
        zigzags = self.zigzags_basis(bidegree, raw=True)
        n = len(zigzags)
        change_basis = Matrix(self.base(), self.dimension(bidegree), [z for z in zigzags] + [s for s in self.squares_basis(bidegree, raw=True)]).transpose().inverse()
        projection = Matrix(self.base(), n, self.dimension(bidegree))
        for i in range(n):
            projection[i,i] = 1
        return projection*change_basis
    
    def squares_basis(self, bidegree=None, raw=False):
        if bidegree != None:
            if bidegree not in self.__squares_basis:
                zigzags_basis = self.zigzags_basis(bidegree, raw=True)
                self.__squares_basis[bidegree] = []
                for i in range(self.dimension(bidegree)):
                    v = vector([int(i==j) for j in range(self.dimension(bidegree))])
                    if v not in VectorSpace(self.base(), self.dimension(bidegree)).subspace(zigzags_basis + self.__squares_basis[bidegree]):
                        self.__squares_basis[bidegree] += [v]
            if raw == True or self.names() == None:
                return self.__squares_basis[bidegree]
            else:
                return [self.element(bidegree, b) for b in self.squares_basis(bidegree, raw=True)]
        else:
            for bidegree in self.bidegrees():
                self.squares_basis(bidegree=bidegree, raw=True)
            if raw == True:
                return self.__squares_basis
            else:
                return {bidegree: [self.element(bidegree, b) for b in self.__squares_basis[bidegree]] for bidegree in self.bidegrees()}

    def squares(self, bidegree=None, raw=False):
        if bidegree != None:
            if raw == True or self.__names == None:
                return VectorSpace(self.base(), self.dimension(bidegree)).subspace(self.squares_basis(bidegree, raw=True))
            else:
                return VectorSpace(self.base(), self.squares_basis(bidegree))
        else:
            return {bidegree: self.squares(bidegree=bidegree, raw=raw) for bidegree in self.bidegrees()}

    def squares_decomposition(self, raw=False):
        if raw == True:
            squares = self.squares_basis(raw=True)
            decomposition = []
            computed_squares = {bidegree: [] for bidegree in squares}
            zigzags = self.zigzags_basis(raw=True)
            for (p,q) in squares:
                for vertex in squares[(p,q)]:
                    if self.delldelbar((p,q))*vertex != 0 and vertex not in VectorSpace(self.base(), self.dimension((p,q))).subspace(zigzags[(p,q)] + computed_squares[(p,q)]):
                        dell = self.dell((p,q))*vertex
                        delbar = self.delbar((p,q))*vertex
                        delldelbar = self.delldelbar((p,q))*vertex
                        square = {(p,q): vertex, (p+1,q): dell, (p,q+1): delbar, (p+1,q+1): delldelbar}
                        computed_squares[(p,q)].append(vertex)
                        computed_squares[(p+1,q)].append(dell)
                        computed_squares[(p,q+1)].append(delbar)
                        computed_squares[(p+1,q+1)].append(delldelbar)
                        decomposition.append(square)
            return decomposition                    
        else:
            return [{bidegree: self.element(bidegree, square[bidegree]) for bidegree in square} for square in self.squares_decomposition(raw=True)]

class BidifferentialBigradedCommutativeAlgebra(BigradedComplex):
    def __init__(self, algebra, dell_dictionary, delbar_dictionary, min_deg, max_deg):    
        self.__zigzags = None
        self.__algebra = algebra
        self.__min_deg = min_deg
        self.__max_deg = max_deg

        dictionary_is_matrix = (dell_dictionary[list(dell_dictionary.keys())[0]] not in algebra)

        bigraded_basis = {}
        if dictionary_is_matrix:
            dell_matrix = dell_dictionary
            delbar_matrix = delbar_dictionary
        else:
            dell_matrix = {}
            delbar_matrix = {}
        for p in range(self.__min_deg, self.__max_deg+1):
            for q in range(self.__min_deg, self.__max_deg+1):
                basis = self.__algebra.basis((p,q))
                if basis != []:
                    bigraded_basis[(p,q)] = basis

                    # Compute the differential matrices
                    if not dictionary_is_matrix:
                        dell_matrix[(p,q)] = self.__algebra.differential(dell_dictionary).differential_matrix_multigraded((p,q)).transpose()
                        delbar_matrix[(p,q)] = self.__algebra.differential(delbar_dictionary).differential_matrix_multigraded((p,q)).transpose()

        BigradedComplex.__init__(self, self.__algebra.base(), dell_matrix, delbar_matrix, names=bigraded_basis)

    def algebra(self):
        return self.__algebra
    def min_deg(self):
        return self.__min_deg
    def max_deg(self):
        return self.__max_deg

    def subalgebra(self, subalgebra_generators):
        dell_generators = []
        delbar_generators = []
        delldelbar_generators = []                
        names = ["x" + str(i) for i in range(len(subalgebra_generators))]
        dell_names = []
        delbar_names = []
        delldelbar_names = []
        bidegrees = [generator.degree() for generator in subalgebra_generators]
        dell_bidegrees = []
        delbar_bidegrees = []
        delldelbar_bidegrees = []
        index = 0
        for generator in subalgebra_generators:
            (p,q) = generator.degree()
            if (p+1,q) in self.bidegrees() and self.dell((p,q))*vector(generator.basis_coefficients()) != 0:
                dell_generators += [self.element((p+1,q), self.dell((p,q))*vector(generator.basis_coefficients()))]
                dell_names += ["y" + str(index)]
                dell_bidegrees += [(p+1,q)]
            if (p,q+1) in self.bidegrees() and self.delbar((p,q))*vector(generator.basis_coefficients()) != 0:
                delbar_generators += [self.element((p,q+1), self.delbar((p,q))*vector(generator.basis_coefficients()))]
                delbar_names += ["z" + str(index)]
                delbar_bidegrees += [(p,q+1)]
            if (p+1,q+1) in self.bidegrees() and self.delldelbar((p,q))*vector(generator.basis_coefficients()) != 0:
                delldelbar_generators += [self.element((p+1,q+1), self.delldelbar((p,q))*vector(generator.basis_coefficients()))]
                delldelbar_names += ["w" + str(index)]
                delldelbar_bidegrees += [(p+1,q+1)]
            index += 1
        bidegrees = bidegrees + dell_bidegrees + delbar_bidegrees + delldelbar_bidegrees
        generators = subalgebra_generators + dell_generators + delbar_generators + delldelbar_generators
        names = names + dell_names + delbar_names + delldelbar_names

        # Order the generators according to their total degree (required for GradedCommutativeAlgebra)
        total_degrees = {}
        for i in range(len(generators)):
            (p,q) = bidegrees[i]
            if p+q in total_degrees:
                total_degrees[p+q] += [i]
            else:
                total_degrees[p+q] = [i]
        ordered_total_degrees = list(total_degrees.keys())
        ordered_total_degrees.sort()
        ordered_bidegrees = []
        ordered_generators = []
        names_str = ""
        for total_degree in ordered_total_degrees:
            for i in total_degrees[total_degree]:
                ordered_bidegrees += [generators[i].degree()]
                ordered_generators += [generators[i]]
                names_str += names[i] + ","
        names_str = names_str[:-1]

        # Algebra that maps to the initial algebra. The quotient of A by the kernel of the map will give the subalgebra
        A = GradedCommutativeAlgebra(self.__algebra.base(), names=names_str, degrees=ordered_bidegrees)

        # Compute the kernel of the map A --> algebra
        inclusion = Hom(A, self.algebra())(ordered_generators)
        inclusion_matrix = {}
        section_matrix = {}
        ideal = []
        for bidegree in self.bidegrees():
            image_space = VectorSpace(self.base(), self.algebra().basis(bidegree))
            inclusion_matrix[bidegree] = Matrix(self.base(), [inclusion(u).basis_coefficients() if inclusion(u) != 0 else vector([0 for _ in range(self.dimension(bidegree))]) for u in A.basis(bidegree)]).transpose()
            section_matrix[bidegree] = inclusion_matrix[bidegree].pseudoinverse()
            kernel = inclusion_matrix[bidegree].right_kernel().basis()
            ideal += [sum(c*b for (c,b) in zip(u, A.basis(bidegree))) for u in kernel]

        # Quotient
        B = A.quotient(A.ideal(ideal))
        projection = {}
        lift = {}
        for bidegree in self.bidegrees():
            if A.basis(bidegree) != []:
                if B.basis(bidegree) == []:
                    projection[bidegree] = Matrix(self.base(), 0, len(A.basis(bidegree)))
                else:
                    projection[bidegree] = Matrix(self.base(), [B(u).basis_coefficients() if B(u) != 0 else vector(0 for _ in range(len(B.basis(bidegree)))) for u in A.basis(bidegree)]).transpose()
            if B.basis(bidegree) != []:
                if A.basis(bidegree) == []:
                    lift[bidegree] = Matrix(self.base(), 0, len(B.basis(bidegree)))
                else:
                    lift[bidegree] = Matrix(self.base(), [A(u.lift()).basis_coefficients() if u.lift() != 0 else vector([0 for _ in range(len(A.basis(bidegree)))]) for u in B.basis(bidegree)]).transpose()

        # Compute dell and delbar
        dell = {}
        delbar = {}
        for (p,q) in self.bidegrees():
            if B.basis((p,q)) != []:
                if B.basis((p+1,q)) == []:
                    dell[(p,q)] = Matrix(self.base(), 0, len(B.basis((p,q))))
                else:
                    dell[(p,q)] = projection[(p+1,q)]*section_matrix[(p+1,q)]*self.dell((p,q))*inclusion_matrix[(p,q)]*lift[(p,q)]
                if B.basis((p,q+1)) == []:
                    delbar[(p,q)] = Matrix(self.base(), 0, len(B.basis((p,q))))
                else:
                    delbar[(p,q)] = projection[(p,q+1)]*section_matrix[(p,q+1)]*self.delbar((p,q))*inclusion_matrix[(p,q)]*lift[(p,q)]

        # Dictionary that realizes the elements in B as elements in the original algebra
        dictionary = {}
        for bidegree in self.bidegrees():
            for u in B.basis(bidegree):
                dictionary[u] = inclusion(A(u.lift()))

        return BidifferentialBigradedCommutativeAlgebra(B, dell, delbar, self.__min_deg, self.__max_deg), dictionary

    @staticmethod
    def from_nilmanifold(lie_algebra, ac_structure, labels=None, normalization_coefficients=None, latex_generators=None):
        original_generators = lie_algebra.gens()
        dimension = len(original_generators)
        if normalization_coefficients == None:
            normalization_coefficients = [1 for _ in range(dimension)]
        if dimension % 2 == 1:
            raise "The Lie algebra must be even-dimensional."
        elif dimension == 0:
            return BidifferentialBigradedCommutativeAlgebra.unit(lie_algebra.base())
        else:
            if labels == None:
                labels = ['a%s' %j for j in range(dimension/2)]+['b%s' %j for j in range(dimension/2)]

            eigenvectors = ac_structure.eigenvectors_right()
            if (eigenvectors[0][0] == I):
                basis_coefficients = eigenvectors[0][1] + eigenvectors[1][1]
            else:
                basis_coefficients = eigenvectors[1][1] + eigenvectors[0][1]
            
            basis = [normalization_coefficients[i]*sum(basis_coefficients[i][j] * original_generators[j] for j in range(dimension)) for i in range(dimension)]
            change_basis = Matrix(lie_algebra.base(), dimension, dimension, basis_coefficients).transpose().inverse()

            # Define GradedCommutativeAlgebra
            algebra = GradedCommutativeAlgebra(lie_algebra.base(), names=labels, degrees=tuple([(1,0) for _ in range(dimension/2)]+[(0,1) for _ in range(dimension/2)]))
            generators = algebra.gens()

            # Compute the differentials of the Chevalley-Eilenberg bigraded algebra
            dell_dict = {g: 0 for g in generators}
            delbar_dict = {g: 0 for g in generators}
            value = {}
            for k in range(dimension/2):
                for i in range(dimension/2):
                    for j in range(i+1, dimension/2):
                        if (i,j) not in value:
                            value[(i,j)] = -change_basis*vector(lie_algebra.bracket(basis[i], basis[j]))
                        dell_dict[generators[k]] += value[(i,j)][k]*generators[i]*generators[j]
                    for j in range(dimension/2, dimension):
                        if (i,j) not in value:
                            value[(i,j)] = -change_basis*vector(lie_algebra.bracket(basis[i], basis[j]))
                        delbar_dict[generators[k]] += value[(i,j)][k]*generators[i]*generators[j]
            for k in range(dimension/2, dimension):
                for i in range(dimension/2):
                    for j in range(dimension/2, dimension):
                        if (i,j) not in value:
                            value[(i,j)] = -change_basis*vector(lie_algebra.bracket(basis[i], basis[j]))
                        dell_dict[generators[k]] += value[(i,j)][k]*generators[i]*generators[j]
                for i in range(dimension/2, dimension):
                    for j in range(i+1, dimension):
                        if (i,j) not in value:
                            value[(i,j)] = -change_basis*vector(lie_algebra.bracket(basis[i], basis[j]))
                        delbar_dict[generators[k]] += value[(i,j)][k]*generators[i]*generators[j]

            return BidifferentialBigradedCommutativeAlgebra(algebra, dell_dict, delbar_dict, 0, dimension)

class BidifferentialBigradedCommutativeAlgebraExample():
    __QQi = QuadraticField(-1, 'I')

    @staticmethod
    def KodairaThurston(acs = None, names = None):
        lie_algebra = LieAlgebra(BidifferentialBigradedCommutativeAlgebraExample.__QQi, 'X,Y,Z,W', {
            ('X','Y'): {'Z':-1}
        })
        if acs == None:
            acs = Matrix(BidifferentialBigradedCommutativeAlgebraExample.__QQi,4,[
                [0,-1,0,0],
                [1,0,0,0],
                [0,0,0,-1],
                [0,0,1,0]
            ])
        if names == None:
            names = ['a', 'b', 'abar', 'bbar']
        return BidifferentialBigradedCommutativeAlgebra.from_nilmanifold(lie_algebra, acs, names)

    @staticmethod
    def Iwasawa(acs = None, names = None):
        lie_algebra = LieAlgebra(BidifferentialBigradedCommutativeAlgebraExample.__QQi, 'p,ip,q,iq,z,iz', {
            ('p','q'): {'z':1},
            ('p', 'iq'): {'iz':1},
            ('ip','q'): {'iz':1},
            ('ip', 'iq'): {'z':-1}
        })
        if acs == None:
            acs = Matrix(BidifferentialBigradedCommutativeAlgebraExample.__QQi,6,[
                [0,1,0,0,0,0],
                [-1,0,0,0,0,0],
                [0,0,0,1,0,0],
                [0,0,-1,0,0,0],
                [0,0,0,0,0,1],
                [0,0,0,0,-1,0]
            ])
        if names == None:
            names = ['a','b','c','abar','bbar','cbar']
        return BidifferentialBigradedCommutativeAlgebra.from_nilmanifold(lie_algebra, acs, names, normalization_coefficients=[1/2,1,1,1/2,1,1])

    @staticmethod
    def ST_nilmanifold():
        Iwasawa = BidifferentialBigradedCommutativeAlgebraExample.Iwasawa()
        basis = []
        for bidegree in Iwasawa.bidegrees():
            basis += Iwasawa.algebra().basis(bidegree)
        
        generators = [basis[11], basis[15], basis[19], basis[14], basis[12], basis[22], basis[41], basis[56], basis[7]]
        return Iwasawa.subalgebra(generators)

def build(dim, lie_names, lie_bracket, acs_matrix, acs_names, normalization_coefficients=None):
    bfield = QuadraticField(-1, 'I')

    lie_algebra = LieAlgebra(bfield, lie_names, lie_bracket)
    acs = Matrix(bfield, dim, acs_matrix)

    return BidifferentialBigradedCommutativeAlgebra.from_nilmanifold(lie_algebra, acs, acs_names, normalization_coefficients)

def mapByBidegree(bbc : BigradedComplex, method: str):
    return {
        str(bidegree): list(map(lambda a: str(a), getattr(bbc, method)(bidegree)))
        for bidegree in bbc.bidegrees()
    }

def compute(dim, lie_names, lie_bracket, acs_matrix, acs_names, norm):
    import json
    lie_bracket = {tuple(k.split(",")): v for  k, v in lie_bracket.items()}
    normalization_coefficients = list(map(QQ, norm)) if norm else None
    bbc = build(dim, lie_names, lie_bracket, acs_matrix, acs_names, normalization_coefficients)
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