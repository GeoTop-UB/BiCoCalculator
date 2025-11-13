# BiCoCalculator<br><sub><sup>Web application for Computing Invariants of Bigraded Complexes</sup></sub>

This web application is aimed at computing and displaying invariants of bigraded complexes, in particular from complex nilmanifolds. It is based on [BiCo](https://github.com/GeoTop-UB/BiCo), a Sage script for Computing Invariants of Bigraded Complexes developed by Roger Garrido Vilallave. Its main goals are the display of:

- Dolbeault, anti-Dolbeault, Bott-Chern and Aeppli cohomologies, and
- Zigzags and squares decomposition.

It has been funded by the project **Europa Excelencia "Homotopical Invariants of Almost Complex Manifolds" (EUR2023-143450) of the Spanish State Research Agency**.

![Screenshot of the web application BiCoCalculator running](Screenshot.png)

## Set up

The easy way to use the application is to install [Nix](https://nixos.org/). The server of the application can be spawn with the command:

```shell
make
```

Then you can open [http://localhost:4173](http://localhost:4173) to see the web application.
