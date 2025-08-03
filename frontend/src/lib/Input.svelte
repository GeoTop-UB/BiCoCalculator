<script>
  import { math } from 'mathlifier';
  import KT from '../assets/KT.json'

  let { data = $bindable() } = $props();

  // async function loadData() {

  // }
  // const apiUrl = "http://127.0.0.1:5001/";
  // const response = await fetch(apiUrl);
  // KT = await response.json();
  data = {
    "n": KT.n,
    "m": KT.m,
    "cohomology_aeppli": KT.cohomology.aeppli,
    "cohomology_bottchern": KT.cohomology.bottchern,
    "cohomology_delbar": KT.cohomology.delbar,
    "cohomology_dell": KT.cohomology.dell,
    "cohomology_reduced_aeppli": KT.cohomology.reduced_aeppli,
    "cohomology_reduced_bottchern": KT.cohomology.reduced_bottchern,
    "zigzags": KT.zigzags,
    "squares": KT.squares
  };
</script>

<section>
  <p>Kodaira-Thurston manifold</p>
  <p>Iwasawa manifold</p>
  <p>Testing</p>
  <p>Custom nilmanifold</p>
  Real Lie algebra
  Complex structure
</section>

<style>
  section {
    width: 30%;
    /* border-right: 1px black solid; */
    box-shadow: 3px 0 1px -2px rgba(0, 0, 0, .2), 3px 0 5px 0 rgba(0, 0, 0, .12), 3px 0 2px 0 rgba(0, 0, 0, .14)
  }
</style>